import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';

// Pantalla de Ventas
class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Map<String, dynamic>> _products = [];
  int? _selectedProductId;
  double _selectedProductPrice = 0.0;
  int _availableQty = 0; // stock del producto seleccionado

  final TextEditingController _qtyController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _qtyController.addListener(_onQtyChanged);
  }

  @override
  void dispose() {
    _qtyController.removeListener(_onQtyChanged);
    _qtyController.dispose();
    super.dispose();
  }

  void _onQtyChanged() {
    // Actualiza UI para que el total se muestre en tiempo real
    if (mounted) setState(() {});
  }

  // Cargar productos desde DB
  Future<void> _loadProducts() async {
    final data = await DatabaseService.instance.getProducts();
    setState(() {
      _products = data;
    });
  }

  // Mostrar mensaje simple
  void _showMessage(String txt) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
  }

  // Registrar venta real
  Future<void> _registerSale() async {
    if (_isProcessing) return;

    if (_selectedProductId == null) {
      _showMessage("Select a product"); // Seleccionar producto
      return;
    }

    final qty = int.tryParse(_qtyController.text.trim()) ?? 0;
    if (qty <= 0) {
      _showMessage("Enter a valid amount"); // cantidad invalida
      return;
    }

    // Validar stock disponible
    if (qty > _availableQty) {
      _showMessage(
        "Insufficient stock. Available: $_availableQty",
      ); // disponible
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Obtener usuario de sesión
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        _showMessage("You are not logged in. Please log in before selling.");
        setState(() => _isProcessing = false);
        return;
      }

      // Calcular total
      final total = _selectedProductPrice * qty;

      // Registrar venta en DB
      final saleId = await DatabaseService.instance.addSale(
        _selectedProductId!,
        userId,
        qty,
        total,
      );

      // Bajar stock
      final rows = await DatabaseService.instance.decreaseStock(
        _selectedProductId!,
        qty,
      );

      // Después de bajar stock, validar inventario actual
      final updatedProduct = await DatabaseService.instance.getProductById(
        _selectedProductId!,
      );
      final newQty = updatedProduct['quantity'];

      // Si el stock es bajo, notificar
      if (newQty < 10) {
        NotificationService().showLowStockNotification(
          updatedProduct['name'],
          newQty,
        );
      }

      if (rows <= 0) {
        // Intent de rollback o aviso: si decreaseStock falló
        _showMessage("Stock could not be updated. Check the database.");
      } else {
        _showMessage("Registered sale (ID: $saleId)");
        // limpiar campos
        setState(() {
          _qtyController.clear();
          _selectedProductId = null;
          _selectedProductPrice = 0.0;
          _availableQty = 0;
        });
        // Volver a cargar productos para actualizar stock en Dropdown
        await _loadProducts();
      }
    } catch (e, st) {
      // Manejo genérico de errores
      debugPrint("Error recording sale: $e\n$st");
      _showMessage("Error recording the sale.");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  String _displayTotal() {
    final qty = int.tryParse(_qtyController.text.trim()) ?? 0;
    final total = _selectedProductPrice * qty;
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Sale')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Elegir producto
            const Text("Product"),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              hint: const Text("Select product"),
              initialValue: _selectedProductId,
              items: _products.map((item) {
                final id = item['id'] as int?;
                final name = item['name'] ?? '';
                final price = item['price']?.toString() ?? '0';
                final qty = item['quantity']?.toString() ?? '0';
                return DropdownMenuItem<int>(
                  value: id,
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.7, // <= controla el ancho
                    child: Text(
                      "$name (\$$price) - stock: $qty",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    _selectedProductId = null;
                    _selectedProductPrice = 0.0;
                    _availableQty = 0;
                  });
                  return;
                }

                final product = _products.firstWhere(
                  (p) => p['id'] == value,
                  orElse: () => {},
                );

                setState(() {
                  _selectedProductId = value;
                  _selectedProductPrice = (product['price'] is num)
                      ? (product['price'] as num).toDouble()
                      : double.tryParse('${product['price']}') ?? 0.0;
                  _availableQty = (product['quantity'] is int)
                      ? product['quantity'] as int
                      : int.tryParse('${product['quantity']}') ?? 0;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            // Agregar cantidad
            const Text("Quantity"),

            const SizedBox(height: 8),

            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter quantity",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Mostrar total
            Text(
              "Total: \$${_displayTotal()}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            if (_selectedProductId != null)
              Text("Stock available: $_availableQty"),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: (_isProcessing) ? null : _registerSale,
                child: _isProcessing
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Register Sale"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
