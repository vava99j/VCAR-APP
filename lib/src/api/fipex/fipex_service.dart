import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<dynamic>> buscarMarca() async {
  final url = Uri.parse(
    "https://brasilapi.com.br/api/fipe/marcas/v1/carros",
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erro ao carregar');
  }
}

Future<List<dynamic>> buscarModelo(marca) async {
  final url = Uri.parse(
    "https://brasilapi.com.br/api/fipe/veiculos/v1/carros/$marca",
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erro ao carregar');
  }
}


Future<List<dynamic>> buscarAno(cod) async {
  final url = Uri.parse("https://brasilapi.com.br/api/fipe/preco/v1/$cod");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erro ao carregar');
  }
}

/*
 void main() async {
  final carros = await buscarModelo(21);
  var modelos = carros.map((carro) => carro["modelo"]).toList();
  print(modelos);
}
*/

void main() async {
  final marcas = await buscarMarca();
  var nomes = marcas.map((marca) => marca["nome"]).toList();
  print(marcas);
  final modelo = await buscarAno("005340-6");
  var exato = modelo.map((carro) => carro["modelo"]).toList();
 //  print(exato[1]);
 // print(modelo);
}
