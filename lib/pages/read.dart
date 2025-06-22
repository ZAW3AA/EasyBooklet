import 'package:easybooklet/models/story_audio_player.dart';
import 'package:flutter/material.dart';

class Read extends StatefulWidget {
  final String title;
  final String content;
  final String audio;

  const Read({
    super.key,
    required this.title,
    required this.content,
    required this.audio,
  });

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  late StoryAudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = StoryAudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 0, 16, 28),
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [IconButton(onPressed: () {
            audioPlayer.playAudio(widget.audio);
          }, icon: Icon(Icons.audiotrack_rounded))],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.content,
            style: const TextStyle(fontSize: 18, height: 1.6),
            textDirection: TextDirection.rtl, // لو النص عربي
          ),
        ),
      ),
    );
  }
}
