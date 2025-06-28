import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_app/features/admin/controllers/auth_controller.dart';
import 'package:school_app/signin_screen.dart';

class StudentScreen extends ConsumerWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              // Added SingleChildScrollView here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com imagem
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
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
                          child: Image.asset(
                            'assets/images/avatars/avatar.jpg',
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

                  // Title for today's classes
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'As minhas aulas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Hoje',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // Today's classes
                  _buildClassCard(
                    '12:00 - 14:00',
                    'Matematica',
                    'Professor Antonio',
                  ),
                  _buildClassCard(
                    '14:00 - 16:00',
                    'Matematica',
                    'Professor Antonio',
                  ),
                  _buildClassCard(
                    '16:00 - 18:00',
                    'Matematica',
                    'Professor Antonio',
                  ),

                  // Title for tomorrow's classes
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Amanhã',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tomorrow's classes
                  _buildClassCard(
                    '12:00 - 14:00',
                    'Matematica',
                    'Professor Antonio',
                  ),
                  _buildClassCard(
                    '12:00 - 14:00',
                    'Matematica',
                    'Professor Antonio',
                  ),
                  _buildClassCard(
                    '12:00 - 14:00',
                    'Matematica',
                    'Professor Antonio',
                  ),

                  // Sign out button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SigninScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Sign Out'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.question_mark),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildClassCard(String time, String subject, String teacher) {
    return Card(
      color: const Color.fromRGBO(245, 245, 255, 1),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(subject, style: TextStyle(fontSize: 18)),
                SizedBox(height: 4),
                Text(teacher, style: TextStyle(fontSize: 14)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/images/icons/lesson.png'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
