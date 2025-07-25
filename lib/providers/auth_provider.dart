import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _userHasActiveReservation = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  // Getters
  bool get userHasActiveReservation => _userHasActiveReservation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    setupAuthListener();
  }

  void _setReservationStatus(bool status) {
    if (_userHasActiveReservation != status) {
      _userHasActiveReservation = status;
      notifyListeners();
    }
  }

  void _setInitialized(bool value) {
    if (_isInitialized != value) {
      _isInitialized = value;
      notifyListeners();
    }
  }

  void _clearError() {
    _errorMessage = null;
  }

  void setupAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _checkReservationStatus(user.uid).then((_) {
          _setInitialized(true);
        });
      } else {
        _setReservationStatus(false);
        _setInitialized(true);
      }
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _setReservationStatus(false);
    _setInitialized(true);
  }

  Future<void> _checkReservationStatus(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>?;
        final hasReservation = userData?['hasActiveReservation'] ?? false;
        _setReservationStatus(hasReservation);
      } else {
        await _createUserDocument(userId);
        _setReservationStatus(false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al verificar reserva: $e');
      }
      _setReservationStatus(false);
    }
  }

  Future<void> _createUserDocument(String userId) async {
    await _firestore.collection('users').doc(userId).set({
      'hasActiveReservation': false,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        _errorMessage = 'No se pudo iniciar sesión. Usuario inválido.';
        return false;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        _errorMessage = 'Este usuario no está completamente registrado.';
        await _auth.signOut();
        return false;
      }

      await _checkReservationStatus(user.uid);
      notifyListeners();
      return true;

    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e);
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      _errorMessage = 'Error desconocido: $e';
      debugPrint('Unknown error during login: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'fullName': fullName,
        'hasActiveReservation': false,
        'createdAt': Timestamp.now(),
      });

      _setReservationStatus(false);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido';
    }
  }

  Future<void> signInWithGoogle() async {
    throw UnimplementedError('Google Sign-In no está implementado aún');
  }

  Future<void> signInWithApple() async {
    throw UnimplementedError('Apple Sign-In no está implementado aún');
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'invalid-email':
        return 'Email no válido';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
