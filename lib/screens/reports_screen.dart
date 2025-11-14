import 'package:flutter/material.dart';

// Pantalla de Reportes
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filtro de fechas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // elegir fecha
                ElevatedButton.icon(
                  onPressed: () {
                    // fecha inicio
                  },
                  icon: const Icon(Icons.date_range),
                  label: const Text('From'),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    // fecha fin
                  },
                  icon: const Icon(Icons.date_range),
                  label: const Text('To'),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Lista de reportes (temporal)
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text('Venta ${index + 1}'),
                    subtitle: const Text(
                      'Fecha: 2025-11-10  |  Total: \$120.00',
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
