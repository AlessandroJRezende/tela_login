import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Aluno'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disciplinas Matriculadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: Text('Programação Orientada a Objetos'),
                      subtitle: Text('Prof. Ana Maria'),
                      trailing: Text('Sala 101'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Estrutura de Dados'),
                      subtitle: Text('Prof. João Souza'),
                      trailing: Text('Sala 102'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
