// ignore_for_file: must_be_immutable

import 'package:easybooklet/pages/activities_and_coloring.dart';
import 'package:easybooklet/pages/bible_stories_screen.dart';
import 'package:easybooklet/pages/hymns_and_praises.dart';
import 'package:easybooklet/pages/questions_and_games.dart';
import 'package:easybooklet/pages/saint_stories_screen.dart';
import 'package:easybooklet/pages/verse_day.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<Widget> pages = [
    SaintStoriesScreen(),
    BibleStoriesScreen(),
    HymnsAndPraises(),
    QuestionsAndGames(),
    ActivitiesAndColoring(),
    VerseDay(),
  ];

  final List<String> titles = [
    "قصص القديسين",
    "قصص الكتاب المقدس",
    "ترانيم وتسبيح",
    "أسئلة وألعاب",
    "أنشطة وتلوين",
    "آية اليوم",
  ];

  final List<String> subTitles = [
    "تعرف على حياة القديسين",
    "قصص مشوقة من الكتاب المقدس",
    "ترانيم جميلة للأطفال",
    "اختبر معلوماتك",
    "أنشطة ممتعة ومفيدة",
    "آية مشجعة كل يوم",
  ];

  final List<Icon> icons = [
    Icon(Icons.person_rounded, size: 40, color: Color(0xFF4169E1)),
    Icon(Icons.menu_book_rounded, size: 40, color: Color(0xFF4169E1)),
    Icon(Icons.music_note_rounded, size: 40, color: Color(0xFF4169E1)),
    Icon(Icons.videogame_asset_rounded, size: 40, color: Color(0xFF4169E1)),
    Icon(Icons.brush_rounded, size: 40, color: Color(0xFF4169E1)),
    Icon(Icons.wb_sunny_rounded, size: 40, color: Color(0xFF4169E1)),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Color(0xFF4169E1), size: 24),
            ),
          ],
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage("assets/images/church.png"),
                  size: 28,
                  color: Color(0xFFFFD700),
                ),
                SizedBox(width: 8),
                Text(
                  "نور صغير",
                  style: TextStyle(fontSize: 24, color: Color(0xFF4169E1)),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1,vertical: 12),
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height / 4.2,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 217, 13),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 48),
                        Text(
                          "نور صغير",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "رحلة روحية ممتعة للأطفال",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pages.length,
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pages[index]),
                        );
                      },
                      child: Card(
                        color: Colors.amber[100],
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                icons[index],
                                SizedBox(height: 10),
                                Text(
                                  titles[index],
                                  style: TextStyle(
                                    color: Color(0xFF4169E1),
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  subTitles[index],
                                  style: TextStyle(
                                    color: Color(0xFF4169E1),
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    color: const Color.fromARGB(255, 205, 255, 215),
                    width: MediaQuery.of(context).size.width * 85,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("تعلم فضيلة", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold)),
                            SizedBox(height: 3,),
                            Text(
                              "فضيلة هذا الأسبوع: المحبة",
                              style: TextStyle(fontSize: 15,color: const Color(0x66666666)),
                            ),
                            SizedBox(height: 1,),
                            Text(
                              "\"أحبوا بعضكم بعضاً كما أحببتكم\"",
                              style: TextStyle(fontSize: 13,color: const Color(0xFF4169E1)),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
