import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vcarros/financeiro.dart';
import 'package:vcarros/src/api/carros/delete.dart';
import 'package:vcarros/src/api/carros/get.dart';
import 'package:vcarros/src/api/carros/patch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcarros/src/api/carros/post.dart';

import 'package:vcarros/src/api/financeiro/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vcarros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 1, 2, 68),
        ),
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userId = '1';
  String marca = "";
  String modelo = "";
  String descricao = "";
  String contato = "";
  String preco = "";
  String id = '';
  String foto = '';
  String comprou = '';
  String vendeu = '';
  int _counter = 0;
  int _tamanho = 0;
  List carros = [];
  List<String> imagens = [];
  List ft = ["ft1", "ft2", "ft3", "ft4", "ft5"];

  void _tam(t) {
    setState(() {
      _tamanho = t - 1;
    });
  }

  void _incrementCounter() {
    setState(() {
      if (_counter == _tamanho) {
        _counter = 0;
      } else {
        _counter++;
      }
    });
    print(_counter);
  }

  void _desIncrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      } else {
        _counter = _tamanho;
      }
    });
    print(_counter);
  }

  Future<String> converterBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> escolherImagens() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? result = await picker.pickMultiImage();

    if (result == null || result.isEmpty) return;

    imagens.clear();

    for (var img in result) {
      final base64String = await converterBase64(img);
      imagens.add(base64String);
    }
  }

  Future<void> modalEeN(String t, {int? i}) async {
    final TextEditingController marcaController = TextEditingController();
    final TextEditingController modeloController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();
    final TextEditingController precoController = TextEditingController();
    final TextEditingController contatoController = TextEditingController();
    final TextEditingController comprouController = TextEditingController();
    if (i != null) {
      marcaController.text = carros[_counter]['marca'];
      modeloController.text = carros[_counter]['modelo'];
      descricaoController.text = carros[_counter]['descricao'];
      precoController.text = carros[_counter]['preco'];
      contatoController.text = carros[_counter]['contato'];
      comprouController.text = carros[_counter]['comprou'];
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: marcaController,
                      decoration: const InputDecoration(labelText: "Marca"),
                    ),
                    TextField(
                      controller: modeloController,
                      decoration: const InputDecoration(labelText: "Modelo"),
                    ),
                    TextField(
                      controller: descricaoController,
                      decoration: const InputDecoration(labelText: "Descrição"),
                    ),
                    TextField(
                      controller: precoController,
                      decoration: const InputDecoration(labelText: "Preço"),
                    ),
                    TextField(
                      controller: contatoController,
                      decoration: const InputDecoration(labelText: "Contato"),
                    ),
                    TextField(
                      controller: comprouController,
                      decoration: const InputDecoration(labelText: "Gastou"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: escolherImagens,
                      child: Text("Selecionar imagens"),
                    ),

                    const SizedBox(height: 20),
                    if (i != null)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          atualizarCarros(
                            id,
                            ma: marcaController.text,
                            mo: modeloController.text,
                            p: precoController.text,
                            c: contatoController.text,
                            d: descricaoController.text,
                            f1: imagens.isNotEmpty ? imagens[0] : "",
                            f2: imagens.length > 1 ? imagens[1] : "",
                            f3: imagens.length > 2 ? imagens[2] : "",
                            f4: imagens.length > 3 ? imagens[3] : "",
                            f5: imagens.length > 4 ? imagens[4] : "",
                          );
                          carregar();
                          Navigator.pop(context);
                        },
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          criarCarros(
                            marcaController.text,
                            modeloController.text,
                            descricaoController.text,
                            precoController.text,
                            contatoController.text,
                            comprouController.text,
                            imagens.isNotEmpty ? imagens[0] : "",
                            imagens.length > 1 ? imagens[1] : "",
                            imagens.length > 2 ? imagens[2] : "",
                            imagens.length > 3 ? imagens[3] : "",
                            imagens.length > 4 ? imagens[4] : "",
                          );
                          carregar();
                          Navigator.pop(context);
                        },
                      ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> modalD(i) async {
    final TextEditingController vendeuController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            height: 220,
            padding: const EdgeInsets.all(20),

            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "APAGAR MESMO?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "verifique o quanto gastou no editar",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "é importante para o financeiro depois.",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        TextField(
                          controller: vendeuController,
                          decoration: const InputDecoration(
                            labelText: "Vendeu",
                          ),
                        ),
                        SizedBox(height: 20),

                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            criarFinanceiro(
                              carros[_counter]["marca"],
                              carros[_counter]["modelo"],
                              carros[_counter]["comprou"],
                              vendeuController.text,
                            );
                            excluirDados(carros[_counter]["id"]);
                            carregar();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> carregar() async {
    final resultado = await buscarCarros();
    setState(() {
      carros = resultado;
    });
    print(' carros.lenght ${carros.length}');
    _tam(carros.length);
  }

  Image imagemBase64(String base64String) {
    try {
      final decodedBytes = base64Decode(base64String);
      return Image.memory(
        decodedBytes,
        width: 250,
        height: 200,
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Image.asset("assets/erro.png", width: 250, height: 200);
    }
  }

  @override
  void initState() {
    super.initState();
    carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _desIncrementCounter,
                  icon: Icon(Icons.arrow_left),
                ),
              ],
            ),
            SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 4,
                    children: [
                      Text('Carro: ${carros[_counter]['marca'].toString()}'),
                      Text(carros[_counter]['modelo'].toString()),
                    ],
                  ),

                  Text(' gastou: ${carros[_counter]['comprou'].toString()}'),
                  Text(
                    'descrição: ${carros[_counter]['descricao'].toString()}',
                  ),
                  carros[_counter][ft[0]] != null &&
                          carros[_counter][ft[0]] != ""
                      ? imagemBase64(carros[_counter][ft[0]])
                      : Text("Sem foto"),

                  Text(carros[_counter]['preco'].toString()),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _incrementCounter,
                  icon: Icon(Icons.arrow_right),
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SecPage()),
              );

              carregar();
            },
            icon: Icon(Icons.attach_money),
          ),

          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              modalEeN("Novo");
            },
            icon: Icon(Icons.add),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              modalEeN("Editar", i: carros[_counter]["id"]);
            },
            icon: Icon(Icons.edit),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              modalD(carros[_counter]["id"]);
            },
            icon: const Icon(Icons.delete_forever),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
