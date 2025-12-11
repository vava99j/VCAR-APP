import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> criarCarros(
  String marca,
  String modelo,
  String descricao,
  String preco,
  String contato,
  String comprou,
  String ft1,
  String ft2,
  String ft3,
  String ft4,
  String ft5,
) async {
  final url = Uri.parse(
    'https://vcar-servidor.onrender.com/api/cars/cadastrar.php',
  );

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "marca": marca,
        "modelo": modelo,
        "descricao": descricao,
        "preco": preco,
        "contato": contato,
        "comprou": comprou,
        "ft1": ft1,
        "ft2": ft2,
        "ft3": ft3,
        "ft4": ft4,
        "ft5": ft5,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Sucesso: $data');
    } else {
      print('Erro: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Falha: $e');
  }
}
