import 'package:just_audio/just_audio.dart';

class StoryAudioPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAudio(String fileName) async {
    try {
      await _player.setAsset(fileName);
      await _player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void stopAudio() {
    _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
