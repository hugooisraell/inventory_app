import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  // Asegura que el binding de Flutter esté listo antes de usar APIs nativas/async
  WidgetsFlutterBinding.ensureInitialized();
  // Obtenemos SharedPreferences de forma síncrona antes de runApp
  final prefs = await SharedPreferences.getInstance();
  // Determinamos si hay sesión activa
  final hasSession = prefs.containsKey('userId');
  // Ejecutamos la app pasando la ruta inicial adecuada
  runApp(MyApp(initialRoute: hasSession ? '/home' : '/login'));
}

// Aplicacion principal
class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iventory App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/sales': (context) => const SalesScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/map': (context) => const MapScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
