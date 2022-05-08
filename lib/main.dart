import 'package:flutter/material.dart';
import 'package:pro_spect/SimpleScreen/splash_screen.dart';
import 'package:pro_spect/cart/view.dart';
import 'package:pro_spect/dashboard/view.dart';
import 'package:pro_spect/product_details/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CartPage.id: (context) => const CartPage(),
        DashboardPage.id: (context) => const DashboardPage(),
        ProductDetails.id: (context) => const ProductDetails(),
        SplashPage.id: (context) => const SplashPage(),
      },
      initialRoute: SplashPage.id,
      title: 'Pro Spect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
