import 'package:flutter/material.dart';

class SocialOption {
  final String text;
  final IconData icon;
  final Color color;

  const SocialOption({required this.text, required this.icon, required this.color});

  // Opciones para Actividades Sociales
  static final List<SocialOption> activityOptions = [
    const SocialOption(text: 'Deportes', icon: Icons.sports_soccer, color: Color(0xFF4CAF50)),
    const SocialOption(text: 'Cine y series', icon: Icons.theaters, color: Color(0xFFF44336)),
    const SocialOption(text: 'Música y conciertos', icon: Icons.music_note, color: Color(0xFFFF9800)),
    const SocialOption(text: 'Arte y cultura', icon: Icons.palette, color: Color(0xFF9C27B0)),
    const SocialOption(text: 'Videojuegos', icon: Icons.videogame_asset, color: Color(0xFF673AB7)),
    const SocialOption(text: 'Lectura y escritura', icon: Icons.book, color: Color(0xFF03A9F4)),
  ];

  // Opciones para Grupos de Interés
  static final List<SocialOption> groupOptions = [
    const SocialOption(text: 'Ciencia y Tecnología', icon: Icons.science, color: Color(0xFF009688)),
    const SocialOption(text: 'Negocios y Emprendimiento', icon: Icons.business, color: Color(0xFF795548)),
    const SocialOption(text: 'Idiomas y Culturas', icon: Icons.language, color: Color(0xFF8BC34A)),
    const SocialOption(text: 'Debate y Oratoria', icon: Icons.record_voice_over, color: Color(0xFF607D8B)),
    const SocialOption(text: 'Crecimiento Personal', icon: Icons.self_improvement, color: Color(0xFFE91E63)),
  ];

  // Opciones para Voluntariado
  static final List<SocialOption> volunteeringOptions = [
    const SocialOption(text: 'Apoyo Comunitario', icon: Icons.people, color: Color(0xFFFFC107)),
    const SocialOption(text: 'Medio Ambiente', icon: Icons.eco, color: Color(0xFF4CAF50)),
    const SocialOption(text: 'Tutorías y Educación', icon: Icons.school, color: Color(0xFF2196F3)),
    const SocialOption(text: 'Causas Animales', icon: Icons.pets, color: Color(0xFF795548)),
  ];

    // Opciones para Preferencias de Comunicación
  static final List<SocialOption> communicationOptions = [
    const SocialOption(text: 'Mensajes de texto', icon: Icons.message, color: Color(0xFF00BCD4)),
    const SocialOption(text: 'Llamadas de voz', icon: Icons.call, color: Color(0xFF4CAF50)),
    const SocialOption(text: 'Reuniones en persona', icon: Icons.group, color: Color(0xFF9C27B0)),
    const SocialOption(text: 'Videollamadas', icon: Icons.videocam, color: Color(0xFFF44336)),
  ];

}
