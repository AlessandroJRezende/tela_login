import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tela_login/signup_page.dart';
import 'package:tela_login/dashboard_admin.dart';
import 'package:tela_login/dashboard_aluno.dart';
import 'package:tela_login/dashboard_professor.dart';

class LoginPage extends StatefulWidget {
  final String role; // 👈 Novo argumento

  const LoginPage({super.key, required this.role}); // 👈 Construtor atualizado
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {

        // Redirecionamento baseado na role
        Widget targetPage;
        switch (widget.role.toLowerCase()) {
          case 'aluno':
            targetPage = const StudentDashboard();
            break;
          case 'professor':
            targetPage = const ProfessorDashboard();
            break;
          case 'admin':
            targetPage = const AdminDashboard();
            break;
          default:
            targetPage = HomePage(); // fallback
        }
        // Login bem-sucedido
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      }
    } on AuthException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro inesperado. Tente novamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String ImgLink =
        "https://unicv.edu.br/wp-content/uploads/2020/12/logo-verde-280X100.png"; //image appbar
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.network(ImgLink),
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 222, 224, 223),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'EmSala +',
                    style: TextStyle(
                      color: const Color(0xFF4CAF50), // Define cor da fonte
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Digite seu e-mail'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Digite sua Senha'),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                        width: 155,
                        child: ElevatedButton(
                          onPressed: _signIn,
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              fontFamily: 'Roboto', // fonte texto
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ), // apenas estilo da fonte
                            foregroundColor: Colors.white, // cor da fonte
                            backgroundColor: const Color.fromARGB(
                              193,
                              31,
                              238,
                              4,
                            ), // cor de fundo
                          ),
                          child: Text('Entrar'),
                        ),
                      ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                        width: 155,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              fontFamily: 'Roboto', // fonte texto
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ), // apenas estilo da fonte
                            foregroundColor: Colors.white, // cor da fonte
                            backgroundColor: const Color.fromARGB(
                              193,
                              31,
                              238,
                              4,
                            ), // cor de fundo
                          ),
                          child: Text('Cadastre-se'),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Inicial')),
      body: Center(child: Text('Você está logado!')),
    );
  }
}
