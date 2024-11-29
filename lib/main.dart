import 'package:flutter/material.dart';

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
        // Definindo a cor principal como verde e ajustando o tema
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          elevation: 0,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.green.shade800, // Verde escuro para títulos
          ),
          bodyLarge: TextStyle(
            color: Colors.green.shade600, // Verde médio para textos
            fontSize: 16,
          ),
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
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

class ReservasPage extends StatelessWidget {
  const ReservasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Reservas'),
      ),
      body: const Center(
        child: Text('Aqui você pode consultar suas reservas!'),
      ),
    );
  }
}

class MultimeiosPage extends StatelessWidget {
  const MultimeiosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multimeios'),
      ),
      body: const Center(
        child: Text('Aqui você pode gerenciar multimeios!'),
      ),
    );
  }
}

class AuditorioPage extends StatelessWidget {
  const AuditorioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditório'),
      ),
      body: const Center(
        child: Text('Aqui você pode gerenciar o auditório!'),
      ),
    );
  }
}
