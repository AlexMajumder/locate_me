import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locate_me/screens/ui/home_screen.dart';
import 'package:locate_me/screens/ui/splash_screen.dart';
class LocateMeApp extends StatefulWidget {
  const LocateMeApp({super.key});

  @override
  State<LocateMeApp> createState() => _LocateMeAppState();
}

class _LocateMeAppState extends State<LocateMeApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: SplashScreen.name,
      routes:{
        SplashScreen.name : (context) => const SplashScreen(),
        HomeScreen.name: (context) => const HomeScreen(),
      }
    );
  }
}
