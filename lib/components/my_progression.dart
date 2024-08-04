import 'package:flutter/material.dart';
import 'package:goalzify/styles.dart';

class MyProgression extends StatefulWidget {
  const MyProgression({super.key});

  @override
  State<MyProgression> createState() => _MyProgressionState();
}

class _MyProgressionState extends State<MyProgression> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "P R O G R E S S I O N",
            style: AppStyles.homeScreenSectionTitle,
          ),
          Divider(
            color: Colors.grey.shade400,
            thickness: 2,
          ),
          // İstatistikler ve grafikler burada gösterilebilir
          const Text("Buraya grafiklerle ilerleme verisi eklenecek")
        ],
      ),
    );
  }
}
