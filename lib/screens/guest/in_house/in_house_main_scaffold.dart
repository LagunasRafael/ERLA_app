import 'package:flutter/material.dart';
import 'my_stay_screen.dart';
import 'in_house_home_screen.dart';
import 'package:hotel_huesped_app/screens/guest/explore_screen.dart';
import 'room_service_main_screen.dart';

/// Este es el widget principal para la experiencia de un huésped que ya
/// tiene una reservación activa. Contiene la barra de navegación inferior
/// y gestiona qué pantalla se muestra.
class InHouseMainScaffold extends StatefulWidget {
  const InHouseMainScaffold({super.key});

  @override
  State<InHouseMainScaffold> createState() => _InHouseMainScaffoldState();
}

class _InHouseMainScaffoldState extends State<InHouseMainScaffold> {
  // Guarda el índice de la pestaña que está seleccionada actualmente.
  int _selectedIndex = 0;

  // Lista de las 4 pantallas principales para el huésped.
  // se reutiliza la pantalla 'ExploreScreen' que ya habíamos diseñado.
  static const List<Widget> _inHouseScreens = <Widget>[
    InHouseHomeScreen(),
    ExploreScreen(),
    RoomServiceMainScreen(),
    MyStayScreen(),
  ];

  // Esta función se llama cada vez que el usuario toca un ícono de la barra.
  void _onItemTapped(int index) {
    // setState notifica a Flutter que el estado ha cambiado y que debe
    // reconstruir la interfaz para reflejar el cambio.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // El widget Scaffold provee la estructura básica de la pantalla.
    return Scaffold(
      // El cuerpo de la pantalla será el widget que corresponda al índice seleccionado.
      body: _inHouseScreens.elementAt(_selectedIndex),

      // La barra de navegación inferior.
      bottomNavigationBar: NavigationBar(
        elevation: 3, // Una ligera sombra para darle profundidad.
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        // Los 4 destinos de nuestra barra de navegación para el huésped.
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.room_service_outlined),
            selectedIcon: Icon(Icons.room_service),
            label: 'Room Service',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_pin_circle_outlined),
            selectedIcon: Icon(Icons.person_pin_circle),
            label: 'Mi Estancia',
          ),
        ],
      ),
    );
  }
}