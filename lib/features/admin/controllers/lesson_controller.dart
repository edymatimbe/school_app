import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_app/features/admin/models/lesson_model.dart';

final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>(
  (ref) => LessonNotifier(),
);

class LessonNotifier extends StateNotifier<LessonState> {
  LessonNotifier() : super(LessonState());

  final CollectionReference lessonController = FirebaseFirestore.instance
      .collection('lessons');

  final lessonStreamProvider = StreamProvider.family<
    List<Map<String, dynamic>>,
    String
  >((ref, courseId) {
    final lessonCollection = FirebaseFirestore.instance.collection('lessons');
    return lessonCollection
        .where('courseId', isEqualTo: courseId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList(),
        );
  });
}
