import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/db_service.dart';

// Pantalla de registro
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fstNameController = TextEditingController();
  final _lstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // controla la animación y el estado visual del botón
  bool _loading = false;

  // Guarda la sesion del nuevo usuario
  Future<void> _saveSession(int userId, String fstName, String lstName, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('userFstName', fstName);
    await prefs.setString('userLstName', lstName);
    await prefs.setString('userEmail', email);
  }

  // Registra usuario nuevo
  Future<void> _register() async {
    final fstName = _fstNameController.text.trim();
    final lstName = _lstNameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    // Verifica los campos
    if (fstName.isEmpty || lstName.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    // desactiva boton, cambia animacion
    setState(() => _loading = true);

    // Comprobar si ya esta registrado
    final exists = await DatabaseService.instance.emailExists(email);

    if (exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User already exists')),
        
      );

      // activa boton, cambia animacion
      setState(() => _loading = false);
      
      return;
    }

    // Registrar usuario en SQLite (devuelve el id insertado)
    final insertedId = await DatabaseService.instance.registerUser(fstName, lstName, email, pass);

    // activa boton, cambia animacion
    setState(() => _loading = false);

    if (insertedId > 0) {
      // Guardar sesion y navegar al home (auto-login)
      await _saveSession(insertedId, fstName, lstName, email);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User successfully registered')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error registering user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              const Text(
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              // Campo nombre
              TextField(
                controller: _fstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Campo apellido
              TextField(
                controller: _lstNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Campo email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Campo contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Botón registrar
              ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign Up'),
              ),

              const SizedBox(height: 20),

              // Link para volver al login
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
