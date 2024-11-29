import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> getReservas() async {
  final response = await http.get(Uri.parse('http://10.0.2.2/projetos/api_php/api/'));


  if (response.statusCode == 200) {
    // Processar a resposta se for bem-sucedida
    print('Dados recebidos: ${response.body}');
  } else {
    // Se a resposta não for bem-sucedida
    throw Exception('Falha ao carregar dados');
  }
}
