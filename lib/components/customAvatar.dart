import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String letter;
  final Color backgroundColor;
  final Color foregroundColor;
  CustomAvatar({this.backgroundColor, this.foregroundColor, this.letter});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: Text(
        letter,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
