import 'package:flutter/material.dart';
import 'package:goalzify/widgets/tab_bar_widget.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meditation"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Icon(
              Icons.self_improvement_sharp,
              color: Colors.amber.shade700,
              size: 30,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Text(
                "Welcome to meditation.",
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              const Expanded(child: TabBarWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
