import 'package:flutter/material.dart';
import 'package:school_app/signin_screen.dart';
import 'package:school_app/features/admin/views/disciplines/admin_disciplines_screen.dart';
import 'package:school_app/features/admin/views/levels/admin_levels_screen.dart';
import 'package:school_app/features/admin/views/students/admin_students_screen.dart';
import 'package:school_app/features/admin/views/teachers/admin_teachers_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<_FeatureItem> features = [
    _FeatureItem('Estudantes', Icons.person_3, AdminStudentsScreen()),
    _FeatureItem('Professores', Icons.person_4_rounded, AdminTeachersScreen()),
    _FeatureItem('Classes', Icons.calendar_month, AdminLevelsScreen()),
    _FeatureItem('Disciplinas', Icons.calendar_month, AdminDisciplinesScreen()),
    _FeatureItem('Horários', Icons.calendar_month, AdminStudentsScreen()),
    _FeatureItem('Media', Icons.file_copy, AdminStudentsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 255, 68, 68),
                  const Color.fromARGB(255, 195, 129, 48),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header com imagem
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 255, 68, 68),
                        const Color.fromARGB(255, 195, 129, 48),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=3', // imagem de exemplo
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Olá, Admin !',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Bem-vindo de volta 👋',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Espaço para grade
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => feature.route,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                feature.icon,
                                size: 40,
                                color: const Color.fromARGB(255, 255, 93, 68),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                feature.title,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SigninScreen()),
                    );
                  },
                  child: Text('Sair'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final IconData icon;
  final dynamic route;
  _FeatureItem(this.title, this.icon, this.route);
}
