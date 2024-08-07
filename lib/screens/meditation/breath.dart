import 'package:flutter/material.dart';
import 'package:goalzify/components/my_breath_exercises_card.dart';
import 'package:goalzify/screens/meditation/resonant_breathing.dart';

class Breath extends StatelessWidget {
  const Breath({super.key});

  @override
  Widget build(BuildContext context) {
    void goToResonant() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResonantBreathing(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        children: [
          Text(
            "Breath Exercises",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.grey[800],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Divider(
              color: Colors.grey[400],
              thickness: 2,
            ),
          ),
          const SizedBox(height: 10),
          MyBreathExercisesCard(
            exerciseTitle: 'Resonant or coherent breathing',
            onTap: goToResonant,
          ),
        ],
      ),
    );
  }
}
