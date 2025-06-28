import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_app/features/admin/views/courses/admin_course_screen.dart';
import 'package:school_app/features/admin/views/media/admin_media_screen.dart';
import 'package:school_app/signin_screen.dart';
import 'package:school_app/features/admin/views/levels/admin_levels_screen.dart';
import 'package:school_app/features/admin/views/students/admin_students_screen.dart';
import 'package:school_app/features/admin/views/teachers/admin_teachers_screen.dart';
import 'package:school_app/features/admin/controllers/auth_controller.dart';

class AdminScreen extends ConsumerWidget {
  AdminScreen({super.key});

  // ignore: library_private_types_in_public_api
  final List<_FeatureItem> features = [
    _FeatureItem('Estudantes', Icons.file_copy, AdminStudentsScreen()),
    _FeatureItem('Professores', Icons.person_4_rounded, AdminTeachersScreen()),
    _FeatureItem('Classes', Icons.calendar_month, AdminLevelsScreen()),
    _FeatureItem('Disciplinas', Icons.calendar_month, AdminCourseScreen()),
    _FeatureItem('Horários', Icons.calendar_month, AdminStudentsScreen()),
    _FeatureItem('Media', Icons.file_copy, AdminMediaScreen()),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 68, 68),
                  Color.fromARGB(255, 195, 129, 48),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 68, 68),
                        Color.fromARGB(255, 195, 129, 48),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=3',
                        ),
                      ),
                      const SizedBox(width: 16),
                      userSnapshot.when(
                        data: (doc) {
                          final name = doc.data()?['username'] ?? 'Admin';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, $name!',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Bem-vindo de volta 👋',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          );
                        },
                        loading:
                            () => const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                        error:
                            (e, _) => const Text(
                              'Erro ao carregar usuário',
                              style: TextStyle(color: Colors.white),
                            ),
                      ),
                    ],
                  ),
                ),

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
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SigninScreen()),
                    );
                  },
                  child: const Text('Sair'),
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
  final Widget route;
  _FeatureItem(this.title, this.icon, this.route);
}
