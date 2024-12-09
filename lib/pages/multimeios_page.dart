import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import para manipulação de data
import 'package:table_calendar/table_calendar.dart'; // Import para o calendário interativo

class MultimeiosPage extends StatefulWidget {
  const MultimeiosPage({Key? key}) : super(key: key);

  @override
  _MultimeiosPageState createState() => _MultimeiosPageState();
}

class _MultimeiosPageState extends State<MultimeiosPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _horaFinalController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  String? _setor;
  String? _publico;
  bool _aAinfInterno = false;
  bool _aAscomInterno = false;
  bool _aAinfExterno = false;
  bool _aAscomExterno = false;
  bool _cafeAguaExterno = false;
  bool _coffeBreakExterno = false;
  DateTime _selectedDate = DateTime.now(); // Data selecionada no calendário
  DateTime _focusedDate = DateTime.now(); // Data em foco no calendário

  // Função para selecionar a data do calendário
void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  // Verifica se a data selecionada é anterior à data atual
  if (selectedDay.isBefore(DateTime.now())) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Não é possível reservar para datas passadas!')),
    );
    return; // Impede a seleção da data passada
  }

  setState(() {
    _selectedDate = selectedDay;
    _focusedDate = focusedDay;
  });
}


  // Função para verificar a disponibilidade do horário
  Future<bool> _verificarDisponibilidade(String data, String horaInicio, String horaFinal) async {
    final String checkUrl = 'http://10.0.2.2/projetos/api_php/api/verificar_disponibilidade.php';

    final Map<String, String> checkParams = {
      'data': data,
      'hora_inicio': horaInicio,
      'hora_final': horaFinal,
      'sala': 'Multimeios',
    };

    final checkBody = Uri(queryParameters: checkParams).query;

    try {
      final checkResponse = await http.post(
        Uri.parse(checkUrl),
        body: checkBody,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (checkResponse.statusCode == 200) {
        final Map<String, dynamic> checkData = json.decode(checkResponse.body);
        if (checkData['disponivel'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Horário indisponível: ${checkData['motivo']}')),
          );
          return false; // Horário indisponível
        }
        return true; // Horário disponível
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao verificar disponibilidade.')),
        );
        return false; // Erro ao verificar disponibilidade
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor: $e')),
      );
      return false; // Erro na requisição
    }
  }

  // Função para enviar o formulário de reserva
  Future<void> _enviarFormulario() async {
    if (_nomeController.text.isEmpty ||
        _horaInicioController.text.isEmpty ||
        _horaFinalController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _setor == null ||
        _publico == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos obrigatórios devem ser preenchidos!')),
      );
      return;
    }

    // Converte a data para o formato yyyy-MM-dd
    String eventDateFormatted = DateFormat("yyyy-MM-dd").format(_selectedDate);

    // Verifica disponibilidade do horário
    bool isAvailable = await _verificarDisponibilidade(
      eventDateFormatted,
      _horaInicioController.text,
      _horaFinalController.text,
    );

    if (!isAvailable) {
      return; // Se o horário não estiver disponível, a função é interrompida
    }

    // URL para salvar a reserva
    final String saveUrl = 'http://10.0.2.2/projetos/api_php/api/salvar_reserva.php';

    final Map<String, String> dados = {
      'nome': _nomeController.text,
      'data': eventDateFormatted, // Envia a data formatada
      'hora_inicio': _horaInicioController.text,
      'hora_final': _horaFinalController.text,
      'setor': _setor ?? '',
      'publico': _publico ?? '',
      'contato': _emailController.text,
      'descricao': _descricaoController.text,
      'a_ainf': _publico == 'Interno' && _aAinfInterno ? '1' : '0',
      'a_ascom': _publico == 'Interno' && _aAscomInterno ? '1' : '0',
      'cafe_agua': _publico == 'Externo' && _cafeAguaExterno ? '1' : '0',
      'coffe_break': _publico == 'Externo' && _coffeBreakExterno ? '1' : '0',
      'sala': 'Multimeios', // Adiciona o campo fixo para "sala"
      'status': 'Ativo',
    };

    final body = Uri(queryParameters: dados).query;

    try {
      final response = await http.post(
        Uri.parse(saveUrl),
        body: body,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reserva salva com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao conectar ao servidor: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar reserva: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva Multimeios'),
        backgroundColor: Colors.green, // Cor verde no AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título e Imagem
              Center(
                child: Column(
                  children: [
                    Image.network(
                      'https://i.imgur.com/sIFdbEJ.png',
                      height: 300,
                      width: 300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Formulário de Reserva',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Campos do formulário
              _buildTextField(_nomeController, 'Nome'),
              const SizedBox(height: 16),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2101, 1, 1),
                focusedDay: _focusedDate,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                onDaySelected: _onDaySelected,
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                  todayTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(_horaInicioController, 'Hora de Início'),
              _buildTextField(_horaFinalController, 'Hora Final'),
              _buildTextField(_emailController, 'Email para Contato'),
              _buildTextField(_descricaoController, 'Descrição'),
              _buildDropdown('Setor', ['AINF', 'APC', 'ASJU', 'ASPRE', 'AUDI', 'CTSM', 'DPCF', 'DPNT', 'DPPA', 'DPRH', 'DPTD', 'DREX'], (value) {
                setState(() {
                  _setor = value;
                });
              }),
              _buildDropdown('Público', ['Interno', 'Externo'], (value) {
                setState(() {
                  _publico = value;
                });
              }),

              if (_publico == 'Interno') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCheckbox('Apoio da AINF', _aAinfInterno, (value) {
                      setState(() {
                        _aAinfInterno = value!;
                      });
                    }),
                    const SizedBox(width: 16), // Espaço entre os dois checkboxes
                    _buildCheckbox('Apoio da ASCOM', _aAscomInterno, (value) {
                      setState(() {
                        _aAscomInterno = value!;
                      });
                    }),
                  ],
                ),
              ],

              if (_publico == 'Externo') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCheckbox('Café e Água', _cafeAguaExterno, (value) {
                      setState(() {
                        _cafeAguaExterno = value!;
                      });
                    }),
                    const SizedBox(width: 16), // Espaço entre os dois checkboxes
                    _buildCheckbox('Coffee Break', _coffeBreakExterno, (value) {
                      setState(() {
                        _coffeBreakExterno = value!;
                      });
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCheckbox('Apoio da AINF', _aAinfExterno, (value) {
                      setState(() {
                        _aAinfExterno = value!;
                      });
                    }),
                    const SizedBox(width: 16), // Espaço entre os dois checkboxes
                    _buildCheckbox('Apoio da ASCOM', _aAscomExterno, (value) {
                      setState(() {
                        _aAscomExterno = value!;
                      });
                    }),
                  ],
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _enviarFormulario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Confirmar Reserva',
                      style: TextStyle(fontSize: 20, color: Colors.black), // Definindo a cor do texto aqui
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: TextField(
          key: ValueKey<String>(label),
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        value: null,
        onChanged: onChanged,
        items: items
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(value: value, onChanged: onChanged),
          Text(label),
        ],
      ),
    );
  }
}
