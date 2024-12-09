import 'package:flutter/material.dart';

class ReservasPage extends StatelessWidget {
  const ReservasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Reservas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Aqui você pode consultar suas reservas!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Você pode substituir o conteúdo abaixo por uma lista real de reservas
            Expanded(
              child: ListView.builder(
                itemCount: 10,  // Número de reservas (substitua conforme necessário)
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Reserva #$index'),
                    subtitle: Text('Detalhes da reserva #$index'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navegar para detalhes da reserva ou fazer outra ação
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
