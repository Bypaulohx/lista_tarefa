import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 28, 191, 197),
      ),
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  final List<String> tarefas = [];

  int? tarefaSelecionada;

  void adicionarTarefa() {
    final tarefa = _controller.text.trim();

    if (tarefa.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Não é possível adicionar uma tarefa vazia.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    }

    setState(() {
      tarefas.add(tarefa);
    });

    _controller.clear();
  }

  void removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);

      if (tarefaSelecionada == index) {
        tarefaSelecionada = null;
      } else if (tarefaSelecionada != null && index < tarefaSelecionada!) {
        tarefaSelecionada = tarefaSelecionada! - 1;
      }
    });
  }

  void editarTarefa(int index) {
    final TextEditingController editarController = TextEditingController(
      text: tarefas[index],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarefa'),
          content: TextField(
            controller: editarController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Digite a nova tarefa',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final novaTarefa = editarController.text.trim();

                if (novaTarefa.isEmpty) {
                  return;
                }

                setState(() {
                  tarefas[index] = novaTarefa;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void abrirTarefa() {
    if (tarefaSelecionada == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetalhesTarefa(tarefa: tarefas[tarefaSelecionada!]),
      ),
    );
  }

  void abrirSobre() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SobrePage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite uma tarefa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8.0),

                ElevatedButton(
                  onPressed: adicionarTarefa,
                  child: const Text('Adicionar'),
                ),
              ],
            ),

            const SizedBox(height: 16.0),

            Expanded(
              child: tarefas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma tarefa adicionada.',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tarefas.length,
                      itemBuilder: (context, index) {
                        final bool selecionada = tarefaSelecionada == index;

                        return Card(
                          color: selecionada
                              ? const Color.fromARGB(
                                  66,
                                  255,
                                  255,
                                  255,
                                ).withOpacity(0.8)
                              : Colors.white,
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                if (tarefaSelecionada == index) {
                                  tarefaSelecionada = null;
                                } else {
                                  tarefaSelecionada = index;
                                }
                              });
                            },

                            title: Text(
                              tarefas[index],
                              style: TextStyle(
                                fontWeight: selecionada
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Editar
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    editarTarefa(index);
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    removerTarefa(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            if (tarefaSelecionada != null) ...[
              const SizedBox(height: 8),

              Center(
                child: ElevatedButton(
                  onPressed: abrirTarefa,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                  ),
                  child: const Text('Abrir', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 300),
            ],

            Center(
              child: TextButton(
                onPressed: abrirSobre,
                child: const Text(
                  'Sobre',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetalhesTarefa extends StatelessWidget {
  final String tarefa;

  const DetalhesTarefa({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarefa selecionada',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tarefa,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}