
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Use a Future directly, this is cleaner for FutureBuilder
  late final Future<DocumentSnapshot<Map<String, dynamic>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userDataFuture = FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      // Handle the case where the user is null, maybe pop the navigator
      // For now, create a future that resolves to an error.
      _userDataFuture = Future.error('Usuario no autenticado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1), // Darker blue for contrast
        elevation: 2,
        actions: [
          _buildUserProfileMenu(),
        ],
      ),
      backgroundColor: const Color(0xFFF0F2F5), // Light grey background
      // Use FutureBuilder to handle loading/error states cleanly
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No se encontraron datos del usuario.'));
          }

          // Data is ready, let's build the UI
          final userData = snapshot.data!.data()!;

          // Safely extract data based on our blueprint.md
          final String fullName = userData['fullName'] ?? 'Usuario Desconocido';
          final Map<String, dynamic> onboardingData = userData['onboarding'] ?? {};
          final Map<String, dynamic> academicData = onboardingData['academic'] ?? {};
          final List<dynamic> interests = academicData['interests'] ?? [];

          return _buildDashboardUI(context, fullName, interests.cast<String>());
        },
      ),
    );
  }

  Widget _buildDashboardUI(BuildContext context, String fullName, List<String> interests) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(fullName),
          const SizedBox(height: 30),
          _buildInterestsSection(interests),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(String fullName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola, ${fullName.split(' ').first}!',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0A2540),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Listo para un día de aprendizaje y conexión.',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection(List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis Grupos de Interés',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0A2540),
          ),
        ),
        const SizedBox(height: 16),
        if (interests.isEmpty)
          const Text('No seleccionaste intereses durante el onboarding.')
        else
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: interests.map((interest) => Chip(
              label: Text(
                interest,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              backgroundColor: const Color(0xFF2196F3), // Vibrant blue
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.2),
            )).toList(),
          ),
      ],
    );
  }

  Widget _buildUserProfileMenu() {
    // This menu can be expanded later to show profile picture etc.
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          FirebaseAuth.instance.signOut();
        }
      },
      icon: const Icon(Icons.more_vert, color: Colors.white),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.exit_to_app, color: Color(0xFF0D47A1)),
            title: Text('Cerrar Sesión'),
          ),
        ),
      ],
    );
  }
}
