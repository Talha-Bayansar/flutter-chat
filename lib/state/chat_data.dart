import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatData extends ChangeNotifier {
  var currentUser;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String activeChat;

  Future<void> register(email, password) async {
    UserCredential newUser = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    this.currentUser = newUser.user;
    notifyListeners();
  }

  Future<void> login(email, password) async {
    UserCredential newUser =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    this.currentUser =
        await firestore.collection("users").doc(newUser.user.uid).get();
    notifyListeners();
  }

  Future<void> logout() async {
    await auth.signOut();
    this.currentUser = null;
    notifyListeners();
  }

  void setActiveChat(String chatId) {
    this.activeChat = chatId;
    notifyListeners();
  }
}
