import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionalScreen extends StatelessWidget {
  const EmotionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emocional', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Cómo te sientes hoy?',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                _buildEmotionChip('Feliz 😃', context, isSelected: true),
                _buildEmotionChip('Triste 😟', context),
                _buildEmotionChip('Tranquilo 😌', context),
                _buildEmotionChip('Preocupado 😥', context),
                _buildEmotionChip('Ansioso 😰', context),

              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Recursos para tu bienestar',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              category: 'BIENESTAR',
              title: 'Diario de gratitud',
              subtitle: 'Ejercicios guiados para reducir el estrés y mejorar la concentración',
              imageUrl: 'https://picsum.photos/seed/gratitude/300/200',
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              category: 'BIENESTAR',
              title: 'Manejo de estrés',
              subtitle: 'Consejos prácticos para identificar y gestionar el estrés en tu vida',
              imageUrl: 'https://picsum.photos/seed/stress/300/200',
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              category: 'APOYO - Recursos de ayuda',
              title: 'Consejos prácticos',
              subtitle: 'Accede a guías y herramientas para el crecimiento personal y la resiliencia',
              imageUrl: 'https://picsum.photos/seed/support/300/200',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          label: Text('Chat con tutor', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D6EFD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionChip(String label, BuildContext context, {bool isSelected = false}) {
    return Chip(
      label: Text(label),
      labelStyle: GoogleFonts.poppins(
        color: isSelected ? Colors.white : Theme.of(context).primaryColor,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.white,
      side: BorderSide(color: Theme.of(context).primaryColor.withAlpha(128)), // withOpacity(0.5) corrected
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  Widget _buildResourceCard(BuildContext context, {required String category, required String title, required String subtitle, required String imageUrl}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.poppins(fontSize: 12, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, height: 100, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
