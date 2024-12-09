import 'package:http/http.dart' as http;
import 'dart:convert';

// Função para buscar as reservas
Future<List<dynamic>> getReservas() async {
  final response = await http.get(Uri.parse('http://10.0.2.2/projetos/api_php/api/'));

  if (response.statusCode == 200) {
    // Converter o corpo da resposta para uma lista de objetos JSON
    List<dynamic> reservas = json.decode(response.body);
    return reservas;
  } else {
    // Caso haja erro, lança uma exceção com a mensagem de erro
    throw Exception('Falha ao carregar dados. Status: ${response.statusCode}');
  }
}
