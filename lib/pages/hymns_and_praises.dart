import 'package:flutter/material.dart';

class HymnsAndPraises extends StatelessWidget {
  const HymnsAndPraises({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 0, 16, 28),
          title: Text(
            "ترانيم و تسابيح",
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
