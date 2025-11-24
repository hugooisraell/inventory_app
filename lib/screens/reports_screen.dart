import 'package:flutter/material.dart';
import '../services/db_service.dart';

// Pantalla de Reportes
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Map<String, dynamic>> _sales = [];
  double _totalSales = 0;
  double _todaySales = 0;
  int _salesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final sales = await DatabaseService.instance.getSales();
    final total = await DatabaseService.instance.getTotalSales();
    final today = await DatabaseService.instance.getTodaySales();
    final count = await DatabaseService.instance.getSalesCount();

    setState(() {
      _sales = sales;
      _totalSales = total;
      _todaySales = today;
      _salesCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------- RESUMEN --------
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    "Total Sales",
                    "\$${_totalSales.toStringAsFixed(2)}",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCard(
                    "Today",
                    "\$${_todaySales.toStringAsFixed(2)}",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _buildCard("Sales Count", "$_salesCount")),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // -------- LISTA DE VENTAS --------
            Expanded(
              child: _sales.isEmpty
                  ? const Center(child: Text("No sales yet"))
                  : ListView.builder(
                      itemCount: _sales.length,
                      itemBuilder: (context, i) {
                        final sale = _sales[i];
                        return Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sale['product_name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("Quantity: ${sale['quantity']}"),
                                Text(
                                  "Total: \$${sale['total'].toStringAsFixed(2)}",
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    sale['date'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
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

  // Tarjeta de resumen responsiva
  Widget _buildCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
