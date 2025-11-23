import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fstNameController = TextEditingController();
  final _lstNameController = TextEditingController();
  final _emailController = TextEditingController();

  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // cargar datos actuales
    _fstNameController.text = prefs.getString('userFstName') ?? '';
    _lstNameController.text = prefs.getString('userLstName') ?? '';
    _emailController.text = prefs.getString('userEmail') ?? '';
    userId = prefs.getInt('userId') ?? 0;
  }

  Future<void> _saveChanges() async {
    final fstName = _fstNameController.text.trim();
    final lstName = _lstNameController.text.trim();
    final email = _emailController.text.trim();

    if (fstName.isEmpty || lstName.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in all fields')),
      );
      return;
    }

    // actualizar en SQLite
    await DatabaseService.instance.updateUser(userId, fstName, lstName, email);

    // actualizar SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userFstName', fstName);
    await prefs.setString('userLstName', lstName);
    await prefs.setString('userEmail', email);

    if (!mounted) return;
    // volver
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _fstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _lstNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
