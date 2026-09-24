import 'package:flutter/material.dart';

class SegundaTela extends StatelessWidget {
  const SegundaTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Voltar'),
        ),
      ),
    );
  }
}
