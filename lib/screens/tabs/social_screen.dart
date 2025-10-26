import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
              'Comunidad',
              style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCommunityCard(context),
            const SizedBox(height: 32),
            Text(
              'Grupos',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildGroupCard(context, 'Grupo de estudio', 'Únete a un grupo de estudio para tu carrera'),
            const SizedBox(height: 16),
            _buildGroupCard(context, 'Club de debate', 'Practica tus habilidades de argumentación'),
            const SizedBox(height: 16),
            _buildGroupCard(context, 'Voluntariado', 'Participa en actividades de impacto social'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.chat_rounded, color: Colors.white),
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://picsum.photos/seed/social-hero/600/300',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comunidad ConectaEDU',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Conecta con otros becarios y comparte tus experiencias.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor.withAlpha(26), // withOpacity(0.1) corrected
                      foregroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/seed/${title.hashCode}/100', // Unique image per group
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Unirse'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
