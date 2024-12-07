import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {


  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  List<LatLng> polyLinePoints = [];

  LatLng initialTarget = const LatLng(22.822566, 89.553544);

  Future<void> initializeLocationUpdates() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        try {
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              timeLimit: Duration(seconds: 30),
              accuracy: LocationAccuracy.bestForNavigation,
            ),
          ).listen((Position pos) {
            animateCameraOnCurrentLocation(pos);
            displayMarker(pos);
            updatePolyline(pos);
            update();
          });
        } catch (e) {
          print("Error: $e");
        }
      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        initializeLocationUpdates();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }


  Future<bool> checkGPSServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }


  void animateCameraOnCurrentLocation(Position currentPosition) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 16,
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
        ),
      ),
    );
  }


  void displayMarker(Position markerPosition) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(markerPosition.latitude, markerPosition.longitude),
        infoWindow: InfoWindow(
          title: 'My current location',
          snippet: 'Lat: ${markerPosition.latitude}, Lng: ${markerPosition.longitude}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }


  void updatePolyline(Position currentPosition) {
    LatLng newPoint = LatLng(currentPosition.latitude, currentPosition.longitude);
    polyLinePoints.add(newPoint);

    if(polyLinePoints.length ==1){
      Get.showSnackbar(const GetSnackBar(
        title: 'Hey,Successfully locate Your current location!!',
        message: "Now, you see your Location as a Marker and It's syncs automatically with your current location",
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueAccent,
      ));
    }
    if(polyLinePoints.length ==2){
      Get.showSnackbar(const GetSnackBar(
        title: 'Polyline created!!',
        message: 'Now, you see your Polyline. That makes easy to see your Navigate History',
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueAccent,
      ));
    }

    Polyline polyline = Polyline(
      polylineId: const PolylineId('location-history'),
      points: polyLinePoints,
      color: Colors.blue,
      width: 4,
    );
    polyLines.clear();
    polyLines.add(polyline);
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }
}