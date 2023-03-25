import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_oneplanet/screens/landingPage.dart';
import 'package:project_oneplanet/screens/loginPage.dart';
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
    Future.delayed(const Duration(milliseconds: 3500), () async {

      User? currentUser = APIs.auth.currentUser;

      if(currentUser!= null) {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LandingPage(currentUser: currentUser,)));

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 0.7 * screenWidth,
            width: 0.6 * screenWidth,
            child: Center(child: CircularProgressIndicator()),
            // child: Image.asset(
            //   'assets/images/loading.gif',
            //   fit: BoxFit.fitHeight,
            // ),
          ),
          SizedBox(height: 0.1 * screenWidth),
          Center(
            child: Text(
              'OnePlanet',
              style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: AppColors.kGreenYellow, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}
