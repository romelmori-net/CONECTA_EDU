
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
  DocumentSnapshot? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (mounted) {
          setState(() {
            _userData = doc;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('No se pudieron cargar los datos del usuario.');
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ConectaEDU',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          _buildUserProfileMenu(),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildUserProfileMenu() {
    final photoUrl = _userData?.data() is Map<String, dynamic> 
      ? (_userData!.data() as Map<String, dynamic>)['photoUrl'] as String? 
      : null;

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          FirebaseAuth.instance.signOut();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesión'),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
          child: (photoUrl == null || photoUrl.isEmpty)
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = _userData?.data();
    String userName = 'Usuario';
    if (data != null && data is Map<String, dynamic> && data.containsKey('fullName')) {
        final rawName = data['fullName'] as String?;
        if (rawName != null && rawName.isNotEmpty) {
            userName = rawName.split(' ').first; // Get the first name
        }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¡Hola, $userName!',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A2540),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bienvenido a tu Dashboard.',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
