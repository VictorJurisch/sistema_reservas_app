import 'package:flutter/material.dart';

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});

  @override
  _ReservasPageState createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  final _emailController = TextEditingController();
  String _selectedSala = 'auditorio';
  String _message = '';
  List<Map<String, String>> _reservas = [];

  // Função para simular a consulta (em breve será substituída pela lógica de conexão com o backend)
  void _consultarReservas() {
    setState(() {
      // Simulação de reservas para fins de exemplo
      if (_emailController.text.isEmpty) {
        _message = 'Por favor, insira um e-mail.';
        _reservas = [];  // Limpar reservas ao mostrar a mensagem de erro
      } else {
        _message = 'Reservas encontradas:';
        _reservas = [
          {'nome': 'Reserva 1', 'sala': 'Auditório', 'data': '10/12/2024', 'hora': '09:00', 'status': 'Ativo'},
          {'nome': 'Reserva 2', 'sala': 'Multimeios', 'data': '11/12/2024', 'hora': '10:00', 'status': 'Cancelado'},
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de Reservas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de E-mail
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Seleção de Sala
            DropdownButtonFormField<String>(
              value: _selectedSala,
              onChanged: (value) {
                setState(() {
                  _selectedSala = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'auditorio', child: Text('Auditório')),
                DropdownMenuItem(value: 'multimeios', child: Text('Multimeios')),
              ],
              decoration: const InputDecoration(
                labelText: 'Selecione a Sala',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Botão para consultar
            ElevatedButton(
              onPressed: _consultarReservas,
              child: const Text('Consultar'),
            ),
            const SizedBox(height: 16),
            // Mensagem
            if (_message.isNotEmpty)
              Text(_message, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Lista de Reservas
            if (_reservas.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _reservas.length,
                  itemBuilder: (context, index) {
                    var reserva = _reservas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(reserva['nome']!),
                        subtitle: Text('${reserva['sala']} - ${reserva['data']} às ${reserva['hora']}'),
                        trailing: Text(
                          reserva['status']!,
                          style: TextStyle(
                            color: reserva['status'] == 'Cancelado' ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Caso não haja reservas
            if (_reservas.isEmpty && _message.isNotEmpty)
              const Text('Nenhuma reserva encontrada.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
