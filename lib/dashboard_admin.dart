import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _adicionarUsuario(BuildContext context) {
    final scaffoldContext = context; // Salva o contexto do Scaffold
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final tipoController = TextEditingController();
    final senhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String? errorMessage;
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Novo Usuário'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: tipoController,
                      decoration: const InputDecoration(
                        labelText: 'Tipo (aluno, professor, admin)',
                      ),
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
                    ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CircularProgressIndicator(),
                    )
                    : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });

                        final nome = nomeController.text.trim();
                        final email = emailController.text.trim();
                        final senha = senhaController.text.trim();
                        final role = tipoController.text.trim().toLowerCase();

                        // Validação simples
                        if (nome.isEmpty ||
                            email.isEmpty ||
                            senha.isEmpty ||
                            role.isEmpty) {
                          setState(() {
                            errorMessage = 'Preencha todos os campos.';
                            isLoading = false;
                          });
                          return;
                        }

                        try {
                          final response = await Supabase.instance.client.auth
                              .signUp(email: email, password: senha);

                          final user = response.user;
                          if (user != null) {
                            await Supabase.instance.client
                                .from('usuarios')
                                .insert({
                                  'id': user.id,
                                  'nome': nome,
                                  'role': role,
                                });

                            if (scaffoldContext.mounted) {
                              Navigator.pop(context); // Fecha o dialog
                              ScaffoldMessenger.of(
                                scaffoldContext,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Usuário cadastrado com sucesso',
                                  ),
                                ),
                              );
                            }
                          }
                        } on AuthException catch (e) {
                          setState(() {
                            errorMessage = e.message;
                          });
                        } catch (e) {
                          print('Erro inesperado: $e');
                          setState(() {
                            errorMessage =
                                'Erro ao cadastrar. Tente novamente.';
                          });
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },
                      child: const Text('Salvar'),
                    ),
              ],
            );
          },
        );
      },
    );
  }

  void _adicionarDisciplina(BuildContext contextRoot) {
    final nomeController = TextEditingController();
    final codigoController = TextEditingController();

    showDialog(
      context: contextRoot,
      builder:
          (context) => AlertDialog(
            title: const Text('Nova Disciplina'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Disciplina',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código da Disciplina',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nome = nomeController.text.trim();
                  final codigo = codigoController.text.trim();

                  if (nome.isEmpty || codigo.isEmpty) {
                    ScaffoldMessenger.of(contextRoot).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }

                  try {
                    final supabase = Supabase.instance.client;
                    await supabase.from('disciplinas').insert({
                      'nome': nome,
                      'codigo': codigo,
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(contextRoot).showSnackBar(
                      const SnackBar(
                        content: Text('Disciplina adicionada com sucesso!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(contextRoot).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao adicionar disciplina: $e'),
                      ),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  void _adicionarSala(BuildContext contextRoot) {
    final nomeController = TextEditingController();
    final capacidadeController = TextEditingController();

    showDialog(
      context: contextRoot,
      builder:
          (context) => AlertDialog(
            title: const Text('Nova Sala'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da Sala'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: capacidadeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Capacidade da Sala',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nome = nomeController.text.trim();
                  final capacidade = capacidadeController.text.trim();

                  if (nome.isEmpty || capacidade.isEmpty) {
                    ScaffoldMessenger.of(contextRoot).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }

                  try {
                    final supabase = Supabase.instance.client;
                    await supabase.from('salas').insert({
                      'nome': nome,
                      'capacidade': capacidade,
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(contextRoot).showSnackBar(
                      const SnackBar(
                        content: Text('Sala adicionada com sucesso!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(contextRoot).showSnackBar(
                      SnackBar(content: Text('Erro ao adicionar sala: $e')),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => _adicionarUsuario(context),
              child: const Text('Adicionar Usuário'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _adicionarDisciplina(context),
              child: const Text('Adicionar Disciplina'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _adicionarSala(context),
              child: const Text('Adicionar Sala'),
            ),
          ],
        ),
      ),
    );
  }
}
