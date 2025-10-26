import 'package:flutter/material.dart';

class EmotionalOption {
  final String text;
  final IconData icon;
  final Color color;

  const EmotionalOption({required this.text, required this.icon, required this.color});

  // Opciones para ¿Cómo te has sentido últimamente?
  static final List<EmotionalOption> feelingOptions = [
    const EmotionalOption(text: 'Feliz', icon: Icons.sentiment_very_satisfied, color: Color(0xFFFFC107)),
    const EmotionalOption(text: 'Triste', icon: Icons.sentiment_very_dissatisfied, color: Color(0xFF2196F3)),
    const EmotionalOption(text: 'Ansioso/a', icon: Icons.sentiment_neutral, color: Color(0xFF757575)),
    const EmotionalOption(text: 'Estresado/a', icon: Icons.bolt, color: Color(0xFFF44336)),
    const EmotionalOption(text: 'Motivado/a', icon: Icons.lightbulb, color: Color(0xFF4CAF50)),
    const EmotionalOption(text: 'Cansado/a', icon: Icons.battery_alert, color: Color(0xFF9E9E9E)),
  ];

  // Opciones para ¿Qué hábitos te ayudan a relajarte?
  static final List<EmotionalOption> habitOptions = [
    const EmotionalOption(text: 'Ejercicio', icon: Icons.fitness_center, color: Color(0xFF009688)),
    const EmotionalOption(text: 'Meditación', icon: Icons.self_improvement, color: Color(0xFF8BC34A)),
    const EmotionalOption(text: 'Música', icon: Icons.music_note, color: Color(0xFFFF9800)),
    const EmotionalOption(text: 'Hobbies', icon: Icons.palette, color: Color(0xFF9C27B0)),
    const EmotionalOption(text: 'Dormir', icon: Icons.king_bed, color: Color(0xFF607D8B)),
    const EmotionalOption(text: 'Socializar', icon: Icons.people, color: Color(0xFFE91E63)),
  ];

  // Opciones para ¿Qué situaciones te generan más estrés?
  static final List<EmotionalOption> stressorOptions = [
    const EmotionalOption(text: 'Exámenes', icon: Icons.school, color: Color(0xFFF44336)),
    const EmotionalOption(text: 'Trabajo', icon: Icons.work, color: Color(0xFF795548)),
    const EmotionalOption(text: 'Finanzas', icon: Icons.attach_money, color: Color(0xFF4CAF50)),
    const EmotionalOption(text: 'Relaciones', icon: Icons.favorite_border, color: Color(0xFFE91E63)),
    const EmotionalOption(text: 'Futuro', icon: Icons.explore, color: Color(0xFF03A9F4)),
    const EmotionalOption(text: 'Salud', icon: Icons.healing, color: Color(0xFFFF5722)),
  ];

  // Opciones para ¿A quién o qué sueles acudir?
  static final List<EmotionalOption> resourceOptions = [
    const EmotionalOption(text: 'Amigos/as', icon: Icons.people_outline, color: Color(0xFF4CAF50)),
    const EmotionalOption(text: 'Familia', icon: Icons.family_restroom, color: Color(0xFF8BC34A)),
    const EmotionalOption(text: 'Profesionales', icon: Icons.medical_services, color: Color(0xFF2196F3)),
    const EmotionalOption(text: 'A mí mismo/a', icon: Icons.person, color: Color(0xFFFFC107)),
    const EmotionalOption(text: 'Nadie', icon: Icons.person_off, color: Color(0xFF607D8B)),
  ];
}
