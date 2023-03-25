import 'package:flutter/material.dart';
import 'package:project_oneplanet/screens/landingPage.dart';
import 'package:project_oneplanet/theme/base_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnePlanet',
      theme: AppTheme.lightTheme,
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

