import 'package:flutter/material.dart';
import 'reservas_page.dart';  // Importando a página de reservas
import 'multimeios_page.dart'; // ou o caminho correto do arquivo
import 'auditorio_page.dart';  // Importando a página de auditório

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
      icon: Icon(icon, size: 24, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
