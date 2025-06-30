import 'package:flutter/material.dart';
import 'package:hotel_huesped_app/screens/guest/guest_home_screen.dart';
import 'package:hotel_huesped_app/screens/guest/rooms_screen.dart';
import 'package:hotel_huesped_app/screens/guest/explore_screen.dart';
import 'package:hotel_huesped_app/screens/guest/account_screen.dart';

class GuestMainScaffold extends StatefulWidget {
  const GuestMainScaffold({super.key});

  @override
  State<GuestMainScaffold> createState() => _GuestMainScaffoldState();
}

class _GuestMainScaffoldState extends State<GuestMainScaffold> {
  int _selectedIndex = 0;

  // Lista de las pantallas para cada pestaña
  static const List<Widget> _guestScreens = <Widget>[
    GuestHomeScreen(),
    RoomsScreen(),
    ExploreScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _guestScreens.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.bed_outlined),
            selectedIcon: Icon(Icons.bed),
            label: 'Habitaciones',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}