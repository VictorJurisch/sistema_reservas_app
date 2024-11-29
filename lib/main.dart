import 'package:flutter/material.dart';
import 'pages/home_page.dart';        // A página inicial
import 'pages/reservas_page.dart';    // A página de reservas
import 'pages/multimeios_page.dart';  // A página de multimeios
import 'pages/auditorio_page.dart';   // A página de auditório


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Reservas',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600, // Cor dos botões
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Texto em preto
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Reservas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bem-vindo ao Sistema de Reservas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildButton(
              context,
              'Consultar Reservas',
              Icons.search,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReservasPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              'Multimeios',
              Icons.video_call,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MultimeiosPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              'Auditório',
              Icons.event,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuditorioPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24, color: Colors.black), // Ícone em preto
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black, // Texto em preto
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
