import 'package:flutter/material.dart';
import 'package:vcarros/src/api/financeiro/get.dart';
import 'package:vcarros/src/api/fipex/fipex_service.dart';

class SecPage extends StatefulWidget {
  const SecPage({super.key});

  @override
  State<SecPage> createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  double vendast = 0.0;
  double gastost = 0.0;
  double liqt = 0.0;
  List carros = [];


  void _vendast(i) {
    setState(() {
      vendast = i;
    });
  }

  void _liqt(i) {
    setState(() {
      liqt = i;
    });
  }

  void _gastost(i) {
    setState(() {
      gastost = i;
    });
  }

  @override
  void initState() {
    super.initState();
    bft();
    carregar();
  }

  void bft() async {
    try {
      final f = await buscarFinanceiroTotal();
      _vendast(f.vendas);
      _gastost(f.gastos);
      _liqt(f.liquido);
    } catch (e) {
      print(e);
    }
  }

  Future<void> carregar() async {
    final resultado = await buscarFinanceiro();
    setState(() {
      carros = resultado;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Financeiro")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total: vendas: $vendast | gastos: $gastost | Liquido: $liqt',
                ),
                Icon(liqt > 0 ? Icons.check : Icons.close),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                for (var item in carros)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${item['marca']} "),
                        Text("${item['modelo']} "),
                        Text("Venda: ${item['vendeu']} "),
                        Text("Compra: ${item['comprou']}"),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}