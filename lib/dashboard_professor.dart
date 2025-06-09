import 'package:flutter/material.dart';

class ProfessorDashboard extends StatelessWidget {
  const ProfessorDashboard({super.key});

  void _reservarSala(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reservar Sala'),
        content: const Text('Funcionalidade de reserva ainda não implementada.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Professor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () => _reservarSala(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minhas Aulas Hoje',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ClassCard(
                    disciplina: 'Banco de Dados',
                    professor: 'Prof. Carlos Lima',
                    horario: '13:00 - 14:40',
                    sala: 'Sala 202',
                  ),
                  ClassCard(
                    disciplina: 'Engenharia de Software',
                    professor: 'Prof. Carlos Lima',
                    horario: '15:00 - 16:40',
                    sala: 'Sala 204',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String disciplina;
  final String professor;
  final String horario;
  final String sala;

  const ClassCard({
    super.key,
    required this.disciplina,
    required this.professor,
    required this.horario,
    required this.sala,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(disciplina, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Professor: $professor'),
            Text('Horário: $horario'),
            Text('Sala: $sala'),
          ],
        ),
      ),
    );
  }
}
