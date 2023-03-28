import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //Firebase Storage instance for storing files and images
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User? get user => auth.currentUser;

  //For storing current user info
  static late UserModel myCurrentUser;

  //Current user's info
  static Future<void> getSelfInfo() async {
    if (user != null) {
      await firestore
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((user) async {
        myCurrentUser = UserModel.fromJson(user.data() as Map<String, dynamic>);
      });
    }
  }
}
