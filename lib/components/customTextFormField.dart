import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function validator;
  final EdgeInsets padding;
  final bool obscureText;
  final TextInputType keyboardType;
  CustomTextFormField(
      {this.controller,
      this.label,
      this.validator,
      this.padding,
      this.obscureText,
      this.keyboardType});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: padding,
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: label,
        ),
      ),
    );
  }
}
