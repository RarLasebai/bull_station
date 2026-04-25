import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapDetailsScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;

  const MapDetailsScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    this.title = "موقع الشاحنة",
  });

  // وظيفة لفتح الموقع في تطبيق خرائط جوجل الخارجي
  Future<void> _openInGoogleMaps() async {
    final googleMapsUrl = Uri.parse("google.navigation:q=$latitude,$longitude");
    final appleMapsUrl = Uri.parse("https://maps.apple.com/?q=$latitude,$longitude");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    } else {
      throw 'Could not launch maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng truckLocation = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: TxtStyle(title, 14),
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: _openInGoogleMaps, // زر لفتح الخرائط الخارجية للتوجيه
            tooltip: "فتح في خرائط جوجل",
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: truckLocation,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('truck_pos'),
            position: truckLocation,
            infoWindow: InfoWindow(title: title),
          ),
        },
      ),
    );
  }
}