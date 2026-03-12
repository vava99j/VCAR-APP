import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> excluirDados(int id) async {
  final url = Uri.parse(
    'http://localhost:8000/carros'
  );

  try {
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"id": id.toString()}),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      final data = jsonDecode(response.body);
      print('Sucesso: $data');
    } else {
      print('Erro: status ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Falha ao fazer DELETE: $e');
  }
}

