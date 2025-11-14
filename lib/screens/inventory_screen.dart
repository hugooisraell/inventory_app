import 'package:flutter/material.dart';

// Pantalla de inventario
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista temporal simulada
            Expanded(
              child: ListView.builder(
                itemCount: 3, // temporal
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Producto ${index + 1}'),
                      subtitle: const Text('Cantidad: 10 | Precio: \$25.00'),
                      trailing: const Icon(Icons.edit),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Boton para agregar producto
            ElevatedButton.icon(
              onPressed: () {
                // Abre formulario para agregar
              },
              icon: const Icon(Icons.add),
              label: const Text('Add product'),
            ),
          ],
        ),
      )
    );
  }
}