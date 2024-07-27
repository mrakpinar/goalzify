import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool isSecure;
  final Icon prefixIcon;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    required this.isSecure,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        obscureText: isSecure,
        textAlign: TextAlign.center,
        controller: textEditingController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          border: const OutlineInputBorder(),
          hintText: hintText,
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.grey.shade500,
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
