import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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

  LatLng? _myPosition; // Ubicación real del usuario
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  // Obtener ubicación actual
  Future<void> _loadLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Servicio habilitado?
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    // Obtener posición final
    Position pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _myPosition = LatLng(pos.latitude, pos.longitude);
      _loading = false;
    });

    // Mover cámara al GPS
    mapController.move(_myPosition!, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(initialCenter: _myPosition!, initialZoom: 14),
              children: [
                // Mapa base Mapbox
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  userAgentPackageName: 'com.example.inventory_app',
                  additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/streets-v12',
                  },
                ),

                // Marcador - ubicación actual
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myPosition!,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),

      // Botón para centrar GPS
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_myPosition != null) {
            mapController.move(_myPosition!, 16);
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
