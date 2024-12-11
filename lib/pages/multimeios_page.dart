import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'horarios_reservas_multimeios.dart'; // Altere o caminho conforme necessário

final _horaMask = MaskTextInputFormatter(mask: '##:##', filter: { '##': RegExp(r'[0-9]') });

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
  String? _publico = 'Selecione um Público'; // Valor inicial definido como "Selecione um Público"
  bool _aAinfInterno = false;
  bool _aAscomInterno = false;
  bool _aAinfExterno = false;
  bool _aAscomExterno = false;
  bool _cafeAguaExterno = false;
  bool _coffeBreakExterno = false;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedDateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
  
  // Verifica se a data selecionada é anterior à data atual
  if (selectedDateOnly.isBefore(today)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Não é possível reservar para datas passadas!')) ,
    );
    return;
  }

  setState(() {
    _selectedDate = selectedDay;
    _focusedDate = focusedDay;
  });

  // Passando a data diretamente para a página de horários
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HorariosReservasMultimeiosPage(selectedDate: selectedDay),
    ),
  );
}


  Future<bool> _verificarDisponibilidade(String data, String horaInicio, String horaFinal) async {
    const String checkUrl = 'http://10.0.2.2/projetos/api_php/api/verificar_disponibilidade.php';

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
            SnackBar(content: Text('Horário indisponível: ${checkData['motivo']}')) ,
          );
          return false;
        }
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao verificar disponibilidade.')) ,
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor: $e')) ,
      );
      return false;
    }
  }

  Future<void> _enviarFormulario() async {
    if (_nomeController.text.isEmpty ||
        _horaInicioController.text.isEmpty ||
        _horaFinalController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _setor == null ||
        _publico == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos obrigatórios devem ser preenchidos!')) ,
      );
      return;
    }

    String eventDateFormatted = DateFormat("yyyy-MM-dd").format(_selectedDate);

    bool isAvailable = await _verificarDisponibilidade(
      eventDateFormatted,
      _horaInicioController.text,
      _horaFinalController.text,
    );

    if (!isAvailable) {
      return;
    }

    const String saveUrl = 'http://10.0.2.2/projetos/api_php/api/salvar_reserva.php';

    final Map<String, String> dados = {
      'nome': _nomeController.text,
      'data': eventDateFormatted,
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
      'sala': 'Multimeios',
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
            const SnackBar(content: Text('Reserva salva com sucesso!')) ,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${responseData['message']}')) ,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao conectar ao servidor: ${response.statusCode}')) ,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar reserva: $e')) ,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva Multimeios'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/reserva_sala_logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Text(
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
              const SizedBox(height: 20),
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
              _buildTextField(_nomeController, 'Nome'),
              _buildTextField(_emailController, 'Email para Contato'),
              _buildTextField(_descricaoController, 'Descrição'),
              _buildDropdown('Setor', ['AINF', 'Ascom', 'Outros'], (value) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCheckbox('Apoio AINF', _aAinfInterno, (value) {
                      setState(() {
                        _aAinfInterno = value!;
                      });
                    }),
                    _buildCheckbox('Apoio Ascom', _aAscomInterno, (value) {
                      setState(() {
                        _aAscomInterno = value!;
                      });
                    }),
                  ],
                ),
              ] else if (_publico == 'Externo') ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildCheckbox('Café e Água', _cafeAguaExterno, (value) {
                        setState(() {
                          _cafeAguaExterno = value!;
                        });
                      }),
                    ),
                    Expanded(
                      child: _buildCheckbox('Coffe Break', _coffeBreakExterno, (value) {
                        setState(() {
                          _coffeBreakExterno = value!;
                        });
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildCheckbox('Apoio AINF', _aAinfInterno, (value) {
                        setState(() {
                          _aAinfInterno = value!;
                        });
                      }),
                    ),
                    Expanded(
                      child: _buildCheckbox('Apoio Ascom', _aAscomInterno, (value) {
                        setState(() {
                          _aAscomInterno = value!;
                        });
                      }),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _enviarFormulario,
                  child: const Text('Enviar Reserva'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, {
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.done}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
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
