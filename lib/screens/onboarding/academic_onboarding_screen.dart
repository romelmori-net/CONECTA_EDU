
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/onboarding/social_onboarding_screen.dart';

class AcademicOnboardingScreen extends StatefulWidget {
  const AcademicOnboardingScreen({super.key});

  @override
  State<AcademicOnboardingScreen> createState() => _AcademicOnboardingScreenState();
}

class _AcademicOnboardingScreenState extends State<AcademicOnboardingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = false;
  final Map<String, List<String>> _selections = {
    'interests': [],
    'courses': [],
    'difficulties': [],
    'objectives': [],
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSelection(String category, String option) {
    setState(() {
      if (_selections[category]!.contains(option)) {
        _selections[category]!.remove(option);
      } else {
        _selections[category]!.add(option);
      }
    });
  }

  // RESTRUCTURED SAVE FUNCTION
  Future<void> _saveAndNavigate() async {
    if (_selections.values.any((list) => list.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona al menos una opción en cada categoría.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no autenticado.'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      // This now writes to the new nested structure: onboarding -> academic
      final dataToSave = {
        'onboarding': {
          'academic': _selections,
        }
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(dataToSave, SetOptions(merge: true)) // merge:true is crucial
          .timeout(const Duration(seconds: 15));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SocialOnboardingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is TimeoutException
                ? 'La conexión es lenta. Por favor, inténtalo de nuevo.'
                : 'Ocurrió un error al guardar los datos.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('1/3: Perfil Académico', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedHeader(0.0, 0.3),
              _buildAnimatedSection('Tus Intereses Principales', ['Matemáticas', 'Ciencias', 'Idiomas', 'Artes', 'Humanidades', 'Tecnología'], 'interests', 0.2, 0.5),
              _buildAnimatedSection('Cursos de Enfoque', ['Cálculo', 'Programación', 'Historia', 'Física', 'Literatura', 'Inglés'], 'courses', 0.3, 0.6),
              _buildAnimatedSection('Desafíos Comunes', ['Procrastinación', 'Ansiedad por exámenes', 'Estrés', 'Falta de motivación'], 'difficulties', 0.4, 0.7),
              _buildAnimatedSection('Tus Metas Actuales', ['Mejorar notas', 'Aprender una habilidad', 'Preparar exámenes finales'], 'objectives', 0.5, 0.8),
              const SizedBox(height: 32),
              _buildAnimatedContinueButton(0.7, 1.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedWidget({required Widget child, required double start, required double end}) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOutCubic)),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeIn)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildAnimatedHeader(double start, double end) {
    return _buildAnimatedWidget(
      start: start,
      end: end,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              'Personaliza tu camino',
              style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 8),
            Text(
              'Ayúdanos a entender tus metas y desafíos para ofrecerte el mejor apoyo.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  Widget _buildAnimatedSection(String title, List<String> options, String category, double start, double end) {
    return _buildAnimatedWidget(
      start: start,
      end: end,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: options.map((option) {
              final isSelected = _selections[category]!.contains(option);
              return ChoiceChip(
                label: Text(option, style: GoogleFonts.poppins()),
                selected: isSelected,
                onSelected: (selected) => _toggleSelection(category, option),
                backgroundColor: Colors.grey[100],
                selectedColor: const Color(0xFF2196F3),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAnimatedContinueButton(double start, double end) {
    return _buildAnimatedWidget(
      start: start,
      end: end,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveAndNavigate,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            shadowColor: const Color(0xFF2196F3).withAlpha(102),
          ),
          child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Guardar y Continuar',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
        ),
      ),
    );
  }
}
