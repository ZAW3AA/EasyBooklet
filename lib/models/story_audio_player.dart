// ignore_for_file: avoid_print

import 'package:just_audio/just_audio.dart';

class StoryAudioPlayer {
  final AudioPlayer _player = AudioPlayer();
  String? _currentFile;

  Future<void> playOrPause(String fileName) async {
    try {
      if (_currentFile != fileName) {
        _currentFile = fileName;
        await _player.setAsset(fileName);
        await _player.play();
      } else {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void stopAudio() {
    _player.stop();
    _currentFile = null;
  }

  Future<void> replay() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  Future<void> stop() async {
    await _player.seek(Duration.zero);
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }

  Stream<bool> get isPlayingStream => _player.playingStream;

  void seekTo(Duration position) {
    _player.seek(position);
  }

  // ⏱️ لتتبع الوقت
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
}
