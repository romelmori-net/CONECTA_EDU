import 'package:flutter/material.dart';

class AcademicOption {
  final String text;
  final IconData icon;

  const AcademicOption({required this.text, required this.icon});

  // Opciones para Carreras
  static final List<AcademicOption> careerOptions = [
    const AcademicOption(text: 'Ingeniería de Software', icon: Icons.computer),
    const AcademicOption(text: 'Medicina', icon: Icons.local_hospital),
    const AcademicOption(text: 'Derecho', icon: Icons.gavel),
    const AcademicOption(text: 'Administración', icon: Icons.business),
    const AcademicOption(text: 'Psicología', icon: Icons.psychology),
    const AcademicOption(text: 'Arquitectura', icon: Icons.architecture),
    const AcademicOption(text: 'Diseño Gráfico', icon: Icons.palette),
    const AcademicOption(text: 'Educación', icon: Icons.school),
  ];

  // Opciones para Ciclos
  static final List<AcademicOption> cycleOptions = [
    const AcademicOption(text: 'I', icon: Icons.looks_one),
    const AcademicOption(text: 'II', icon: Icons.looks_two),
    const AcademicOption(text: 'III', icon: Icons.looks_3),
    const AcademicOption(text: 'IV', icon: Icons.looks_4),
    const AcademicOption(text: 'V', icon: Icons.looks_5),
    const AcademicOption(text: 'VI', icon: Icons.looks_6),
    const AcademicOption(text: 'VII', icon: Icons.filter_7),
    const AcademicOption(text: 'VIII', icon: Icons.filter_8),
    const AcademicOption(text: 'IX', icon: Icons.filter_9),
    const AcademicOption(text: 'X', icon: Icons.filter_9_plus),
  ];

  // Opciones para Intereses
  static final List<AcademicOption> interestOptions = [
    const AcademicOption(text: 'Desarrollo de Software', icon: Icons.code),
    const AcademicOption(text: 'Investigación', icon: Icons.science),
    const AcademicOption(text: 'Gestión de Proyectos', icon: Icons.account_tree),
    const AcademicOption(text: 'Análisis de Datos', icon: Icons.analytics),
    const AcademicOption(text: 'Redes y Seguridad', icon: Icons.security),
    const AcademicOption(text: 'Inteligencia Artificial', icon: Icons.smart_toy),
  ];

  // Opciones para Modalidad de Estudio
  static final List<AcademicOption> modalityOptions = [
    const AcademicOption(text: 'Presencial', icon: Icons.school),
    const AcademicOption(text: 'Virtual', icon: Icons.laptop_mac),
    const AcademicOption(text: 'Híbrido', icon: Icons.sync_alt),
  ];
}
