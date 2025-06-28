import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_app/common/widgets/app_bar.dart';
import 'package:school_app/features/admin/models/course_model.dart';
import 'package:school_app/features/admin/views/lessons/admin_lessons_screen.dart';

class AdminCourseScreen extends StatelessWidget {
  AdminCourseScreen({super.key});

  final CollectionReference _collectionCourse = FirebaseFirestore.instance
      .collection('courses');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Todas Disciplinas'),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _collectionCourse
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhuma disciplina encontrada.'));
          }

          final courses =
              snapshot.data!.docs
                  .map(
                    (doc) =>
                        CourseState.fromMap(doc.data() as Map<String, dynamic>),
                  )
                  .toList();

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return GestureDetector(
                onTap:
                    () => {
                      print('Hello getting the id${course.id}'),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AdminLessonsScreen(
                                courseId: course.id!,
                              ), // Assuming course.id holds the courseId
                        ),
                      ),
                    },
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.name.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),

                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildInfoChip(
                                    icon: Icons.class_,
                                    text: '23 aulas',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                  ),
                                  _buildInfoChip(
                                    icon: Icons.school,
                                    text: '10a Classe',
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
          );
        },
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
        color: color?.withOpacity(0.1) ?? const Color.fromARGB(255, 231, 90, 9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? const Color.fromARGB(255, 255, 254, 254),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color ?? const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}
