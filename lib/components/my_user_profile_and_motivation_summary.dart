import 'package:flutter/material.dart';
import 'package:goalzify/screens/auth/auth_service.dart';
import 'package:goalzify/services/motivation_service.dart';

class MyUserProfileAndMotivationSummary extends StatefulWidget {
  MyUserProfileAndMotivationSummary({super.key});

  @override
  State<MyUserProfileAndMotivationSummary> createState() =>
      _MyUserProfileAndMotivationSummaryState();
}

class _MyUserProfileAndMotivationSummaryState
    extends State<MyUserProfileAndMotivationSummary> {
  final MotivationService _motivationService = MotivationService();
  String? email;
  int motivationValue = 0;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadMotivation();
  }

  Future<void> _loadUserEmail() async {
    final auth = AuthService();
    setState(() {
      email = auth.getCurrentUserEmail();
    });
  }

  Future<void> _loadMotivation() async {
    await _motivationService.resetMotivationIfNeeded();
    int motivation = await _motivationService.getMotivation();
    setState(() {
      motivationValue = motivation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Card(
        color: Colors.grey.shade300,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=1780&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          ),
          title: email != null
              ? Text(
                  email!,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.grey.shade900),
                )
              : const Text("Loading..."),
          subtitle: Text("Son motivasyon: $motivationValue%"),
        ),
      ),
    );
  }
}
