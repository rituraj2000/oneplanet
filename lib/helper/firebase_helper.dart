import 'package:cloud_firestore/cloud_firestore.dart';

import '../apis/apis.dart';
import '../models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String id) async {
    UserModel? userModel;
    DocumentSnapshot docSnap =
    await APIs.firestore.collection("users").doc(id).get();

    if (docSnap.data() != null) {
      userModel = UserModel.fromJson(docSnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }

  static Future<UserModel?> getUserModelByEmail(String email) async {
    UserModel? userModel;
    QuerySnapshot query =
    await APIs.firestore.collection("users").where("email", isEqualTo: email).get();
    DocumentSnapshot docSnap = query.docs[0];

    if (docSnap.data() != null) {
      userModel = UserModel.fromJson(docSnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
