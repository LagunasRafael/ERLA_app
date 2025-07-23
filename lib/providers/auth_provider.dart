import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _userHasActiveReservation = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Nuevo: bandera para saber si ya se consultó el estado de reserva al menos una vez
  bool _isInitialized = false;

  // Getters
  bool get userHasActiveReservation => _userHasActiveReservation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  // Actualizar estado de reserva
  void _setReservationStatus(bool status) {
    _userHasActiveReservation = status;
    notifyListeners();
  }

  // Actualizar estado de inicialización
  void _setInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  // Limpiar errores
  void _clearError() {
    _errorMessage = null;
  }

  // Constructor
  AuthProvider() {
    setupAuthListener();
  }

  void setupAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // Al iniciar sesión, checar reserva y luego marcar como inicializado
        _checkReservationStatus(user.uid).then((_) {
          _setInitialized(true);
        });
      } else {
        _setReservationStatus(false);
        _setInitialized(true); // Usuario no logeado también marca inicializado
      }
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners(); // Por si usas Consumer o estás reaccionando a cambios
  }

  // Método para consultar estado de reserva en Firestore
  Future<void> _checkReservationStatus(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

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

  // Métodos login, registro, logout igual que antes, no cambian...

  Future<bool> login(String email, String password) async {
  try {
    _isLoading = true;
    _clearError();
    notifyListeners();

    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      await _checkReservationStatus(userCredential.user!.uid);
      notifyListeners(); // <---- importante para actualizar UI
    }

    return true;
  } on FirebaseAuthException catch (e) {
    _errorMessage = _mapAuthError(e);
    return false;
  } catch (e) {
    _errorMessage = 'Error desconocido: $e';
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

    // Crear documento del usuario en Firestore
    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'fullName': fullName,
      'hasActiveReservation': false,
      'createdAt': Timestamp.now(),
    });

    _setReservationStatus(false); // ✅

    notifyListeners();
    return null;
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return 'Error desconocido';
  }
}


  

  Future<void> signInWithGoogle() async {
  // Aquí puedes poner un print o lanzar un error si quieres
  throw UnimplementedError('Google Sign-In no está implementado aún');
}

Future<void> signInWithApple() async {
  // Igual que arriba, por ahora solo un error o nada
  throw UnimplementedError('Apple Sign-In no está implementado aún');
}


  // Resto del código sigue igual...

  // Mapear errores a mensajes amigables
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
