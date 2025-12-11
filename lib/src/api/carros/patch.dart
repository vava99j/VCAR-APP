import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> atualizarCarros(
  i, {
  String? ma,
  String? mo,
  String? p,
  String? c,
  String? com,
  String? f1,
  String? d,
  String? f2,
  String? f3,
  String? f4,
  String? f5,
}) async {
  final url = Uri.parse('https://vcar-servidor.onrender.com/api/cars/atualizar.php');

  try {
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": i,
        "marca": ma,
        "modelo": mo,
        "descricao": d,
        "preco": p,
        "contato": c,
        "comprou":com,
        "ft1": f1,
        "ft2": f2,
        "ft3": f3,
        "ft4": f4,
        "ft5": f5,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      final data = jsonDecode(response.body);
      print('Sucesso: $data');
    } else {
      print('Erro: status ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Falha ao fazer PATCH: $e');
  }
}
