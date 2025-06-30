import 'package:flutter/material.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos 'SafeArea' para evitar que el contenido se superponga con la barra de estado del sistema.
    return Scaffold(
      // Usamos 'SingleChildScrollView' para que la pantalla sea desplazable en teléfonos pequeños.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SECCIÓN DE LA IMAGEN PRINCIPAL (HERO) ---
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                      'assets/images/fotohotel.jpg'), // Una imagen real para más impacto
                  fit: BoxFit.cover,
                  // Un gradiente oscuro para que el texto sea legible
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hotel Grand Nayar',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Donde cada estancia es una obra de arte.',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            // --- SECCIÓN DE CONTENIDO ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Una experiencia inolvidable te espera',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Descubre nuestras cómodas habitaciones, gastronomía única y la belleza de Nuevo Vallarta.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Botón principal (Call To Action)
                  FilledButton(
                    onPressed: () {
                      //Implementar navegación al flujo de reservación
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Reservar Ahora'),
                  ),
                  const SizedBox(height: 32),
                  // Placeholder para otras secciones como "Por qué elegirnos" o "Experiencias"
                  const Divider(),
                  const SizedBox(height: 16),
                  const Center(child: Text('Más contenido próximamente...')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}