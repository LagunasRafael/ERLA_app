import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel_huesped_app/providers/auth_provider.dart'; // Importa tu AuthProvider
import 'package:hotel_huesped_app/screens/guest/register_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Para manejar el estado de carga

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  try {
    bool success = await Provider.of<AuthProvider>(context, listen: false).login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/in-house', (route) => false);
      }
    } else {
      final error = Provider.of<AuthProvider>(context, listen: false).errorMessage ?? 'Error desconocido';
      if (mounted) _showErrorDialog(context, error);
    }
  } catch (e) {
    if (mounted) _showErrorDialog(context, e.toString());
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Cuenta'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Bienvenido de Nuevo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para ver tus reservaciones.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),

                // --- FORMULARIO DE INICIO DE SESIÓN ---
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Introduce tu correo';
                    if (!value.contains('@')) return 'Correo inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Introduce tu contraseña';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // BOTÓN PRINCIPAL
                FilledButton(
                  onPressed: _isLoading ? null : () => _loginWithEmail(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Iniciar Sesión', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),

                // --- OPCIÓN DE REGISTRO ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                child: const Text("¿No tienes cuenta? Regístrate"),
),
                  ],
                ),
                const SizedBox(height: 24),

                // Separador
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('o'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // --- BOTONES DE INICIO DE SESIÓN SOCIAL ---
                _SocialLoginButton(
                  text: 'Continuar con Google',
                  iconPath: 'assets/images/google_logo.png',
                  onPressed: () => _loginWithGoogle(context),
                ),
                const SizedBox(height: 12),
                _SocialLoginButton(
                  text: 'Continuar con Apple',
                  iconPath: 'assets/images/apple_logo.png',
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  onPressed: () => _loginWithApple(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Métodos para autenticación social (implementar luego)
  Future<void> _loginWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).signInWithGoogle();
    } catch (e) {
      _showErrorDialog(context, 'Error con Google: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithApple(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).signInWithApple();
    } catch (e) {
      _showErrorDialog(context, 'Error con Apple: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

// Widget auxiliar para botones sociales (sin cambios)
class _SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const _SocialLoginButton({
    required this.text,
    required this.iconPath,
    required this.onPressed,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Image.asset(iconPath, height: 20, width: 20),
      label: Text(text),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}