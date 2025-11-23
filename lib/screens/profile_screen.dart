import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';

// Pantalla de Perfil de usuario
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userFstName;
  String? userLstName;
  String? userEmail;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  // Cargar datos de la sesion actual
  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userFstName = prefs.getString('userFstName');
      userLstName = prefs.getString('userLstName');
      userEmail = prefs.getString('userEmail');
      isLoading = false;
    });
  }

  // Funcion para cerrar sesion
  Future<void> _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia toda la sesión

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session successfully closed')),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar spinner mientras carga la sesión
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Nombre limpio
    final String displayName =
        "${userFstName ?? ''} ${userLstName ?? ''}".trim().isEmpty
        ? "User"
        : "${userFstName ?? ''} ${userLstName ?? ''}".trim();

    // Icono de usuario
    final String iconUser =
        "${userFstName ?? ''} ${userLstName ?? ''}".trim().isEmpty
        ? "U"
        : "${userFstName![0].toUpperCase()} ${userLstName![0].toUpperCase()}"
              .trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar circular
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              child: Text(
                iconUser,
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // Nombre completo
            Text(
              displayName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            // Email del usuario
            if (userEmail != null && userEmail!.trim().isNotEmpty)
              Text(
                userEmail!,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

            const SizedBox(height: 30),

            const Divider(),

            // Opciones del perfil
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                ).then((value) {
                  // cuando regresa de editar, recargar sesión
                  _loadSession();
                });
              },
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
