import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polyline> polyLines = {};
  List<LatLng> polyLinePoints = [];

  LatLng initialTarget = const LatLng(22.822566, 89.553544);

  Future<void> realTimeLocationUpdates() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        try {
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              timeLimit: Duration(seconds: 10),
              accuracy: LocationAccuracy.bestForNavigation,
            ),
          ).listen((Position pos) {
            if (polyLinePoints.length == 2) {
              Get.showSnackbar(const GetSnackBar(
                title: 'Successfully created polyline!!',
                message:
                    'Now, you see your Polyline. That makes easy to see your Navigate History, after 10S',
                duration: Duration(seconds: 4),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.blueAccent,
              ));
            }

            animateCameraOnCurrentLocation(pos);
            displayMarker(pos);
            displayCircle(pos);
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
        realTimeLocationUpdates();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  Future<void> getCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        Position currentPosition = await Geolocator.getCurrentPosition();

        animateCameraOnCurrentLocation(currentPosition);
        displayMarker(currentPosition);
        displayCircle(currentPosition);

        Get.showSnackbar(
          const GetSnackBar(
            title: 'Hey,Successfully locate Your current location!!',
            message:
                "Tap over the marker to show your current Latitude and Longitude",
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.blueAccent,
          ),
        );

        update();

        realTimeLocationUpdates();
      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
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
          snippet:
              'Lat: ${markerPosition.latitude}, Lng: ${markerPosition.longitude}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
  }

  void displayCircle(Position circlePosition) {
    circles.clear();
    circles.add(
      Circle(
        circleId: const CircleId('MyLocation'),
        fillColor: Colors.blue.withOpacity(.2),
        center: LatLng(circlePosition.latitude, circlePosition.longitude),
        radius: 80,
        strokeColor: Colors.red.withOpacity(.6),
        strokeWidth: 1,
        visible: true,
      ),
    );
  }

  void updatePolyline(Position currentPosition) {
    LatLng newPoint =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    polyLinePoints.add(newPoint);

    if (polyLinePoints.length == 1) {}

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
