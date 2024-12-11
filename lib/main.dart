import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Adicionando import para acessar SystemChrome
// A página inicial
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
    // Definir a barra de status para ser transparente
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Barra de status transparente
      statusBarIconBrightness: Brightness.dark, // Ícones escuros na barra de status
    ));

    return MaterialApp(
      title: 'Sistema de Reservas',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Barra de AppBar transparente
          elevation: 0, // Remover a sombra da AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5F5F5), // Cor dos botões
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
        title: const Text('', style: TextStyle(color: Colors.black)), // Texto em preto
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0, // Remover a sombra
      ),
      body: Center(  // Centralizando a coluna
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 180.0),  // Reduzir o padding superior
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
            children: <Widget>[
              // Imagem no topo com a URL
              Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/reserva_sala_logo.png'), // Caminho local
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20), // Espaço entre a imagem e os botões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaça os botões igualmente
                children: <Widget>[
                  Expanded(
                    child: _buildButton(
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
                  ),
                  const SizedBox(width: 16), // Espaço entre os botões
                  Expanded(
                    child: _buildButton(
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
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espaço entre os botões e o botão de consulta
              Row( // Novo Row para o botão de consulta
                children: <Widget>[
                  Expanded(  // Expande o botão para ocupar a largura total
                    flex: 2,  // Proporção de 2/3 da largura
                    child: _buildButton(
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
                  ),
                ],
              ),
            ],
          ),
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
      icon: Icon(icon, size: 24, color: Colors.green), // Ícone em verde
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 20, // Aumenta o tamanho do texto
          fontWeight: FontWeight.w600,
          color: Colors.black, // Texto em preto
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(230, 60), // Aumenta o tamanho mínimo dos botões
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16), // Ajusta o padding vertical
      ),
    );
  }
}
