import 'package:easybooklet/pages/read.dart';
import 'package:flutter/material.dart';

class Widgetstore extends StatelessWidget {
  final String pathImage;
  final String title;
  final String content;
  final String audio;


  const Widgetstore({
    super.key,
    required this.title,
    required this.pathImage,
    required this.content,
    required this.audio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Read(title: title, content: content,audio: audio,pathImage: pathImage,),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  pathImage,
                  width: MediaQuery.of(context).size.width / 1.2,
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height / 3.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
