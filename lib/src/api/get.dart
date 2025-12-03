import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> buscarDados() async {
  final url = Uri.parse('https://servidor-632w.onrender.com/plantas/2');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Sucesso: $data');
    } else {
      print('Erro: status ${response.statusCode}');
    }
  } catch (e) {
    print('Falha ao fazer GET: $e');
  }
}

void main(List<String> args) {
  buscarDados();
}
