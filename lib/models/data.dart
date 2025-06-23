import 'package:flutter/services.dart';

class PathData {
  static List<String> pathImage = [
    "assets/images/a1.png",
    "assets/images/a.png",
    "assets/images/anton.png",
    "assets/images/bola.png",
    "assets/images/gerges.png",
    "assets/images/d.png",
    "assets/images/mousa.png",
  ];
}

class TitleData {
  static List<String> title = [
    "القديس أبونا عبد المسيح المناهري",
    "القديس أبونا عبد المسيح الحبشي",
    "القديس الانبا انطونيوس",
    "القديس الانبا بولا",
    "القديس مارجرجس",
    "القديسة دميانة",
    "القديس موسى الاسود",
  ];
}

class AudioData {
  static List<String> audio = [
    "assets/audio/a1.mp3",
    "assets/audio/a.mp3",
    "assets/audio/anton.mp3",
    "assets/audio/bola.mp3",
    "assets/audio/gerges.mp3",
    "assets/audio/d.mp3",
    "assets/audio/mousa.mp3",
  ];
}

class ContentData {
  static List<String> content = [];

  static Future<void> loadContents() async {
    List<String> paths = [
      'assets/stores/a1.txt',
      'assets/stores/a.txt',
      'assets/stores/anton.txt',
      'assets/stores/bola.txt',
      'assets/stores/gerges.txt',
      'assets/stores/d.txt',
      'assets/stores/mousa.txt',
    ];

    content.clear();

    for (String path in paths) {
      try {
        String data = await rootBundle.loadString(path);
        content.add(data);
      } catch (e) {
        // لو حصل خطأ في تحميل الملف، نضيف نص افتراضي أو نكمل بصمت
        content.add("تعذر تحميل هذه القصة.");
      }
    }
  }
}
