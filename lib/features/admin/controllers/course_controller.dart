import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_app/features/admin/models/course_model.dart';

final courseProvider = StateNotifierProvider<CourseNotifier, CourseState>(
  (ref) => CourseNotifier(),
);

class CourseNotifier extends StateNotifier<CourseState> {
  CourseNotifier() : super(CourseState());

  final CollectionReference _courseColletion = FirebaseFirestore.instance
      .collection('courses');

  void setName(String name) => state = state.copyWith(name: name);
  void setDescription(String description) =>
      state = state.copyWith(description: description);
  void setIsLoading(bool isLoading) =>
      state = state.copyWith(isLoading: isLoading);

  Future<void> addCourse() async {
    setIsLoading(true);

    try {
      if (state.name == null) {
        throw Exception('Campos nome é obrigatório');
      }

      if (state.description == null) {
        throw Exception('Campos descrição é obrigatório');
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final userId = currentUser?.uid ?? '';
      final docId = _courseColletion.doc().id;

      final data = {
        'id': docId,
        'name': state.name,
        'description': state.description,
        'createdBy': userId,
        'createdAt': DateTime.now(),
        'updatedBy': userId,
        'updatedAt': DateTime.now(),
      };

      await _courseColletion.doc(docId).set(data);
      state = CourseState();
    } catch (e, stack) {
      if (kDebugMode) {
        print('Erro ao adicionar curso: $e');
        print(stack);
      }
    } finally {
      setIsLoading(false);
    }
  }
}
