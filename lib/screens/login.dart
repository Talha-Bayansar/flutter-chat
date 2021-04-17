import 'package:chat/components/customTextButton.dart';
import 'package:chat/components/customTextFormField.dart';
import 'package:chat/components/customTitle.dart';
import 'package:chat/screens/register.dart';
import 'package:chat/state/chat_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
              CustomTextButton(
                buttonColor: Colors.blue[400],
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    try {
                      await Provider.of<ChatData>(context, listen: false)
                          .login(emailController.text, passwordController.text);
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
                text: "Login",
                textColor: Colors.white,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ),
                  );
                },
                child: Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
