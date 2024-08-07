import 'package:flutter/material.dart';

class MyBreathExercisesCard extends StatelessWidget {
  final String exerciseTitle;
  final VoidCallback onTap;

  const MyBreathExercisesCard({
    super.key,
    required this.exerciseTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 150,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            title: Center(
              child: Text(
                exerciseTitle,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
