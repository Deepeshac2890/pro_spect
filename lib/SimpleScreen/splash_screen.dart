import 'package:flutter/material.dart';
import 'package:pro_spect/Constants/assets_constants.dart';
import 'package:pro_spect/dashboard/view.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatelessWidget {
  static const String id = 'Splash';
  const SplashPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: const DashboardPage(),
      image: Image.asset(logoImageAsset),
      photoSize: 200.0,
      loaderColor: Colors.blue,
    );
  }
}
