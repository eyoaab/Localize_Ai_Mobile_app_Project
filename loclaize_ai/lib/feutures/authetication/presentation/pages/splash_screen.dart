import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   // Simulate some loading process (e.g., fetching data)
  //   Future.delayed(Duration(seconds: 3), () {
  //     // After 3 seconds, navigate to the next screen (e.g., HomeScreen)
  //     Navigator.pushReplacementNamed(context, '/home');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,  // Optional: Set a background color
      body: Center(
        child: SpinKitWave(
          color: Colors.blue,  // Customize the color of the loading indicator
          size: 80.0,  // Customize the size of the loading indicator
        ),
      ),
    );
  }
}
