import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfessorDashboard extends StatefulWidget {
  const ProfessorDashboard({super.key});

  @override
  State<ProfessorDashboard> createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> reservas = [];

  @override
  void initState() {
    super.initState();
    _carregarReservasHoje();
  }

  Future<void> _carregarReservasHoje() async {
    //final hoje = DateTime.now();
    //final dataFormatada =
    //    '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';

    final response = await supabase
        .from('reservas')
        .select('hora_inicio, hora_fim, data, disciplinas(nome), usuarios(nome), salas(nome)');
        //.eq('data', dataFormatada);

    setState(() {
      reservas = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _reservarSala(BuildContext contextRoot) async {
    final professores = await supabase
        .from('usuarios')
        .select('id, nome')
        .eq('role', 'professor');

    final disciplinas = await supabase.from('disciplinas').select('id, nome');
    final salas = await supabase.from('salas').select('id, nome');

    String? professorId;
    String? disciplinaId;
    String? salaId;
    TimeOfDay? horaInicio;
    TimeOfDay? horaFim;
    DateTime? dataSelecionada;
    String? errorMessage;
    bool isLoading = false;

    showDialog(
      context: contextRoot,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickHoraInicio() async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) setState(() => horaInicio = time);
            }

            Future<void> pickHoraFim() async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) setState(() => horaFim = time);
            }

            Future<void> pickData() async {
              final data = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );
              if (data != null) setState(() => dataSelecionada = data);
            }

            return AlertDialog(
              title: const Text('Reservar Sala'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: professorId,
                      items: professores
                          .map<DropdownMenuItem<String>>(
                            (prof) => DropdownMenuItem<String>(
                              value: prof['id'].toString(),
                              child: Text(prof['nome']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => professorId = value),
                      decoration: const InputDecoration(labelText: 'Professor'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: disciplinaId,
                      items: disciplinas
                          .map<DropdownMenuItem<String>>(
                            (disc) => DropdownMenuItem<String>(
                              value: disc['id'].toString(),
                              child: Text(disc['nome']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => disciplinaId = value),
                      decoration: const InputDecoration(labelText: 'Disciplina'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: salaId,
                      items: salas
                          .map<DropdownMenuItem<String>>(
                            (sala) => DropdownMenuItem<String>(
                              value: sala['id'].toString(),
                              child: Text(sala['nome']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => salaId = value),
                      decoration: const InputDecoration(labelText: 'Sala'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: pickData,
                      child: Text(
                        dataSelecionada == null
                            ? 'Selecionar Data'
                            : 'Data: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: pickHoraInicio,
                            child: Text(
                              horaInicio == null
                                  ? 'Hora Início'
                                  : 'Início: ${horaInicio!.format(context)}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: pickHoraFim,
                            child: Text(
                              horaFim == null
                                  ? 'Hora Fim'
                                  : 'Fim: ${horaFim!.format(context)}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (professorId == null ||
                              disciplinaId == null ||
                              salaId == null ||
                              horaInicio == null ||
                              horaFim == null ||
                              dataSelecionada == null) {
                            setState(() {
                              errorMessage = 'Preencha todos os campos antes de reservar.';
                            });
                            return;
                          }

                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          final dataFormatada =
                              '${dataSelecionada!.year}-${dataSelecionada!.month.toString().padLeft(2, '0')}-${dataSelecionada!.day.toString().padLeft(2, '0')}';

                          try {
                            await supabase.from('reservas').insert({
                              'professor_id': professorId,
                              'disciplina_id': disciplinaId,
                              'room_id': salaId,
                              'data': dataFormatada,
                              'hora_inicio': horaInicio!.format(context),
                              'hora_fim': horaFim!.format(context),
                            });

                            if (contextRoot.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(contextRoot).showSnackBar(
                                const SnackBar(content: Text('Reserva realizada com sucesso')),
                              );
                              _carregarReservasHoje();
                            }
                          } catch (e) {
                            setState(() {
                              errorMessage = 'Erro ao reservar a sala. Tente novamente.';
                              debugPrint('Erro Supabase: $e');
                            });
                          } finally {
                            setState(() => isLoading = false);
                          }
                        },
                        child: const Text('Reservar'),
                      ),
              ],
            );
          },
        );
      },
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
              child: reservas.isEmpty
                  ? const Center(child: Text('Nenhuma aula hoje.'))
                  : ListView.builder(
                      itemCount: reservas.length,
                      itemBuilder: (context, index) {
                        final reserva = reservas[index];
                        return ClassCard(
                          data: reserva['data'].toString(),
                          disciplina: reserva['disciplinas']['nome'],
                          professor: reserva['usuarios']['nome'],
                          horario: '${reserva['hora_inicio']} - ${reserva['hora_fim']}',
                          sala: reserva['salas']['nome'],
                        );
                      },
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
  final String data;

  const ClassCard({
    super.key,
    required this.data,
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
            Text(
              disciplina,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Professor: $professor'),
            Text('Data: $data'),
            Text('Horário: $horario'),
            Text('Sala: $sala'),
          ],
        ),
      ),
    );
  }
}
