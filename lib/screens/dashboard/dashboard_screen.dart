import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =========================================================================
// MODO DE DEPURACIÓN: AISLANDO LA FALLA
// Se han reemplazado todas las pestañas por contenedores de colores.
// Si esto funciona, el problema está en una de las pantallas originales.
// =========================================================================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Lista de widgets de prueba. Son inofensivos.
  static const List<Widget> _widgetOptions = <Widget>[
    _DebugScreen(color: Colors.blue, name: 'Inicio (Prueba)'),
    _DebugScreen(color: Colors.green, name: 'Académico (Prueba)'),
    _DebugScreen(color: Colors.orange, name: 'Emocional (Prueba)'),
    _DebugScreen(color: Colors.purple, name: 'Social (Prueba)'),
    _DebugScreen(color: Colors.red, name: 'Perfil (Prueba)'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0D6EFD),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Académico'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Emocional'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Social'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

// Widget de prueba simple para mostrar en lugar de las pantallas reales.
class _DebugScreen extends StatelessWidget {
  final Color color;
  final String name;

  const _DebugScreen({required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bug_report, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'MODO DEPURACIÓN ACTIVO',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
             const SizedBox(height: 10),
             Text(
              'Si ves esto, la navegación es CORRECTA.\nEl error está en una de las pantallas reales.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
