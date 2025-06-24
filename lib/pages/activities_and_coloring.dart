// ignore_for_file: unnecessary_import, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:easybooklet/pages/drawing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivitiesAndColoring extends StatelessWidget {
  ActivitiesAndColoring({super.key});

  final List<String> activityTitles = [
    "لون الكنيسة",
    "لون مع الملائكة",
    "نشاط الصليب",
    "لون الأرنب",
    "لون السمكة",
  ];

  final List<String> activityImages = [
    "assets/activities/ch.png",
    "assets/activities/m.png",
    "assets/activities/s.png",
    "assets/activities/a.png",
    "assets/activities/f.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 16, 28),
        title: Text(
          "أنشطة وتلوين",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: activityTitles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("اختر ما تريد:"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // قفل الحوار
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullImageScreen(
                                imagePath: activityImages[index],
                                title: activityTitles[index],
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.image),
                        label: Text("عرض الصورة"),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // قفل الحوار
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrawingScreen(
                                imagePath: activityImages[index],
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.brush),
                        label: Text("لون بنفسك"),
                      ),
                    ],
                  ),
                );
              },

              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          activityImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        activityTitles[index],
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String imagePath;
  final String title;

  const FullImageScreen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  Future<void> downloadImage(BuildContext context) async {
    try {
      // 1. اطلب صلاحية التخزين
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى السماح بالوصول إلى التخزين')),
        );
        return;
      }

      // 2. اقرأ الصورة من الأصول
      final byteData = await rootBundle.load(imagePath);
      final Uint8List bytes = byteData.buffer.asUint8List();

      // 3. احصل على المسار
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/${title.replaceAll(" ", "_")}.png';

      // 4. اكتب الملف
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ تم حفظ الصورة في: ${filePath.split('/').last}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء تحميل الصورة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Color(0xFF4169E1))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF4169E1)),
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: () => downloadImage(context),
            tooltip: 'تحميل الصورة',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}
