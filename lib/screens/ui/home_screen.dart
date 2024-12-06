import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String name = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    listenCurrentPosition();
    //getCurrentLocation();
  }

  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  List<LatLng> polyLinePoints = [];


  LatLng  initialTarget = const LatLng(22.822566, 89.553544);

  Position? position;

  Future<void> listenCurrentPosition() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {

        try {
        Geolocator.getPositionStream(
            locationSettings:  const LocationSettings(
          timeLimit: Duration(seconds: 30),
          //distanceFilter: 100,
          accuracy: LocationAccuracy.bestForNavigation,
        )).listen((pos) {
          animateCameraOnCurrentLocation(pos);

          displayMarker(pos);
          updatePolyline(pos);

          setState(() {});
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
        getCurrentLocation();
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
        Position p = await Geolocator.getCurrentPosition();
        position = p;
        print(' location Low $p');
        //animateCameraOnCurrentLocation(p);
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
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
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


  void displayMarker(Position markerPosition){

    markers.clear();
    // Adding a new marker at the user's current position
    markers.add(
      Marker(
          markerId: const MarkerId('street'),
          position:  LatLng(markerPosition.latitude,markerPosition.longitude),
          infoWindow: InfoWindow(
              title: 'My current location',
              snippet: 'Lat: ${markerPosition.latitude}, Lng: ${markerPosition.longitude}',
              ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen),
          draggable: true,
          onDragEnd: (LatLng endLatLng) {
           //
          }),
    );
  }


  void updatePolyline(Position currentPosition) {
    LatLng newPoint = LatLng(currentPosition.latitude, currentPosition.longitude);
    polyLinePoints.add(newPoint);

    Polyline polyline = Polyline(
      polylineId: const PolylineId('location-history'),
      points: polyLinePoints,
      color: Colors.blue,
      width: 4,
    );

    polyLines.clear();
    polyLines.add(polyline);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Me'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          zoom: 9,
          target: initialTarget,
        ),
        onTap: (LatLng? latLng) {
          print(latLng);
        },
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        markers: markers,
        polylines: polyLines,
        trafficEnabled: true,

      ),
    );
  }
}
