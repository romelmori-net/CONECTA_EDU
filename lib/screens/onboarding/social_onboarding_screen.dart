import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/social_option.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'package:myapp/widgets/animated_onboarding_widget.dart';
import 'package:myapp/widgets/onboarding_progress_indicator.dart';

class SocialOnboardingScreen extends StatefulWidget {
  final Map<String, List<String>> academicData;
  final Map<String, List<String>> emotionalData;

  const SocialOnboardingScreen({
    super.key,
    required this.academicData,
    required this.emotionalData,
  });

  @override
  State<SocialOnboardingScreen> createState() => _SocialOnboardingScreenState();
}

class _SocialOnboardingScreenState extends State<SocialOnboardingScreen> {
  final Map<String, List<String>> _selections = {
    'activities': [],
    'groups': [],
    'volunteering': [],
    'communication': [],
  };
  bool _isLoading = false;

  void _toggleSelection(String category, String option) {
    setState(() {
      if (_selections[category]!.contains(option)) {
        _selections[category]!.remove(option);
      } else {
        _selections[category]!.add(option);
      }
    });
  }

  void _saveAllDataAndFinish() async {
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

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final allOnboardingData = {
          ...widget.academicData,
          ...widget.emotionalData,
          ..._selections,
          'hasCompletedOnboarding': true,
          'lastUpdate': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(allOnboardingData, SetOptions(merge: true));

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar tus datos: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
       appBar: AppBar(
        title: const Text('Conexión Social', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OnboardingProgressIndicator(step: 3),
                const SizedBox(height: 24),
                 AnimatedOnboardingWidget(
                  delay: 300,
                  child: Text(
                    'Define tus preferencias sociales',
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
                    'Esto nos ayudará a conectar con otros.',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  title: '¿Qué actividades te gustan?',
                  options: SocialOption.activityOptions,
                  category: 'activities',
                  delay: 500,
                ),
                 _buildSection(
                  title: '¿A qué grupos te unirías?',
                  options: SocialOption.groupOptions,
                  category: 'groups',
                  delay: 600,
                ),
                _buildSection(
                  title: '¿En qué causas te gustaría ayudar?',
                  options: SocialOption.volunteeringOptions,
                  category: 'volunteering',
                  delay: 700,
                ),
                _buildSection(
                  title: '¿Cómo prefieres comunicarte?',
                  options: SocialOption.communicationOptions,
                  category: 'communication',
                  delay: 800,
                ),
                const SizedBox(height: 32),
                AnimatedOnboardingWidget(
                  delay: 900,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _saveAllDataAndFinish,
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: const Text('Finalizar y Guardar'),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28a745),
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
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(102), // withOpacity(0.4) corrected
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<SocialOption> options,
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
