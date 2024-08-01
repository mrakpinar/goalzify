import 'package:flutter/material.dart';
import 'package:goalzify/screens/auth/auth_service.dart';
import 'package:goalzify/screens/goals_screen.dart';
import 'package:goalzify/screens/reminder_screen.dart';
import 'package:goalzify/screens/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset(
                    "./assets/images/goalzify_logo.png",
                    height: 250,
                  ),
                ),
              ),

              // Home listtile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home_outlined),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // Reminder ListTile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("R E M I N D E R"),
                  leading: const Icon(Icons.more_time_rounded),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    // navigate to reminder screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReminderScreen(),
                      ),
                    );
                  },
                ),
              ),

              // Goals ListTile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("G O A L S"),
                  leading: const Icon(Icons.track_changes_sharp),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    // navigate to goals screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GoalsScreen(),
                      ),
                    );
                  },
                ),
              ),

              // Settings Listtile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings_outlined),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    // navigate to settings screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout_sharp),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
