import 'package:flutter/material.dart';

// Pantalla de Ventas
class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Sale')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agregar nombre al producto
            const Text('Product'),
            TextField(
              controller: _productController,
              decoration: const InputDecoration(
                hintText: 'Product name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Agregar cantidad
            const Text('Quantity'),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter quantity',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // registrar venta
                },
                child: const Text('Register Sale'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
