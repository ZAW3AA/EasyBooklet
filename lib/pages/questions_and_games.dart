import 'package:flutter/material.dart';

class QuestionsAndGames extends StatelessWidget {
  const QuestionsAndGames({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 0, 16, 28),
          title: Text(
            "أسئلة وألعاب",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
