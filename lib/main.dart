import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
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
  String horario = '';
  int id = 0;
  String foto = '';
  /*int _counterPouza = 0;*/
  int _counter = 0;

  void _horario(i) {
    setState(() {
      horario = i;
    });
  }

  void _id(i) {
    setState(() {
      id = i;
    });
  }

  void _foto(i) {
    setState(() {
      foto = i;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _desincrementCounter() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
    }
  }

  Future<void> buscarDados() async {
    final url = Uri.parse(
      'https://servidor-632w.onrender.com/plantas/${userId}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final item = data[_counter];

        String horarios = item['horarios'];
        String foto = item['foto_url'];
        int id = item['id'];
        print('Sucesso: $data');

        _horario(horarios);
        _id(id);
        _foto(foto);
      } else {
        print('Erro: status ${response.statusCode}');
      }
    } catch (e) {
      print('Falha ao fazer GET: $e');
    }
    ;
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
          children: <Widget>[
            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  ElevatedButton(
                  onPressed: _desincrementCounter,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 10),
                const Text('Pouza deu '),
                Text(
                  '$_counterPouza',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const Text(' vezes pro Vava'),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Icon(Icons.add),
                ),
              ],
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ElevatedButton(
                  onPressed: () {
                    _desincrementCounter();
                    buscarDados();
                  },
                  child: const Icon(Icons.arrow_left),
                ),
              ],
            ),
            const SizedBox(height: 20),

      Container(
  padding: const EdgeInsets.all(20),
  margin: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 10),

      Text(
        horario,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),

      if (foto != '')
        Image.network(foto, width: 200, height: 200),
    ],
  ),
),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    buscarDados();
                    _incrementCounter();
                  },
                  child: const Icon(Icons.arrow_right),
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
          FloatingActionButton(
            heroTag: "Novo",
            onPressed: () {
              print('sera novo');
            },
            child: const Icon(Icons.add),
          ),

          const SizedBox(width: 20),

          FloatingActionButton(
            heroTag: "Edit",
            onPressed: () {
              print('sera edit');
            },
            child: const Icon(Icons.edit),
          ),

          const SizedBox(width: 20),

          FloatingActionButton(
            heroTag: "Excluir",
            onPressed: () {
              print('sera excluir');
            },
            child: const Icon(Icons.delete_forever),
          ),
        ],
      ),
    );
  }
}
