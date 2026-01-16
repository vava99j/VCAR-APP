import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vcarros/financeiro.dart';
import 'package:vcarros/src/api/carros/delete.dart';
import 'package:vcarros/src/api/carros/get.dart';
import 'package:vcarros/src/api/carros/patch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcarros/src/api/carros/post.dart';

import 'package:vcarros/src/api/financeiro/post.dart';
import 'package:vcarros/src/api/fipex/fipex_service.dart';

import 'novo_carro.dart';

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
  int _counterf = 0;
  int _tamanho = 0;
  List carros = [];
  Map? marcaSelecionada;
  List marcas = [];
  Map? modeloSelecionado;
  List modelos = [];
  List<String> imagens = [];
  List ft = ["ft1", "ft2", "ft3", "ft4", "ft5"];

  void _tam(t) {
    setState(() {
      _tamanho = t - 1;
    });
  }

  void _incrementCounterf() {
    setState(() {
      if (_counterf + 1 >= ft.length) {
        _counterf = 0;
        return;
      }

      final proxima = carros[_counter][ft[_counterf + 1]];

      if (proxima != null && proxima.toString().isNotEmpty) {
        _counterf++;
      } else {
        _counterf = 0;
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter = (_counter == _tamanho) ? 0 : _counter + 1;
      _counterf = 0;
    });
  }

  void _desIncrementCounter() {
    setState(() {
      _counter = (_counter > 0) ? _counter - 1 : _tamanho;
      _counterf = 0;
    });
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

  Future<void> modalEeN(String t, {int? i}) async {
    final TextEditingController marcaController = TextEditingController();
    final TextEditingController modeloController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();
    final TextEditingController precoController = TextEditingController();
    final TextEditingController contatoController = TextEditingController();
    final TextEditingController comprouController = TextEditingController();

    List<String> imagensModal = [];

    if (i != null) {
      final c = carros[_counter];
      marcaController.text = c['marca'] ?? "";
      modeloController.text = c['modelo'] ?? "";
      descricaoController.text = c['descricao'] ?? "";
      precoController.text = c['preco'] ?? "";
      contatoController.text = c['contato'] ?? "";
      comprouController.text = c['comprou'] ?? "";

      for (var f in ft) {
        if (c[f] != null && c[f].toString().isNotEmpty) {
          imagensModal.add(c[f]);
        }
      }
    } else {
      contatoController.text = '11 981623494';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 10),
                      TextField(
                        controller: marcaController,
                        decoration: const InputDecoration(labelText: "Modelo"),
                      ),
                      TextField(
                        controller: modeloController,
                        decoration: const InputDecoration(labelText: "Marca"),
                      ),
                      TextField(
                        controller: descricaoController,
                        decoration: const InputDecoration(
                          labelText: "Descrição",
                        ),
                      ),
                      TextField(
                        controller: precoController,
                        decoration: const InputDecoration(
                          labelText: "Preço Venda (R\$)",
                        ),
                      ),
                      TextField(
                        controller: comprouController,
                        decoration: const InputDecoration(
                          labelText: "Preço Compra (R\$)",
                        ),
                      ),
                      TextField(
                        controller: contatoController,
                        decoration: const InputDecoration(labelText: "Contato"),
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
                            setModalState(() {
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
                            scrollDirection: Axis.horizontal,
                            itemCount: imagensModal.length,
                            itemBuilder: (ctx, idx) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Image.memory(
                                base64Decode(imagensModal[idx]),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (marcaController.text.isEmpty ||
                                  modeloController.text.isEmpty) {
                                return;
                              }

                              if (i == null) {
                                await criarCarros(
                                  marcaController.text,
                                  modeloController.text,
                                  descricaoController.text,
                                  precoController.text,
                                  contatoController.text,
                                  comprouController.text,
                                  imagensModal.isNotEmpty
                                      ? imagensModal[0]
                                      : "",
                                  imagensModal.length > 1
                                      ? imagensModal[1]
                                      : "",
                                  imagensModal.length > 2
                                      ? imagensModal[2]
                                      : "",
                                  imagensModal.length > 3
                                      ? imagensModal[3]
                                      : "",
                                  imagensModal.length > 4
                                      ? imagensModal[4]
                                      : "",
                                );
                              } else {
                                await atualizarCarros(
                                  carros[_counter]['id'],
                                  ma: marcaController.text,
                                  mo: modeloController.text,
                                  d: descricaoController.text,
                                  p: precoController.text,
                                  c: contatoController.text,
                                  com: comprouController.text,
                                  f1: imagensModal.isNotEmpty
                                      ? imagensModal[0]
                                      : "",
                                  f2: imagensModal.length > 1
                                      ? imagensModal[1]
                                      : "",
                                  f3: imagensModal.length > 2
                                      ? imagensModal[2]
                                      : "",
                                  f4: imagensModal.length > 3
                                      ? imagensModal[3]
                                      : "",
                                  f5: imagensModal.length > 4
                                      ? imagensModal[4]
                                      : "",
                                );
                              }
                              await carregar();
                              Navigator.pop(context);
                            },
                            child: const Text("Salvar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> modalD(i) async {
    final TextEditingController vendeuController = TextEditingController();
    final TextEditingController gastouController = TextEditingController();
    gastouController.text = carros[_counter]["comprou"];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            height: 250,
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
                          "Apagar?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),

                        TextField(
                          controller: gastouController,
                          decoration: const InputDecoration(
                            labelText: "Gastou(R\$)",
                          ),
                        ),
                        TextField(
                          controller: vendeuController,
                          decoration: const InputDecoration(
                            labelText: "Vendeu(R\$)",
                          ),
                        ),
                        SizedBox(height: 20),

                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await criarFinanceiro(
                              carros[_counter]["marca"],
                              carros[_counter]["modelo"],
                              gastouController.text,
                              vendeuController.text,
                            );

                            await excluirDados(carros[_counter]["id"]);
                            await carregar();

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
    final resultadoMarcas = await buscarMarca();
    setState(() {
      marcas = resultadoMarcas;
    });
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
    if (carros.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(
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
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NeEcarro()),
                  );
                  carregar();
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (carros.isEmpty)
              IconButton(
                onPressed: carregar,
                icon: Icon(Icons.replay_outlined),
              ),
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
                  Text('Carro: ${carros[_counter]['marca'].toString()}'),
                  Text(carros[_counter]['modelo'].toString()),
                  Text(
                    'descrição: ${carros[_counter]['descricao'].toString()}',
                  ),
                  Text('Contato: ${carros[_counter]['contato'].toString()}'),

                  Dismissible(
                    key: ValueKey(carros[_counter]['id']),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _incrementCounterf();
                      }
                      return false;
                    },
                    background:
                        (_counterf + 1 < ft.length &&
                            carros[_counter][ft[_counterf + 1]] != null &&
                            carros[_counter][ft[_counterf + 1]]
                                .toString()
                                .isNotEmpty)
                        ? imagemBase64(carros[_counter][ft[_counterf + 1]])
                        : const Center(child: Icon(Icons.replay)),

                    child: Card(
                      child: Column(
                        children: [
                          carros[_counter][ft[_counterf]] != null &&
                                  carros[_counter][ft[_counterf]] != ""
                              ? imagemBase64(carros[_counter][ft[_counterf]])
                              : Text("Sem foto"),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'A venda por: BRL${carros[_counter]['preco'].toString()}',
                  ),
                  Text('Gastou: BRL${carros[_counter]['comprou'].toString()}'),
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
