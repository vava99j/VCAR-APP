import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> buscarFinanceiro() async {
  final url = Uri.parse(
'http://localhost:8000/financeiro',  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erro ao carregar');
  }
}


class FinanceiroTotal {
  final double vendas;
  final double gastos;
  final double liquido;

  FinanceiroTotal(this.vendas, this.gastos, this.liquido);
}

Future<FinanceiroTotal> buscarFinanceiroTotal() async {
  final url = Uri.parse(
    'https://vcar-servidor.onrender.com/api/financeiro/listarTotal.php',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final Map<String, dynamic> financeiroMap = decodedJson[0];
      final vendas = double.parse(financeiroMap['Total_Vendas'].toString());
      final gastos = double.parse(financeiroMap['Total_Compras'].toString());
      final liquido = double.parse(financeiroMap['Lucro_Liquido'].toString());

      return FinanceiroTotal(vendas, gastos, liquido);
    } else {
      throw Exception("Erro no servidor: ${response.statusCode}");
    }
  } catch (e) {
    print("Erro detalhado: $e");
    throw Exception(
      "Falha ao buscar dados (verifique a conexão ou o formato da API)",
    );
  }
}


void main() async {
  try {
    final f = await buscarFinanceiroTotal();

    print("Total de Vendas: ${f.vendas}");
    print("Total de Gastos: ${f.gastos}");
    print("Lucro Líquido: ${f.liquido}");
  } catch (e) {
    print(e);
  }
} 
