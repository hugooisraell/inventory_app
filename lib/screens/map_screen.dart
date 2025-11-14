import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiaHVnb2xhaW5lejA1IiwiYSI6ImNtaHd1b2ltNTAzd2YybHBzd2kzdzhjZXYifQ.o5tS4JiaGBxB7sFlsTVvMg';

// Pantalla del mapa usando Mapbox
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapController = MapController();

  // Coordenadas iniciales (ejemplo: Quito, Ecuador)
  final LatLng _center = LatLng(-0.1807, -78.4678);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(initialCenter: _center, initialZoom: 13),
        children: [
          // Capa base de Mapbox
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            userAgentPackageName: 'com.example.inventory_app',
            additionalOptions: const {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': 'mapbox/streets-v12',
            },
          ),

          // Marcador de ubicación
          MarkerLayer(
            markers: [
              Marker(
                point: _center,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),

      // Regresa a la Ubicacion
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.move(_center, 13);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
