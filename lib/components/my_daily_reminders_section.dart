import 'package:flutter/material.dart';
import 'package:goalzify/styles.dart';

class MyDailyRemindersSection extends StatelessWidget {
  const MyDailyRemindersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("R E M I N D E R S", style: AppStyles.homeScreenSectionTitle),
          Divider(
            color: Colors.grey.shade400,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
