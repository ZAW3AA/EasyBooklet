import 'package:easybooklet/models/story_audio_player.dart';
import 'package:flutter/material.dart';

class Read extends StatefulWidget {
  final String title;
  final String content;
  final String audio;
  final String pathImage;

  const Read({
    super.key,
    required this.title,
    required this.content,
    required this.audio,
    required this.pathImage,
  });

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  late StoryAudioPlayer audioPlayer;
  late Stream<bool> isPlayingStream;
  late Stream<Duration> positionStream;
  late Stream<Duration?> durationStream;

  @override
  void initState() {
    super.initState();
    audioPlayer = StoryAudioPlayer();
    isPlayingStream = audioPlayer.isPlayingStream;
    positionStream = audioPlayer.positionStream;
    durationStream = audioPlayer.durationStream;
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void togglePlayPause() async {
    await audioPlayer.playOrPause(widget.audio);
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              child: Container(
                child: Image.asset(
                  widget.pathImage,
                  width: MediaQuery.of(context).size.height / 1.4,
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height / 4.8,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.content,
                  style: const TextStyle(fontSize: 18, height: 1.6),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              color: Colors.grey[200], // خلفية خفيفة للتمييز
              child: StreamBuilder<Duration>(
                stream: positionStream,
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration?>(
                    stream: durationStream,
                    builder: (context, durationSnapshot) {
                      final duration = durationSnapshot.data ?? Duration.zero;
                      final totalSeconds = duration.inSeconds == 0
                          ? 1
                          : duration.inSeconds;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Slider(
                            value: position.inSeconds
                                .clamp(0, totalSeconds)
                                .toDouble(),
                            max: totalSeconds.toDouble(),
                            onChanged: (value) {
                              audioPlayer.seekTo(
                                Duration(seconds: value.toInt()),
                              );
                            },
                            activeColor: Colors.blue,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<bool>(
                                stream: isPlayingStream,
                                builder: (context, snapshot) {
                                  final isPlaying = snapshot.data ?? false;
                                  return IconButton(
                                    onPressed: togglePlayPause,
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  );
                                },
                              ),

                              IconButton(
                                onPressed: () {
                                  audioPlayer.stop();
                                  audioPlayer.stopAudio();
                                },
                                icon: Icon(Icons.stop),
                              ),
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.replay),
                                onPressed: () {
                                  audioPlayer.replay();
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
