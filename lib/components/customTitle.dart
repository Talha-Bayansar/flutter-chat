import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  CustomTitle({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
        bottom: 10,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }
}
