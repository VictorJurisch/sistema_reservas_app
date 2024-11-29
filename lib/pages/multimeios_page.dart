import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      home: const MultimeiosPage(),  // Usando a página MultimeiosPage
    );
  }
}

class MultimeiosPage extends StatefulWidget {
  const MultimeiosPage({super.key});

  @override
  State<MultimeiosPage> createState() => _MultimeiosPageState();
}

class _MultimeiosPageState extends State<MultimeiosPage> {
  final _formKey = GlobalKey<FormState>();
  String? nome, setor, publico, contato, descricao;
  String? horaInicio, horaFinal, data;
  bool aAinf = false, aAscom = false, cafeAgua = false, coffeBreak = false;

  // Controladores para mostrar as opções de público
  void atualizarOpcoes(String value) {
    setState(() {
      publico = value;
    });
  }

  // Função para buscar as reservas
  Future<List<dynamic>> fetchReservas() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/projetos/api_php/api/get_reservas.php'));

    if (response.statusCode == 200) {
      try {
        // Tente parsear a resposta como JSON
        final List<dynamic> reservas = json.decode(response.body);
        return reservas;
      } catch (e) {
        print('Erro ao tentar decodificar o JSON: $e');
        print('Resposta do servidor: ${response.body}');
        throw Exception('Erro ao processar dados');
      }
    } else {
      print('Erro: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');
      throw Exception('Falha ao carregar as reservas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Sala Multimeios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Formulário de Reserva',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Campo de Nome
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => nome = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de Data
              TextFormField(
                decoration: const InputDecoration(labelText: 'Data'),
                keyboardType: TextInputType.datetime,
                onSaved: (value) => data = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma data';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de Hora de Início
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hora de Início'),
                keyboardType: TextInputType.datetime,
                onSaved: (value) => horaInicio = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a hora de início';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de Hora Final
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hora Final'),
                keyboardType: TextInputType.datetime,
                onSaved: (value) => horaFinal = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a hora final';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de Setor
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Setor'),
                value: setor,
                onChanged: (value) => setState(() {
                  setor = value;
                }),
                items: <String>[
                  'AINF', 'APC', 'ASJU', 'ASPRE', 'AUDI', 'CTSM',
                  'DPCF', 'DPNT', 'DPPA', 'DPRH', 'DPTD', 'DREX', 'TESTE'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um setor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo Público
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Público'),
                value: publico,
                onChanged: (value) {
                  atualizarOpcoes(value!);
                },
                items: const [
                  DropdownMenuItem(value: 'interno', child: Text('Interno')),
                  DropdownMenuItem(value: 'externo', child: Text('Externo'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma opção';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campos de Opcionais (exibidos com base na opção de público)
              if (publico == 'interno') ...[
                CheckboxListTile(
                  title: const Text('Apoio da AINF'),
                  value: aAinf,
                  onChanged: (bool? value) {
                    setState(() {
                      aAinf = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Apoio da ASCOM'),
                  value: aAscom,
                  onChanged: (bool? value) {
                    setState(() {
                      aAscom = value!;
                    });
                  },
                ),
              ] else if (publico == 'externo') ...[
                CheckboxListTile(
                  title: const Text('Apenas Café e água'),
                  value: cafeAgua,
                  onChanged: (bool? value) {
                    setState(() {
                      cafeAgua = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Coffe Break'),
                  value: coffeBreak,
                  onChanged: (bool? value) {
                    setState(() {
                      coffeBreak = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Apoio da AINF'),
                  value: aAinf,
                  onChanged: (bool? value) {
                    setState(() {
                      aAinf = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Apoio da ASCOM'),
                  value: aAscom,
                  onChanged: (bool? value) {
                    setState(() {
                      aAscom = value!;
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              
              // Campo de Contato (email)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email de Contato'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => contato = value,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de Descrição
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => descricao = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Botão de Enviar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Submeter a reserva
                    // ...
                  }
                },
                child: const Text('Submeter Reserva'),
              ),
              const SizedBox(height: 20),
              
              // Exibição de Reservas
              FutureBuilder<List<dynamic>>(
                future: fetchReservas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhuma reserva encontrada'));
                  }
                  
                  final reservas = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: reservas.length,
                    itemBuilder: (context, index) {
                      final reserva = reservas[index];
                      return ListTile(
                        title: Text(reserva['nome'] ?? 'Nome não disponível'),
                        subtitle: Text('Data: ${reserva['data']}'),
                        trailing: Text(reserva['status']),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
