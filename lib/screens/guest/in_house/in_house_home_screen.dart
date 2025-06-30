import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para copiar al portapapeles

class InHouseHomeScreen extends StatelessWidget {
  const InHouseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Estancia'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Lógica para ver notificaciones
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECCIÓN DE BIENVENIDA ---
              Text(
                '¡Hola de nuevo, Juan!', // Nombre del huésped (simulado)
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Esperamos que disfrutes tu estancia.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // --- WIDGET DE INFORMACIÓN CLAVE ---
              const _KeyInfoCard(),

              const SizedBox(height: 32),

              // --- SECCIÓN DE ACCESOS RÁPIDOS ---
              Text('Accesos Rápidos', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _QuickActionButton(icon: Icons.room_service, label: 'Room Service'),
                  _QuickActionButton(icon: Icons.cleaning_services, label: 'Limpieza'),
                  _QuickActionButton(icon: Icons.spa, label: 'Spa'),
                  _QuickActionButton(icon: Icons.chat_bubble_outline, label: 'Chat'),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // --- WIDGET DEL CLIMA ---
               Text('Clima Local', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
               const SizedBox(height: 16),
              const _WeatherWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---
// Estos widgets viven en el mismo archivo para simplificar, pero en un proyecto
// más grande podrían ir en su propia carpeta de 'widgets'.

/// Tarjeta con la información más importante para el huésped.
class _KeyInfoCard extends StatelessWidget {
  const _KeyInfoCard();

  @override
  Widget build(BuildContext context) {
    const wifiPassword = 'VistaAlMar2025';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.meeting_room_outlined, color: Theme.of(context).colorScheme.primary),
              title: const Text('Tu Habitación'),
              subtitle: const Text('Master Suite en Piso Alto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              trailing: const Text('302', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(indent: 20, endIndent: 20),
            ListTile(
              leading: Icon(Icons.wifi, color: Theme.of(context).colorScheme.primary),
              title: const Text('Clave Wi-Fi'),
              subtitle: const Text(wifiPassword, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              trailing: IconButton(
                icon: const Icon(Icons.copy_all_outlined),
                onPressed: () {
                  // Lógica para copiar la clave al portapapeles
                  Clipboard.setData(const ClipboardData(text: wifiPassword));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contraseña de Wi-Fi copiada')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Un botón circular para las acciones más comunes.
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(40),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(icon, size: 30, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

/// Una tarjeta simple para mostrar el clima local.
class _WeatherWidget extends StatelessWidget {
  const _WeatherWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            const Icon(Icons.wb_sunny, color: Colors.amber, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('29°C Soleado', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Sensación térmica: 32°C', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}