import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/screens/onboarding/emotional_onboarding_screen.dart';

class AcademicOnboardingScreen extends StatefulWidget {
  const AcademicOnboardingScreen({super.key});

  @override
  State<AcademicOnboardingScreen> createState() => _AcademicOnboardingScreenState();
}

class _AcademicOnboardingScreenState extends State<AcademicOnboardingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
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

  void _navigateToNext() {
    // Aquí deberías guardar los datos en Firestore si es necesario
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EmotionalOnboardingScreen(academicData: _selections),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Onboarding Académico', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              _buildAnimatedSection('Intereses', ['Matemáticas', 'Ciencias', 'Idiomas', 'Artes', 'Humanidades', 'Tecnología'], 'interests', 0.2, 0.5),
              _buildAnimatedSection('Cursos', ['Cálculo', 'Programación', 'Historia', 'Física', 'Literatura', 'Inglés'], 'courses', 0.3, 0.6),
              _buildAnimatedSection('Dificultades', ['Procrastinación', 'Ansiedad', 'Estrés', 'Falta de motivación'], 'difficulties', 0.4, 0.7),
              _buildAnimatedSection('Objetivos', ['Mejorar notas', 'Aprender algo nuevo', 'Preparar exámenes'], 'objectives', 0.5, 0.8),
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
            const Text(
              '¿Qué te interesa?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona tus intereses, cursos, dificultades y objetivos académicos para personalizar tu experiencia',
              style: TextStyle(fontSize: 16, color: Colors.black54),
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: options.map((option) {
              final isSelected = _selections[category]!.contains(option);
              return ChoiceChip(
                label: Text(option),
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
          onPressed: _navigateToNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            shadowColor: const Color(0xFF2196F3).withAlpha(102), // withOpacity(0.4) corrected
          ),
          child: const Text(
            'Guardar y continuar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
