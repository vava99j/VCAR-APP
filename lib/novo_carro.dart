import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:vcarros/src/api/carros/patch.dart';
import 'package:vcarros/src/api/carros/post.dart';
import 'package:vcarros/src/api/fipex/fipex_service.dart';
import 'dart:convert';

class NeEcarro extends StatefulWidget {
  final Map? carro;
  const NeEcarro({super.key, this.carro});

  @override
  State<NeEcarro> createState() => _NeEcarro();
}

class _NeEcarro extends State<NeEcarro> {
  Map? marcaSelecionada;
  List marcas = [];
  Map? modeloSelecionado;
  List modelos = [];
  Map? anos;
  List anoSelecionado = [];
  List<String> imagensModal = [];
  List<String> imagens = [];
  List ft = ["ft1", "ft2", "ft3", "ft4", "ft5"];

  @override
  void initState() {
    if (widget.carro != null) {
      final c = widget.carro!;
      anoController.text = c['ano'] ?? "";
      descricaoController.text = c['descricao'] ?? "";
      precoController.text = c['preco_venda'] ?? "";
      telefoneController.text = c['telefone'] ?? "";
      comprouController.text = c['preco_compra'] ?? "";

      for (var f in ft) {
        if (c[f] != null && c[f].toString().isNotEmpty) {
          imagensModal.add(c[f]);
        }
      }
    } else {
      telefoneController.text = '11 981623494';
    }
    super.initState();
    carregar();
  }

  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController comprouController = TextEditingController();
  final TextEditingController anoController = TextEditingController();

  Future<void> carregar() async {
    try {
      final resultadoMarcas = await buscarMarca();
      setState(() {
        marcas = resultadoMarcas;
      });
    } catch (e) {
      print("Erro ao carregar dados iniciais: $e");
    }
  }

  Future<void> carregarModelos(String marcaId) async {
    try {
      final resultadoModelos = await buscarModelo(marcaId);
      setState(() {
        modelos = resultadoModelos;
        modeloSelecionado = null;
      });
    } catch (e) {
      print("Erro ao carregar modelos: $e");
    }
  }

  Future<String> converterBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> escolherImagens() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> result = await picker.pickMultiImage();

    if (result.isEmpty) return;

    final List<String> novasImagens = [];

    for (var img in result) {
      final base64String = await converterBase64(img);
      novasImagens.add(base64String);
    }

    setState(() {
      imagens = novasImagens;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<dynamic>(
              alignment: AlignmentGeometry.center,
              value: marcaSelecionada,
              isExpanded: true,
              hint: const Text("Selecione a marca"),
              items: marcas.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Center(child: Text(item['nome'].toString())),
                );
              }).toList(),
              onChanged: (novoValor) {
                print(novoValor);
                setState(() {
                  marcaSelecionada = novoValor;
                  marcaController.text = novoValor['nome'].toString();
                });
                carregarModelos(novoValor['valor'].toString());
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<dynamic>(
              alignment: AlignmentGeometry.center,
              value: modeloSelecionado,
              isExpanded: true,
              hint: const Text("Selecione o modelo"),
              items: modelos.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Center(child: Text(item['modelo'].toString())),
                );
              }).toList(),
              onChanged: (novoValor) {
                setState(() {
                  modeloSelecionado = novoValor;
                  modeloController.text = novoValor['modelo'].toString();
                });
              },
            ),

            
            TextField(
              textAlign: TextAlign.center,
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: "Descrição",
                floatingLabelAlignment: FloatingLabelAlignment.center,
                alignLabelWithHint: true,
              ),
            ),

              TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: anoController,
              decoration: const InputDecoration(
                labelText: "Ano",
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
            ),

            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: comprouController,
              decoration: const InputDecoration(
                labelText: "Preço Gasto (R\$)",
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              controller: telefoneController,
              decoration: const InputDecoration(
                labelText: "Telefone",
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: precoController,
              decoration: const InputDecoration(
                labelText: "Preço Venda (R\$)",
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: Text(
                imagensModal.isEmpty
                    ? "Add Fotos"
                    : "Alterar Fotos (${imagensModal.length})",
              ),
              onPressed: () async {
                final picker = ImagePicker();
                final result = await picker.pickMultiImage();
                if (result.isNotEmpty) {
                  List<String> novas = [];
                  for (var img in result.take(5)) {
                    final bytes = await img.readAsBytes();
                    novas.add(base64Encode(bytes));
                  }
                  setState(() {
                    imagensModal = novas;
                  });
                }
              },
            ),

            if (imagensModal.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true, // isso q centraliza, inacredivel.
                  scrollDirection: Axis.horizontal,
                  itemCount: imagensModal.length,
                  itemBuilder: (ctx, idx) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(imagensModal[idx]),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (marcaController.text.isEmpty ||
                    modeloController.text.isEmpty) {
                  return;
                }
                try {
                  if (widget.carro == null) {
                    await criarCarros(
                      marcaController.text,
                      modeloController.text,
                      descricaoController.text,
                      anoController.text,
                      precoController.text,
                      telefoneController.text,
                      comprouController.text,
                      imagensModal.isNotEmpty ? imagensModal[0] : "",
                      imagensModal.length > 1 ? imagensModal[1] : "",
                      imagensModal.length > 2 ? imagensModal[2] : "",
                      imagensModal.length > 3 ? imagensModal[3] : "",
                      imagensModal.length > 4 ? imagensModal[4] : "",
                    );
                  } else {
                    print('${widget.carro!['id']}');
                    await atualizarCarros(
                      widget.carro!['id'],
                      ma: marcaController.text,
                      mo: modeloController.text,
                      d: descricaoController.text,
                      a: anoController.text,
                      p: precoController.text,
                      c: telefoneController.text,
                      com: comprouController.text,
                      f1: imagensModal.isNotEmpty ? imagensModal[0] : "",
                      f2: imagensModal.length > 1 ? imagensModal[1] : "",
                      f3: imagensModal.length > 2 ? imagensModal[2] : "",
                      f4: imagensModal.length > 3 ? imagensModal[3] : "",
                      f5: imagensModal.length > 4 ? imagensModal[4] : "",
                    );
                  }
                } catch (e) {
                  print(e);
                } finally {
                  Navigator.pop(context, true);
                }
              },

              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
