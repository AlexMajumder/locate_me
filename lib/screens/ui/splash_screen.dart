import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locate_me/screens/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

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
    Get.offAllNamed(HomeScreen.name);
    //Navigator.pushNamedAndRemoveUntil(context, HomeScreen.name, (p)=> false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Locate Me',
                style: TextStyle(
                    fontSize: 39,
                    color: Colors.amber,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10,),
              Image.asset('assets/images/logo.png'),
              const Spacer(),
              const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
