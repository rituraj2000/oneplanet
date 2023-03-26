import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_oneplanet/apis/apis.dart';
import 'package:project_oneplanet/screens/homePage.dart';
import 'package:project_oneplanet/screens/landingPage.dart';

import '../models/user_model.dart';

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
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await APIs.auth.signInWithCredential(credential).then((value) async{
        APIs.user;
        String id = APIs.user.uid;

        await APIs.firestore.collection('users').doc(id).get().then((value) {
          if(value.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LandingPage(
                  currentUser: APIs.user,
                ),
              ),
            );
          } else {
            UserModel newUser = UserModel(
              id: id,
              name: APIs.user.displayName,
              photo: APIs.user.photoURL,
              points: "47",
              globalrank: "167",
              drives: "246",
              lable: "Cherry",
            );

            // Sending Userdata to fire store users collection
            APIs.firestore
                .collection("users")
                .doc(id)
                .set(newUser.toJson())
                .then((value) {
              //Navigate to homepage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LandingPage(
                    currentUser: APIs.user,
                  ),
                ),
              );
            });
          }
        });

      });
    } on FirebaseAuthException catch (e) {
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
