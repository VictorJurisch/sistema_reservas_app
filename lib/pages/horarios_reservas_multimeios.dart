import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';  // Para formatação de data
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HorariosReservasMultimeiosPage extends StatefulWidget {
  final DateTime selectedDate;

  const HorariosReservasMultimeiosPage({required this.selectedDate, Key? key})
      : super(key: key);

  @override
  _HorariosReservasMultimeiosPageState createState() =>
      _HorariosReservasMultimeiosPageState();
}

class _HorariosReservasMultimeiosPageState
    extends State<HorariosReservasMultimeiosPage> {
  late DateTime selectedDate;
  List<String> horariosOcupados = [];
  bool isLoading = false;

  final MaskTextInputFormatter _timeFormatter =
      MaskTextInputFormatter(mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    // Carregar as reservas assim que a página for carregada
    verificarDisponibilidade();
  }

  // Função para verificar a disponibilidade da sala
  Future<void> verificarDisponibilidade() async {
    setState(() {
      isLoading = true;
    });

    final formattedDate = _formatDate(selectedDate);
    final url = 'http://10.0.2.2/projetos/api_php/api/horarios_ocupados.php?event_date=$formattedDate';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('horarios')) {
          var horarios = data['horarios'];
          if (horarios is List) {
            setState(() {
              horariosOcupados = List<String>.from(horarios);
            });
          } else {
            throw Exception('Formato de dados de horários inválido');
          }
        } else {
          throw Exception('Formato de dados de horários inválido');
        }
      } else {
        throw Exception('Erro ao carregar horários ocupados');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // Função para formatar a data no formato "yyyy-MM-dd"
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Exibe a lista de horários ocupados ou mensagem
  Widget _buildHorariosOcupadosList() {
    return horariosOcupados.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: horariosOcupados.map((horario) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  'Horário Ocupado: $horario',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }).toList(),
          )
        : const Text(
            'Nenhum horário ocupado.',
            style: TextStyle(color: Colors.green, fontSize: 16),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Multimeios'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data selecionada: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Exibir horários ocupados ou mensagem de sucesso
              _buildHorariosOcupadosList(),

              const SizedBox(height: 20),

              // Se a página ainda estiver carregando, exibe o indicador de carregamento
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
