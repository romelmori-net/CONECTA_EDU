import 'package:flutter/material.dart';
import 'package:myapp/models/emotional_option.dart';
import 'package:myapp/screens/onboarding/social_onboarding_screen.dart';
import 'package:myapp/widgets/animated_onboarding_widget.dart';
import 'package:myapp/widgets/onboarding_progress_indicator.dart';

class EmotionalOnboardingScreen extends StatefulWidget {
  final Map<String, List<String>> academicData;

  const EmotionalOnboardingScreen({super.key, required this.academicData});

  @override
  State<EmotionalOnboardingScreen> createState() =>
      _EmotionalOnboardingScreenState();
}

class _EmotionalOnboardingScreenState extends State<EmotionalOnboardingScreen> {
  final Map<String, List<String>> _selections = {
    'feelings': [],
    'habits': [],
    'stressors': [],
    'resources': [],
  };

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
    bool allAnswered = _selections.values.every((list) => list.isNotEmpty);

    if (!allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona al menos una opción en cada categoría.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SocialOnboardingScreen(
          academicData: widget.academicData,
          emotionalData: _selections,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Bienestar Emocional',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OnboardingProgressIndicator(step: 2),
            const SizedBox(height: 24),
            AnimatedOnboardingWidget(
              delay: 300,
              child: Text(
                'Cuéntanos sobre ti',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A2540),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedOnboardingWidget(
              delay: 400,
              child: Text(
                'Esto nos ayudará a personalizar tu experiencia.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: '¿Cómo te has sentido últimamente?',
              options: EmotionalOption.feelingOptions,
              category: 'feelings',
              delay: 500,
            ),
            _buildSection(
              title: '¿Qué hábitos te ayudan a relajarte?',
              options: EmotionalOption.habitOptions,
              category: 'habits',
              delay: 600,
            ),
            _buildSection(
              title: '¿Qué situaciones te generan más estrés?',
              options: EmotionalOption.stressorOptions,
              category: 'stressors',
              delay: 700,
            ),
            _buildSection(
              title: '¿A quién o qué sueles acudir?',
              options: EmotionalOption.resourceOptions,
              category: 'resources',
              delay: 800,
            ),
            const SizedBox(height: 32),
            AnimatedOnboardingWidget(
              delay: 900,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _navigateToNext,
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  label: const Text('Continuar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<EmotionalOption> options,
    required String category,
    required int delay,
  }) {
    return AnimatedOnboardingWidget(
      delay: delay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF333333)),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: options.map((option) {
              final isSelected = _selections[category]!.contains(option.text);
              return ChoiceChip(
                label: Text(option.text),
                avatar:
                    Icon(option.icon, color: isSelected ? Colors.white70 : Colors.black54, size: 20),
                selected: isSelected,
                onSelected: (selected) {
                  _toggleSelection(category, option.text);
                },
                selectedColor: option.color,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                      color: isSelected
                          ? option.color
                          : const Color(0xFFDCDCDC)),
                ),
                elevation: 1,
                pressElevation: 3,
                shadowColor: Colors.black.withAlpha(26), // withOpacity(0.1) corrected
                selectedShadowColor: option.color.withAlpha(77), // withOpacity(0.3) corrected
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
