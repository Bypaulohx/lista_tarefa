import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.yellow,
      ),
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Ainsitezinho')
        ),
      ),
    );
  }
}
