import 'package:flutter/material.dart';
import 'package:project_oneplanet/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OnePlanet",
          style: Theme.of(context).textTheme.headline1!.copyWith(color: AppColors.kDarkGreen),
        ),
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
