import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_app/features/admin/models/teachers_model.dart';
import 'package:school_app/features/admin/views/teachers/admin_teachers_create_screen.dart';

class AdminTeachersScreen extends StatelessWidget {
  AdminTeachersScreen({super.key});

  final CollectionReference teachersCollection = FirebaseFirestore.instance
      .collection('teachers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        flexibleSpace: Container(
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
        title: const Text(
          'Todos os Professores',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 68, 68),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: teachersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum professor encontrado.'));
          }

          // Converte documentos Firestore em lista de TeacherState
          final teachers =
              snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                // Converte timestamp Firestore para DateTime se necessário
                if (data['birthdate'] is Timestamp) {
                  data['birthdate'] = (data['birthdate'] as Timestamp).toDate();
                }
                return TeacherState.fromMap(data);
              }).toList();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return GestureDetector(
                onTap: () => _showTeacherDetails(context, teacher),
                child: _buildTeacherCard(context, teacher),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminTeachersCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context, TeacherState teacher) {
    return Container(
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
              backgroundImage:
                  teacher.imagePath != null && teacher.imagePath!.isNotEmpty
                      ? NetworkImage(teacher.imagePath!)
                      : null,
              child:
                  teacher.imagePath == null || teacher.imagePath!.isEmpty
                      ? const Icon(Icons.person, size: 30)
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Exemplo estático - ajuste conforme seu modelo
                  Text('Professor de ${teacher.subject}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.school,
                        text:
                            teacher.yearsOfExperience != null &&
                                    teacher.yearsOfExperience! > 0
                                ? '${teacher.yearsOfExperience} anos de experiência'
                                : '-',
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.star,
                        text: 'Turma 3',
                        color: _getGpaColor(0.0),
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

  void _showTeacherDetails(BuildContext context, TeacherState teacher) {
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
                  backgroundImage:
                      teacher.imagePath != null && teacher.imagePath!.isNotEmpty
                          ? NetworkImage(teacher.imagePath!)
                          : null,
                  child:
                      teacher.imagePath == null || teacher.imagePath!.isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                teacher.fullName ?? '',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(Icons.badge, 'Código', teacher.id ?? ''),
              _buildDetailRow(
                Icons.person,
                'Nome completo',
                teacher.fullName ?? '',
              ),
              _buildDetailRow(
                Icons.star,
                'Data de nascimento',
                teacher.birthdate != null
                    ? DateFormat('dd/MM/yyyy').format(teacher.birthdate!)
                    : '-',
              ),
              _buildDetailRow(
                Icons.star,
                'Gênero',
                teacher.gender?.toString() ?? '-',
              ),
              _buildDetailRow(
                Icons.school,
                'Nacionalidade',
                teacher.nationality ?? '-',
              ),
              _buildDetailRow(Icons.home, 'Endereço', teacher.address ?? '-'),
              _buildDetailRow(Icons.phone, 'Telefone', teacher.phone ?? '-'),
              _buildDetailRow(
                Icons.work,
                'Anos de Experiência',
                teacher.yearsOfExperience?.toString() ?? '-',
              ),
              _buildDetailRow(Icons.book, 'Disciplina', teacher.subject ?? '-'),
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
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
