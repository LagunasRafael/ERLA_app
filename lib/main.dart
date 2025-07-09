import 'package:flutter/material.dart';
import 'package:hotel_huesped_app/screens/guest/guest_main_scaffold.dart';
import '/screens/guest/in_house/in_house_main_scaffold.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:hotel_huesped_app/providers/cart_provider.dart';

// variable para el estado del usuario
bool userHasActiveReservation = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
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
  
    // paleta de colores.
    const Color darkGreen = Color(0xFF455840);
    const Color beige = Color(0xFFECE9CE);
    const Color sageGreen = Color(0xFF8A947F);
    const Color white = Color(0xFFFFFFFF);
    const Color black = Color(0xFF000000);

    final lightColorScheme = ColorScheme.light(
      primary: darkGreen,    // Color de ACCIÓN
      background: white,       // Color de FONDO
      surface: beige,        // Color de TARJETAS
      
      onPrimary: white,      // Texto sobre ACCIÓN
      onBackground: black,     // Texto sobre FONDO
      onSurface: darkGreen,    // Texto sobre TARJETAS
      
      secondary: sageGreen,    // Color de acento secundario
      onSecondary: white,      // Texto sobre el secundario
      error: Colors.redAccent,
      onError: white,
    );

    return MaterialApp(
      title: 'Hotel Grand Nayar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: lightColorScheme.background,
        cardTheme: CardTheme(
          color: lightColorScheme.surface,
          elevation: 2,
        ),
      ),
      // modo obsccuro
      // darkTheme: ThemeData(...) 
      themeMode: ThemeMode.light, // modo claro para ver cambios mas facil 
      home: userHasActiveReservation
          ? const InHouseMainScaffold()
          : const GuestMainScaffold(),
    );
  }
}