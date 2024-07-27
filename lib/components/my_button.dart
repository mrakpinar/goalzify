import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String btnText;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.btnText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade900,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Text(
        btnText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
