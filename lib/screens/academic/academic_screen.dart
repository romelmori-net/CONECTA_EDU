import 'package:flutter/material.dart';

class AcademicHomeScreen extends StatelessWidget {
  const AcademicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      body: Center(
        child: Text(
          'Pantalla Principal Académica',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
