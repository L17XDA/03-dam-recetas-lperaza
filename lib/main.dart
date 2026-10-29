import 'package:flutter/material.dart';
import 'package:recetasapp/screens/splash_screen.dart';

void main() {
  runApp(const RecetasApp());
}

class RecetasApp extends StatelessWidget {
  const RecetasApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recetas del Mayab",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}