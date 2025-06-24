// ignore_for_file: sort_child_properties_last

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerseDay extends StatefulWidget {
  const VerseDay({super.key});

  @override
  State<VerseDay> createState() => _VerseDayState();
}

class _VerseDayState extends State<VerseDay> {
  final List<String> verses = [
    "كُلُّ أَشْيَاءٍ تَعْمَلُ مَعًا لِلْخَيْرِ لِلَّذِينَ يُحِبُّونَ اللهَ. (رومية 8: 28)",
    "الرَّبُّ نُورِي وَخَلاَصِي، مِمَّنْ أَخَافُ؟ (مزمور 27: 1)",
    "لاَ تَخَفْ، لأَنِّي مَعَكَ. (إشعياء 41: 10)",
    "فِي الضِّيقِ دَعَوْتَ، فَنَجَّيْتُكَ. (مزمور 81: 7)",
    "أَحِبُّوا بَعْضُكُمْ بَعْضًا كَمَا أَحْبَبْتُكُمْ. (يوحنا 13: 34)",
    "طُوبَى لِلرُّحَمَاءِ، لأَنَّهُمْ يُرْحَمُونَ. (متى 5: 7)",
    "كُلُّ مَنْ يَطْلُبْ يَجِدْ. (متى 7: 8)",
    "فَرِحِينَ فِي الرَّجَاءِ، صَابِرِينَ فِي الضِّيقِ. (رومية 12: 12)",
    "الرَّبُّ قَرِيبٌ لِكُلِّ الَّذِينَ يَدْعُونَهُ. (مزمور 145: 18)",
    "الْمَحَبَّةُ لاَ تَسْقُطُ أَبَدًا. (1 كورنثوس 13: 8)",
    "اِفْرَحُوا فِي الرَّبِّ كُلَّ حِينٍ. (فيلبي 4: 4)",
    "صَنَعَ اللهُ كُلَّ شَيْءٍ حَسَنًا. (جامعة 3: 11)",
    "قَدْ أَحْبَبْتُكَ مَحَبَّةً أَبَدِيَّةً. (إرميا 31: 3)",
    "الرَّبُّ صَلاَبَتِي وَتَرْنِيمَتِي. (مزمور 118: 14)",
    "تَوَكَّلْ عَلَى الرَّبِّ مِنْ كُلِّ قَلْبِكَ. (أمثال 3: 5)",
    "الرَّبُّ رَاعِيَّ، فَلاَ يُعْوِزُنِي شَيْءٌ. (مزمور 23: 1)",
    "هذَا هُوَ الْيَوْمُ الَّذِي صَنَعَهُ الرَّبُّ. (مزمور 118: 24)",
    "وَلْيَكُنْ كُلُّ شَيْءٍ بِمَحَبَّةٍ. (1 كورنثوس 16: 14)",
    "كُونُوا نُورًا فِي الْعَالَمِ. (متى 5: 14)",
    "أَفْرَحُ بِكَ وَأُرَنِّمُ لاسْمِكَ. (مزمور 9: 2)",
  ];

  String selectedVerse = "جاري التحميل...";
  String todayKey = "";

  @override
  void initState() {
    super.initState();
    _loadVerseOfTheDay();
  }

  Future<void> _loadVerseOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    todayKey = "${today.year}-${today.month}-${today.day}";

    final savedDate = prefs.getString('verse_date');
    final savedVerse = prefs.getString('verse_text');

    if (savedDate == todayKey && savedVerse != null) {
      setState(() {
        selectedVerse = savedVerse;
      });
    } else {
      final newVerse = _getRandomVerse();
      await prefs.setString('verse_date', todayKey);
      await prefs.setString('verse_text', newVerse);
      setState(() {
        selectedVerse = newVerse;
      });
    }
  }

  String _getRandomVerse() {
    final random = Random();
    return verses[random.nextInt(verses.length)];
  }

  void _showNewRandomVerse() {
    setState(() {
      selectedVerse = _getRandomVerse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 16, 28),
        title: Text(
          "آية اليوم",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny_rounded, color: Color(0xFF4169E1), size: 60),
              SizedBox(height: 30),
              Text(
                selectedVerse,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, height: 1.6),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _showNewRandomVerse,
                child: Text("آية جديدة"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4169E1),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
