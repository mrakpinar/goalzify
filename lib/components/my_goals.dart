import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goalzify/components/my_card.dart';
import 'package:goalzify/styles.dart';

class MyGoals extends StatelessWidget {
  const MyGoals({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("G o a l s", style: AppStyles.homeScreenSectionTitle),
          Divider(
            color: Colors.grey.shade400,
            thickness: 2,
          ),
          // Goals will be shown here
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('goals')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No goals added yet!"));
              }

              var goals = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: goals.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return MyCard(
                      goal: data['title'],
                      isCompleted: data['completed'],
                      onStatusChanged: (bool? value) async {
                        // Update the completed status of the goal
                        await FirebaseFirestore.instance
                            .collection('goals')
                            .doc(doc.id)
                            .update({'completed': value});
                      },
                      onDelete: () async {
                        // Delete the goal from Firestore
                        await FirebaseFirestore.instance
                            .collection('goals')
                            .doc(doc.id)
                            .delete();
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
