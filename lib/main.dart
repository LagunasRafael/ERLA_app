import 'package:flutter/material.dart';
import 'package:hotel_huesped_app/screens/guest/guest_main_scaffold.dart';
import '/screens/guest/in_house/in_house_main_scaffold.dart'; // <-- Import correcto
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:hotel_huesped_app/providers/cart_provider.dart';

// Esta variable simula el estado de la reservación del usuario.
bool userHasActiveReservation = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  // Modificamos la función runApp para "proveer" nuestro CartProvider
  runApp(
    ChangeNotifierProvider(
      // Aquí se crea la instancia de nuestro CartProvider
      create: (context) => CartProvider(),
      // El child es nuestra aplicación principal, que ahora tendrá acceso al provider
      child: const HotelApp(),
    ),
  );
}

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff455840),
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
    );

    return MaterialApp(
      title: 'Hotel Grand Nayar',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: userHasActiveReservation
          ? const InHouseMainScaffold() // Ahora usará la versión importada
          : const GuestMainScaffold(),
    );
  }
}
// ¡YA NO HAY NADA MÁS DESPUÉS DE ESTO!