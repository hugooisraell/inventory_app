import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pantalla de Perfil de usuario
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Funcion para cerrar sesion
  Future<void> _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    prefs.remove('userName');
    prefs.remove('userEmail');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session successfully closed')),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar circular
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 20),

            // Nombre del usuario
            const Text(
              'Nombre del Usuario',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            // Email del usuario
            const Text(
              'usuario@ejemplo.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Divider(),

            // Opciones del perfil
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar perfil'),
              onTap: () {},
            ),

            const Divider(),

            const SizedBox(height: 20),

            // Boton de cerrar sesion
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              onPressed: _logOut,
              child: const Text('Log Out'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
