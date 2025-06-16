import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsultaPorRaPage extends StatefulWidget {
  const ConsultaPorRaPage({Key? key}) : super(key: key);

  @override
  State<ConsultaPorRaPage> createState() => _ConsultaPorRaPageState();
}

class _ConsultaPorRaPageState extends State<ConsultaPorRaPage> {
  final _raController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _disciplinas = [];

  Future<void> _buscarDisciplinasPorRA() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _disciplinas = [];
    });

    final ra = _raController.text.trim();

    if (ra.isEmpty) {
      setState(() {
        _errorMessage = 'Informe um RA válido';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await _supabase
          .from('ensalamento') // 👈 Nome da tabela
          .select('''
            disciplina,
            professor,
            sala,
            dia,
            horario
          ''')
          .eq('ra_aluno', ra); // 👈 Campo de filtro no banco

      setState(() {
        _disciplinas = response;
        if (_disciplinas.isEmpty) {
          _errorMessage = 'Nenhuma disciplina encontrada para este RA.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao buscar disciplinas.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCard(Map disciplina) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: ListTile(
        title: Text(disciplina['disciplina'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Professor: ${disciplina['professor'] ?? ''}'),
            Text('Sala: ${disciplina['sala'] ?? ''}'),
            Text('Dia: ${disciplina['dia'] ?? ''}'),
            Text('Horário: ${disciplina['horario'] ?? ''}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta por RA')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _raController,
              decoration: const InputDecoration(
                labelText: 'Digite seu RA',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _buscarDisciplinasPorRA,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Buscar Disciplinas'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: _disciplinas.length,
                itemBuilder: (context, index) =>
                    _buildCard(_disciplinas[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
