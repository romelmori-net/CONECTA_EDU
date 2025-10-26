import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (mounted) {
          setState(() {
            _userName = doc.exists && doc.data()!.containsKey('name') 
                          ? doc.data()!['name'] 
                          : (user.displayName ?? 'Usuario');
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _userName = user.displayName ?? 'Usuario';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back arrow
        title: Text('ConectaEDU', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${_userName ?? '...'}',
              style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              'Bienvenido a conectaEDU',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardCard('Mi progreso', 'https://picsum.photos/seed/progress/200'),
                _buildDashboardCard('Tareas', 'https://picsum.photos/seed/tasks/200'),
                _buildDashboardCard('Alertas', 'https://picsum.photos/seed/alerts/200'),
                _buildDashboardCard('Comunidad', 'https://picsum.photos/seed/community/200'),
              ],
            ),
            const SizedBox(height: 24),
            _buildMotivationCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String imageUrl) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87, height: 1.5),
          children: [
            TextSpan(text: '¡Buenos días, ${_userName ?? '...'}! ☀️\n'),
            const TextSpan(text: 'Hoy es un gran día para seguir avanzando en tus metas 🚀. ¿Quieres que te dé un tip de motivación rápida?'),
          ],
        ),
      ),
    );
  }
}
