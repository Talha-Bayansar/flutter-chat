import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color textColor;
  final Color buttonColor;
  CustomTextButton(
      {this.buttonColor, this.onPressed, this.text, this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(textColor),
          backgroundColor: MaterialStateProperty.all(buttonColor),
          elevation: MaterialStateProperty.all(3),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }
}
