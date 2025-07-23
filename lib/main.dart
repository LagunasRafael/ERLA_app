import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias para evitar conflicto
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hotel_huesped_app/providers/auth_provider.dart'; // Tu AuthProvider personalizado
import 'package:hotel_huesped_app/providers/cart_provider.dart';
import 'package:hotel_huesped_app/screens/guest/account_screen.dart';
import 'package:hotel_huesped_app/screens/guest/guest_main_scaffold.dart';
import 'package:hotel_huesped_app/screens/guest/in_house/in_house_main_scaffold.dart';
import 'firebase_options.dart';
import 'package:hotel_huesped_app/screens/guest/register_screen.dart';
import 'package:hotel_huesped_app/screens/guest/in_house/my_stay_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Tu AuthProvider personalizado
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const HotelApp(),
    ),
  );
}

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grand Hotel Nayar',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF455840),
          secondary: const Color(0xFF8A947F),
          background: const Color(0xFFECE9CE),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF455840),
          foregroundColor: Colors.white,
        ),
      ),
      home: StreamBuilder<firebase_auth.User?>(
  stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
  builder: (context, authSnapshot) {
    final authProvider = Provider.of<AuthProvider>(context);

    print('authSnapshot.hasData = ${authSnapshot.hasData}');
    print('userHasActiveReservation = ${authProvider.userHasActiveReservation}');

    if (authSnapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!authSnapshot.hasData) {
      return const AccountScreen();
    }

    return authProvider.userHasActiveReservation
      ? const InHouseMainScaffold()
      : const GuestMainScaffold();
  },
),

      routes: {
        '/account': (context) => const AccountScreen(),
        '/guest': (context) => const GuestMainScaffold(),
        '/in-house': (context) => const InHouseMainScaffold(),
        
        '/register': (context) => const RegisterScreen(),
        '/stay': (context) => const MyStayScreen(),
      },
    );
  }
}
