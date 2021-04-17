import 'package:chat/screens/home.dart';
import 'package:chat/screens/login.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/state/chat_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot);
              return Home();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}

// _auth.currentUser == null ? Login() : Home(),
