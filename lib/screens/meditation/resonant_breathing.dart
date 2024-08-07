import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ResonantBreathing extends StatefulWidget {
  const ResonantBreathing({super.key});

  @override
  _ResonantBreathingState createState() => _ResonantBreathingState();
}

class _ResonantBreathingState extends State<ResonantBreathing> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://res.cloudinary.com/dh7lpyg7t/video/upload/v1722859824/Resonant_breath_ktny2y.mp4'))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        title: const Text(
          "Resonant Breath",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: _controller.value.isInitialized
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 35.0, vertical: 55.0),
                child: Column(
                  children: [
                    Text(
                      "\t\t\tResonant breathing, also known as coherent breathing, is when you breathe at a rate of 5 full breaths per minute. You can achieve this rate by inhaling and exhaling for a count of 5.",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 35),
                    Text(
                      "\t\t\tThis exercise will take about a minute. When you are ready, press the button and start the exercise.",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.red[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.replay_10,
                    color: Colors.amber.shade700,
                  ),
                  onPressed: () {
                    final currentPosition = _controller.value.position;
                    _controller.seekTo(currentPosition - Duration(seconds: 10));
                  },
                ),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.amber.shade700,
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.forward_10,
                    color: Colors.amber.shade700,
                  ),
                  onPressed: () {
                    final currentPosition = _controller.value.position;
                    _controller.seekTo(currentPosition + Duration(seconds: 10));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
