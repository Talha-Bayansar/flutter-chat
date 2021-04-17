import 'package:chat/helperFunctions/sharedpref_helper.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    return await auth.currentUser;
  }

  Future<void> createUserWithEmailPassword(BuildContext context, String email,
      String password, String displayName) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final User userDetails = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await value.user.updateProfile(displayName: displayName);
      return _firebaseAuth.currentUser;
    });

    if (userDetails != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails.email);
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelper().saveUserId(userDetails.uid);

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username":
            userDetails.email.substring(0, userDetails.email.indexOf('@')),
        "name": userDetails.displayName,
      };

      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      });
    }
  }

  Future<void> signInWithEmailPassword(
      BuildContext context, email, password) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final UserCredential result = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User userDetails = result.user;

    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails.email);
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelper().saveUserId(userDetails.uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}
