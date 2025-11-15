import 'package:flutter/material.dart';
import 'inventory/add_product_screen.dart';
import 'inventory/edit_product_screen.dart';

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

      // Boton para agregar producto
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abre formulario para agregar
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista temporal simulada
            Expanded(
              child: ListView.builder(
                itemCount: 10, // temporal
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Product ${index + 1}'),
                      subtitle: const Text('Quantity: 10 | Price: \$25.00'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Boton editar
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProductScreen(
                                    name: 'Producto de prueba',
                                    quantity: 10,
                                    price: 25.0,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          // Boton eliminar
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
