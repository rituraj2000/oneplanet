import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_oneplanet/screens/landingPage.dart';
import 'package:project_oneplanet/screens/Authentication/loginPage.dart';
import 'package:project_oneplanet/theme/colors.dart';

import '../apis/apis.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    Future.delayed(const Duration(milliseconds: 5200), () async {
      User? currentUser = APIs.auth.currentUser;

      if (currentUser != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => LandingPage(
                      currentUser: currentUser,
                    )));

        // UserModel? currentUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
        //
        // ///If logged in
        // if(currentUserModel != null){
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) =>  HomeScreen(userModel: currentUserModel, firebaseUser: currentUser),
        //     ),
        //   );
      } else {
        /// If not logged in
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.75,
            image: AssetImage("assets/images/loading.gif"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
