import 'package:flutter/material.dart';
import 'inventory/add_product_screen.dart';
import 'inventory/edit_product_screen.dart';
import '../services/db_service.dart';

// Pantalla de inventario
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Map<String, dynamic>> _products = [];

  // Cargar productos guardados
  void _loadProducts() async {
    final data = await DatabaseService.instance.getProducts();
    setState(() {
      _products = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProducts(); // carga inicial
  }

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
          ).then((value) => _loadProducts());
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista de productos
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final item = _products[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text(
                        'Quantity: ${item['quantity']} | Price: \$${item['price']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Boton editar
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductScreen(
                                    name: item['name'],
                                    quantity: item['quantity'],
                                    price: item['price'],
                                    id: item['id'],
                                  ),
                                ),
                              ).then((value) => _loadProducts());
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          // Boton eliminar
                          IconButton(
                            onPressed: () async {
                              await DatabaseService.instance.deleteProduct(
                                item['id'],
                              );
                              _loadProducts();
                            },
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
