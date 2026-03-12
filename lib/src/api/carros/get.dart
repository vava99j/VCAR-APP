import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> buscarCarros() async {
  final url = Uri.parse(
    'http://localhost:8000/carros'
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erro ao carregar');
  }
}



