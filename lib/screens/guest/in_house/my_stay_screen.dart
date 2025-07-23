import 'package:flutter/material.dart';
import 'package:hotel_huesped_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyStayScreen extends StatelessWidget {
  const MyStayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Estancia'),
        centerTitle: true,
      ),
      // Usamos una ListView para que la pantalla sea deslizable si el contenido es mucho
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Tarjeta de Perfil de Usuario ---
          const _UserProfileCard(),
          const SizedBox(height: 24),

          // --- Sección de Detalles de la Reservación ---
          const _SectionHeader(title: 'Detalles de tu Reservación'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.king_bed_outlined),
                  title: const Text('Tipo de Habitación'),
                  subtitle: const Text('Master Suite en Piso Alto'),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Check-in'),
                  subtitle: const Text('Lunes, 30 de junio de 2025'),
                ),
                ListTile(
                  leading: const Icon(Icons.event_available_outlined),
                  title: const Text('Check-out'),
                  subtitle: const Text('Viernes, 4 de julio de 2025'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Sección de Estado de Cuenta ---
          const _SectionHeader(title: 'Estado de Cuenta'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Room Service (Ayer)'),
                  trailing: const Text('\$450.00'),
                ),
                ListTile(
                  title: const Text('Tratamiento de Spa'),
                  trailing: const Text('\$1,800.00'),
                ),
                ListTile(
                  title: const Text('Minibar'),
                  trailing: const Text('\$250.00'),
                ),
                const Divider(thickness: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text('Total Provisional', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(
                    '\$2,500.00 MXN',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // --- Botón de Check-Out ---
          FilledButton.tonal(
            onPressed: () {},
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 12),
                Text('Iniciar Check-Out Express', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          const SizedBox(height: 16),
FilledButton(
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.signOut();

      if (context.mounted) {
        await Provider.of<AuthProvider>(context, listen: false).signOut();
        Navigator.of(context).pushNamedAndRemoveUntil('/account', (route) => false);
      }
    }
  },
  style: FilledButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.error,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
  ),
  child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.logout),
      SizedBox(width: 12),
      Text('Cerrar Sesión', style: TextStyle(fontSize: 16)),
    ],
  ),
),

        ],
      ),
    );
  }
}


// --- WIDGETS AUXILIARES ---

/// Una tarjeta simple para mostrar la información del perfil del usuario.
class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          child: Icon(Icons.person),
        ),
        title: const Text('Juan Pérez', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('juan.perez@email.com'),
        trailing: TextButton(
          child: const Text('Editar'),
          onPressed: () {},
        ),
      ),
    );
  }
}

/// Un widget para los títulos de cada sección, para no repetir código.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}