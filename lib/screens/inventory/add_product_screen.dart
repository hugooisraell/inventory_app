import 'package:flutter/material.dart';
import '../../services/db_service.dart';

// Pantalla para añadir un producto nuevo
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Producto
            const Text('Product Name'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: Coca Cola 1L',
              ),
            ),

            const SizedBox(height: 16),

            // Cantidad
            const Text('Quantity'),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: 10',
              ),
            ),

            const SizedBox(height: 16),

            // Precio Unitario
            const Text('Unit Price'),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: 2.50',
              ),
            ),

            const SizedBox(height: 30),

            // Boton guardar
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // se guarda el producto
                  final name = _nameController.text;
                  final qty = int.tryParse(_quantityController.text) ?? 0;
                  final price = double.tryParse(_priceController.text) ?? 0.0;

                  await DatabaseService.instance.addProduct(name, qty, price);

                  if (context.mounted) Navigator.pop(context); // volver al inventario
                },
                child: const Text('Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
