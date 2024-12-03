import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location.dart';

class MapPreview extends StatelessWidget {
  final Location location;

  const MapPreview({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng position = LatLng(location.latitude, location.longitude);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId(location.id),
            position: position,
            infoWindow: InfoWindow(title: location.address),
          ),
        },
        myLocationEnabled: false,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
