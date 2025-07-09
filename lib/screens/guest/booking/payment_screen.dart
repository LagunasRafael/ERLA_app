import 'package:flutter/material.dart';
import '/models/room_type.dart';

class PaymentScreen extends StatefulWidget {
  final RoomType room;
  final DateTime startDate;
  final DateTime endDate;

  const PaymentScreen({
    super.key,
    required this.room,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  //variable de estado para controlar si la casilla está marcada.
  // La inicializamos en 'true' para animar al usuario a crear una cuenta.
  bool _createAccount = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos y Pago'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Datos personales
                Text('Datos del Huésped Principal', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre(s)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => (value == null || value.isEmpty) ? 'Introduce tu nombre' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Apellidos', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => (value == null || value.isEmpty) ? 'Introduce tus apellidos' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Introduce tu correo';
                    if (!value.contains('@')) return 'Introduce un correo válido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Número de Teléfono', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone_outlined)),
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? 'Introduce tu teléfono' : null,
                ),
                const Divider(height: 48),

                // --- SECCIÓN 2: DATOS DE PAGO ---
                Text('Datos de Pago', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Número de la tarjeta', border: OutlineInputBorder(), prefixIcon: Icon(Icons.credit_card)),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.isEmpty) ? 'Introduce el número de la tarjeta' : null,
                ),
                const SizedBox(height: 16),
                // (El resto de los campos de pago...)
                Row(
                  children: [
                    Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Vencimiento (MM/AA)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)), keyboardType: TextInputType.datetime, validator: (value) => (value == null || value.isEmpty) ? 'Inválido' : null)),
                    const SizedBox(width: 16),
                    Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'CVC', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)), keyboardType: TextInputType.number, obscureText: true, validator: (value) => (value == null || value.isEmpty) ? 'Inválido' : null)),
                  ],
                ),
                const Divider(height: 48),
                
                // --- SECCIÓN 3: CREACIÓN DE CUENTA (NUEVO) ---
                CheckboxListTile(
                  title: const Text('Crear una cuenta para gestionar mi reserva más fácilmente.'),
                  value: _createAccount,
                  onChanged: (newValue) {
                    // Usamos setState para que la UI se reconstruya cuando cambia el valor.
                    setState(() {
                      _createAccount = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading, // Pone el checkbox a la izquierda
                  contentPadding: EdgeInsets.zero,
                ),

                // Este campo de contraseña solo se muestra si _createAccount es true
                if (_createAccount)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Crear Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.password),
                      ),
                      obscureText: true,
                      validator: (value) {
                        // El validador solo se aplica si la opción de crear cuenta está activa.
                        if (_createAccount && (value == null || value.isEmpty)) {
                          return 'Por favor, crea una contraseña';
                        }
                        return null;
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Procesando Pago...')));
              //Lógica final de pago y navegación a la pantalla de confirmación.
            }
          },
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: const Text('Pagar y Confirmar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}