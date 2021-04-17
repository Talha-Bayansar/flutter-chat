import 'package:chat/components/customTextButton.dart';
import 'package:chat/components/customTextFormField.dart';
import 'package:chat/components/customTitle.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/state/chat_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTitle(
                text: "Welcome!",
              ),
              CustomTextFormField(
                controller: usernameController,
                label: "Username",
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a username.";
                  }
                  return null;
                },
                obscureText: false,
              ),
              CustomTextFormField(
                controller: emailController,
                label: "Email",
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return "Please enter a valid email adress.";
                  }
                  return null;
                },
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextFormField(
                controller: passwordController,
                label: "Password",
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password needs to be at least 6 characters long.";
                  }
                },
                obscureText: true,
              ),
              CustomTextFormField(
                controller: passwordController2,
                label: "Repeat password",
                validator: (value) {
                  if (value != passwordController.text) {
                    return "Passwords are not the same!";
                  }
                },
                obscureText: true,
              ),
              CustomTextButton(
                buttonColor: Colors.blue[400],
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    try {
                      await Provider.of<ChatData>(context, listen: false)
                          .register(
                              emailController.text, passwordController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ));
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                text: "Register",
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
