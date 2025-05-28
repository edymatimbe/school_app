import 'package:flutter/material.dart';
import 'package:school_app/views/admin/students/admin_students_create_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Student {
  final String name;
  final String username;
  final String id;
  final String email;
  final int grade;
  final double gpa;
  final int semester;
  final String avatarUrl;

  Student({
    required this.name,
    required this.username,
    required this.id,
    required this.email,
    required this.grade,
    required this.gpa,
    required this.semester,
    required this.avatarUrl,
  });
}

class AdminStudentsScreen extends StatefulWidget {
  const AdminStudentsScreen({super.key});

  @override
  State<AdminStudentsScreen> createState() => _AdminStudentsScreenState();
}

class _AdminStudentsScreenState extends State<AdminStudentsScreen> {
  final List<Student> students = [
    Student(
      name: 'Estudante ',
      username: 'Estudante',
      id: 'ST001',
      email: '04/05/2025',
      grade: 10,
      gpa: 7,
      semester: 2,
      avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        flexibleSpace: Container(
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
        title: const Text(
          'Todos os Estudantes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 68, 68),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final student = students[index];
          return GestureDetector(
            onTap: () => _showStudentDetails(context, student),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(student.avatarUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${student.grade}',
                                  style: const TextStyle(fontSize: 16),
                                ), // Normal text
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.top,
                                  child: Transform.translate(
                                    offset: const Offset(0, -5),
                                    child: Text(
                                      "a",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                                const TextSpan(
                                  text: " Classe",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildInfoChip(
                                icon: Icons.school,
                                text: 'Semestre ${student.semester}',
                              ),
                              const SizedBox(width: 8),
                              _buildInfoChip(
                                icon: Icons.star,
                                text: 'Turma ${student.gpa}',
                                color: _getGpaColor(student.gpa),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminStudentsCreateScreen(),
            ),
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.1) ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: color ?? Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getGpaColor(double gpa) {
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 3.0) return Colors.blue;
    return Colors.orange;
  }

  void _showStudentDetails(BuildContext context, Student student) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(student.avatarUrl),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${student.grade}',
                      style: const TextStyle(fontSize: 20),
                    ), // Normal text
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Transform.translate(
                        offset: const Offset(0, -9),
                        child: Text("a", style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                    const TextSpan(
                      text: " Classe",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildDetailRow(Icons.person, 'Username', student.username),
              _buildDetailRow(Icons.badge, 'Codigo', student.id),
              _buildDetailRow(Icons.email, 'Data de Nascimento', student.email),
              _buildDetailRow(
                Icons.school,
                'Semestre',
                'Semestre ${student.semester}',
              ),
              _buildDetailRow(Icons.star, 'Turma', student.gpa.toString()),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Sair'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
