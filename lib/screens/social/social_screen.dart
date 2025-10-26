import 'package:flutter/material.dart';

class SocialHomeScreen extends StatelessWidget {
  const SocialHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      body: Center(
        child: Text(
          'Pantalla Principal Social',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
