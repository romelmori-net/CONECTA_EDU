
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/onboarding/emotional_onboarding_screen.dart';

class SocialOnboardingScreen extends StatefulWidget {
  const SocialOnboardingScreen({super.key});

  @override
  _SocialOnboardingScreenState createState() => _SocialOnboardingScreenState();
}

class _SocialOnboardingScreenState extends State<SocialOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hobbiesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _hobbiesController.dispose();
    super.dispose();
  }

  // RESTRUCTURED AND ROBUST SAVE FUNCTION
  Future<void> _saveAndNavigate() async {
    if (!_formKey.currentState!.validate()) {
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
      // This now writes to the new nested structure: onboarding -> social
      final dataToSave = {
        'onboarding': {
          'social': {
            'hobbies': _hobbiesController.text.trim(),
          }
        }
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(dataToSave, SetOptions(merge: true)) // merge:true is crucial
          .timeout(const Duration(seconds: 15));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const EmotionalOnboardingScreen()),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('2/3: Perfil Social', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Cuéntanos sobre tus pasatiempos',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '¿Qué te gusta hacer en tu tiempo libre?',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _hobbiesController,
                decoration: InputDecoration(
                  labelText: 'Hobbies o Pasatiempos',
                  hintText: 'Ej: Leer, jugar fútbol, programar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa al menos un pasatiempo.';
                  }
                  return null;
                },
                 maxLines: 2,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAndNavigate, // Corrected function name
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Continuar',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
