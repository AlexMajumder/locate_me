import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controller/location_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String name = 'homeScreen';

  @override
  Widget build(BuildContext context) {

    final locationController = Get.put(LocationController());

    locationController.getCurrentLocation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Me'),
      ),
      body: GetBuilder<LocationController>(
        builder: (controller) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              zoom: 9,
              target: controller.initialTarget,
            ),
            markers: controller.markers,
            polylines: controller.polyLines,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            trafficEnabled: true,
            onMapCreated: (GoogleMapController mapController) {
              controller.onMapCreated(mapController); // Set the map controller
            },
          );
        },
      ),
    );
  }
}
