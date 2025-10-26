import 'package:flutter/material.dart';

class EmotionalHomeScreen extends StatelessWidget {
  const EmotionalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      body: Center(
        child: Text(
          'Pantalla Principal Emocional',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
