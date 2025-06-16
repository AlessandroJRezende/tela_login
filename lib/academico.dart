import 'package:flutter/material.dart';
import 'package:tela_login/login_page.dart';

void main() => runApp(const PortaisApp());

class PortaisApp extends StatelessWidget {
  const PortaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portais da Instituição',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PortaisPage(),
      debugShowCheckedModeBanner: false
    );
  }
}

class PortaisPage extends StatelessWidget {
  const PortaisPage({super.key});

  @override
  Widget build(BuildContext context) {
    String Imglink =
    "https://unicv.edu.br/wp-content/uploads/2020/12/logo-verde-280X100.png";
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Portal de Ensalamento'),
          
          Image.network(Imglink,fit: BoxFit.cover,height: 40,),
        ],
      )),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 1;
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 3;
          } else if (constraints.maxWidth > 800) {
            crossAxisCount = 2;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                PortalCard(
                  icon: Icons.school,
                  title: 'Portal do Aluno',
                  description:
                      'Um modo simples e fácil para acompanhar tudo o que acontece durante a sua evolução acadêmica na instituição.',
                  buttons: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage( role: 'aluno')),
                        );
                      },
                      child: const Text('Acessar'),
                    ),
                  ],
                ),
                PortalCard(
                  icon: Icons.link,
                  title: 'Portal do Professor',
                  description:
                      'Possibilita aos docentes uma gestão ágil da sua programação de aulas, registro de conteúdos, notas e frequências.',
                  buttons: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage(role: 'professor')),
                        );
                      },
                      child: const Text('Acessar'),
                    ),
                  ],
                ),
                PortalCard(
                  icon: Icons.admin_panel_settings,
                  title: 'Portal do Administrador',
                  description:
                      'Gerencie usuários, disciplinas, salas e turmas da instituição de forma centralizada e eficiente.',
                  buttons: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage(role: 'admin')),
                        );
                      },
                      child: const Text('Acessar'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PortalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Widget> buttons;

  const PortalCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(child: Text(description)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: buttons,
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboards existentes
class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Aluno')),
      body: const Center(child: Text('Conteúdo do Aluno')),
    );
  }
}

class ProfessorDashboard extends StatelessWidget {
  const ProfessorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Professor')),
      body: const Center(child: Text('Conteúdo do Professor')),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Administrador')),
      body: const Center(child: Text('Conteúdo do Administrador')),
    );
  }
}
