import 'package:flutter/services.dart';

class PathData {
  static List<String> pathImage = [
    "assets/images/1.png",
    "assets/images/2.png",
    "assets/images/3.png",
    "assets/images/4.png",
  ];
}

class TitleData {
  static List<String> title = [
    "سرّ الكتاب الليلي",
    "الثعلب الصغير",
    "صديق جديد",
    "الكتاب السحرى",
  ];
}

class AudioData {
  static List<String> audio = [
    "assets/audio/1.mp3",
    "assets/audio/2.mp3",
    "assets/audio/3.mp3",
    "assets/audio/4.mp3"
  ];
}

class ContentData {
  static List<String> content = [];

  static Future<void> loadContents() async {
    List<String> paths = [
      'assets/store1/store1.txt',
      'assets/store2/store2.txt',
      'assets/store3/store3.txt',
      'assets/store4/store4.txt',
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
