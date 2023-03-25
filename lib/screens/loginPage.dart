import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_oneplanet/apis/apis.dart';
import 'package:project_oneplanet/screens/homePage.dart';
import 'package:project_oneplanet/screens/landingPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await APIs.auth.signInWithCredential(credential).then((value) {
        APIs.user;
        //Navigate to homepage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LandingPage(currentUser: APIs.user,),
          ),
        );
      });
    } on FirebaseAuthException catch(e) {
      log("Oops, Somthing went wrong!! ${e.message}");
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Google Login Page Animation",
            ),
          ),
          SizedBox(
            height: 100,
          ),
          ElevatedButton(
            onPressed: () {
              signInWithGoogle();
            },
            child: Text("Signin with google"),
          ),
        ],
      ),
    );
  }
}
