import 'package:flutter/material.dart';

import 'package:my_portfolio/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.inputType,
    super.key,
    this.controller,
    this.maxLines = 1,
    this.hintText,
    this.isEmail = false,
  });
  final TextEditingController? controller;
  final int maxLines;
  final String? hintText;
  final bool isEmail;
  final String inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.black,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please Enter your $inputType';
        }
        if (isEmail) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value.trim())) {
            return 'Enter a valid email';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        filled: true,
        fillColor: CustomColor.bgLight2,
        focusedBorder: getInputBorder,
        enabledBorder: getInputBorder,
        border: getInputBorder,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: CustomColor.textSecondary,
        ),
      ),
    );
  }

  OutlineInputBorder get getInputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );
  }
}
