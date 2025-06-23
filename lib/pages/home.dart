import 'package:flutter/material.dart';
import 'package:easybooklet/models/data.dart';
import 'package:easybooklet/models/widgetstore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<void> loadDataFuture;

  @override
  void initState() {
    super.initState();
    loadDataFuture = ContentData.loadContents();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 0, 16, 28),
          title: Text(
            "قصص قديسين",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: TitleData.title.length,
                itemBuilder: (BuildContext context, int index) {
                  return Widgetstore(
                    title: TitleData.title[index],
                    pathImage: PathData.pathImage[index],
                    content: ContentData.content[index],
                    audio: AudioData.audio[index],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
