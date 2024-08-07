import 'package:flutter/material.dart';
import 'package:goalzify/screens/meditation/breath.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Breath'),
              Tab(text: 'Progress'),
              Tab(text: 'Resources'),
            ],
            labelColor: Colors.amber.shade700,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.amber,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Breath(),
                Center(child: Text('Content for Progress')),
                Center(child: Text('Content for Resources')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
