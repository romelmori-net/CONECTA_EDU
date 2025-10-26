import 'package:flutter/material.dart';
import 'package:myapp/screens/academic/academic_screen.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'package:myapp/screens/emotional/emotional_screen.dart';
import 'package:myapp/screens/profile/profile_screen.dart';
import 'package:myapp/screens/social/social_screen.dart';
import 'package:myapp/screens/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    AcademicHomeScreen(),
    EmotionalHomeScreen(),
    SocialHomeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Académico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Emocional',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3D64E8),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: const Color(0xFF3282FD),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }
}
