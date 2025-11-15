import 'package:flutter/material.dart';

// Pantalla para editar un producto existente
class EditProductScreen extends StatefulWidget {
  final String name;
  final int quantity;
  final double price;

  // Constructor recibiendo datos actuales del producto
  const EditProductScreen({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    // Inicializamos los campos con los datos del producto
    _nameController = TextEditingController(text: widget.name);
    _quantityController = TextEditingController(
      text: widget.quantity.toString(),
    );
    _priceController = TextEditingController(text: widget.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Producto
            const Text('Product Name'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            // Cantidad
            const Text('Quantity'),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            // Precio Unitario
            const Text('Unit Price'),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 30),

            // Boton guardar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // se guardalos cambios
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
