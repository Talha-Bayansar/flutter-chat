import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() {
    return auth.currentUser;
  }

  signInWithEmailPassword(BuildContext context, email, password) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final UserCredential result = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User userDetails = result.user;

    if (result != null) {
    } else {}
  }
}
