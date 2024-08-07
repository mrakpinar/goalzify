import 'package:flutter/material.dart';
import 'package:goalzify/screens/profile_screen.dart';
import 'package:goalzify/services/motivation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUserProfileAndMotivationSummary extends StatefulWidget {
  const MyUserProfileAndMotivationSummary({super.key});

  @override
  State<MyUserProfileAndMotivationSummary> createState() =>
      _MyUserProfileAndMotivationSummaryState();
}

class _MyUserProfileAndMotivationSummaryState
    extends State<MyUserProfileAndMotivationSummary> {
  final MotivationService _motivationService = MotivationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userName;
  int motivationValue = 10;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMotivation();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        userName = "${userData['firstName']} ${userData['lastName']}";
        profileImageUrl = userData['profileImageUrl'];
      });
    }
  }

  Future<void> _loadMotivation() async {
    await _motivationService.resetMotivationIfNeeded();
    int motivation = await _motivationService.getMotivation();
    setState(() {
      motivationValue = motivation;
    });
  }

  void onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.blueGrey[700],
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : const NetworkImage(
                      'https://i.fbcd.co/products/resized/resized-750-500/d4c961732ba6ec52c0bbde63c9cb9e5dd6593826ee788080599f68920224e27d.webp'),
            ),
            title: userName != null
                ? Text(
                    userName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  )
                : const Text("Loading..."),
            subtitle: Text(
              "Son motivasyon: $motivationValue%",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
