
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionalOnboardingScreen extends StatefulWidget {
  const EmotionalOnboardingScreen({super.key});

  @override
  _EmotionalOnboardingScreenState createState() => _EmotionalOnboardingScreenState();
}

class _EmotionalOnboardingScreenState extends State<EmotionalOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stressManagementController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _stressManagementController.dispose();
    super.dispose();
  }

  // FINAL, RESTRUCTURED, AND ROBUST FINALIZE FUNCTION
  Future<void> _finalizeOnboarding() async {
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
      // This final write completes the onboarding structure and flags completion.
      final dataToSave = {
        'onboarding': {
          'emotional': {
            'stressManagement': _stressManagementController.text.trim(),
          },
        },
        'hasCompletedOnboarding': true, // This is the crucial flag!
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(dataToSave, SetOptions(merge: true)) // merge:true is crucial
          .timeout(const Duration(seconds: 15));

      // On success, AuthWrapper will handle navigation automatically.
      // No need to do anything else here.

    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is TimeoutException
                ? 'La conexión es lenta. Por favor, inténtalo de nuevo.'
                : 'Ocurrió un error al finalizar el registro.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    // Note: No need to set isLoading to false on success, as the widget will be unmounted.
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3/3: Bienestar Emocional', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevents user from going back
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tu bienestar es importante',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '¿Cómo manejas el estrés o la presión académica?',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _stressManagementController,
                decoration: InputDecoration(
                  labelText: 'Estrategias de manejo del estrés',
                  hintText: 'Ej: Hago ejercicio, hablo con amigos, medito',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo no puede estar vacío.';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _finalizeOnboarding,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Finalizar y Entrar',
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
