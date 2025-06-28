import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_app/common/widgets/app_bar.dart';
import 'package:school_app/features/admin/models/lesson_model.dart';

class AdminLessonsScreen extends StatelessWidget {
  final String courseId;

  AdminLessonsScreen({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Aulas do Curso'),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('courses')
                .doc(courseId)
                .collection(
                  'lessons',
                ) // Stream lessons for this specific course
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhuma aula encontrada.'));
          }

          final lessons =
              snapshot.data!.docs.map((doc) {
                // Convert your document data to a Lesson model here
                return LessonState.fromMap(doc.data() as Map<String, dynamic>);
              }).toList();

          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return ListTile(
                title: Text(lesson.title.toString()),
                subtitle: Text(lesson.descricao.toString()),
                // other lesson details
              );
            },
          );
        },
      ),
    );
  }
}
