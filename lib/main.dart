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
  int _counterPouza = 0;
  int _counter = 0;

  void _horario(msg) {
    setState(() {
      horario = msg;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counterPouza++;
    });
  }

  void _desincrementCounter() {
    setState(() {
      _counterPouza--;
    });
  }

  void _eduIncrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _eduDesincrementCounter() {
    setState(() {
      _counter--;
    });
  }

  Future<void> buscarDados() async {
    final url = Uri.parse('https://servidor-632w.onrender.com/plantas/${userId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final item = data[_counter];

        String horarios = item['horarios'];
        print('Sucesso: $data');

        _horario(horarios);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
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
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _eduDesincrementCounter,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 10),

                const Text('Pegar planta '),

                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const Text('do user Vava'),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: _eduIncrementCounter,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  horario,
                  style: Theme.of(context).textTheme.headlineMedium,
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
            heroTag: "btn1",
            onPressed: buscarDados,
            child: const Icon(Icons.add),
          ),

          const SizedBox(width: 20), // espaço entre eles

          FloatingActionButton(
            heroTag: "btn2",
            onPressed: _desincrementCounter,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
