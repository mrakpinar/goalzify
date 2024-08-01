import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goalzify Admin Panel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AdminPanelHome(),
    );
  }
}

class AdminPanelHome extends StatelessWidget {
  const AdminPanelHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goalzify Admin Panel')),
      body: const Center(
        child: Text('Welcome to Goalzify Admin Panel'),
      ),
    );
  }
}
