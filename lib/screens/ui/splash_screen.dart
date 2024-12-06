import 'package:flutter/material.dart';
import 'package:locate_me/screens/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name ='/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
     // Get.offAllNamed(HomeScreen.name);
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.name, (p)=> true);
    }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Spacer(),
              Text(
                'Locate Me',
                style: TextStyle(fontSize: 24, color: Colors.amber),
              ),
              Spacer(),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
