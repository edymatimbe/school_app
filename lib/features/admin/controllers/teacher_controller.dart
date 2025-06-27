import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_app/features/admin/models/teachers_model.dart';
import 'package:school_app/services/auth_service.dart';

final teacherProvider = StateNotifierProvider<TeacherNotifier, TeacherState>(
  (ref) => TeacherNotifier(),
);

class TeacherNotifier extends StateNotifier<TeacherState> {
  TeacherNotifier() : super(TeacherState());

  final CollectionReference _teachersCollection = FirebaseFirestore.instance
      .collection('teachers');

  void pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        state = state.copyWith(imagePath: pickedFile.path);
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
    }
  }

  // Setters
  void setUsername(String username) =>
      state = state.copyWith(username: username);
  void setFullName(String fullName) =>
      state = state.copyWith(fullName: fullName);
  void setEmail(String email) => state = state.copyWith(email: email);
  void setPassword(String password) =>
      state = state.copyWith(password: password);
  void setBirthdate(DateTime birthdate) =>
      state = state.copyWith(birthdate: birthdate);
  void setGender(Gender? gender) => state = state.copyWith(gender: gender);
  void setNationality(String nationality) =>
      state = state.copyWith(nationality: nationality);
  void setAddress(String address) => state = state.copyWith(address: address);
  void setPhone(String phone) => state = state.copyWith(phone: phone);
  void setSubject(String subject) => state = state.copyWith(subject: subject);
  void setQualification(String qualification) =>
      state = state.copyWith(qualification: qualification);
  void setYearsOfExperience(int years) =>
      state = state.copyWith(yearsOfExperience: years);
  void setSalary(double salary) => state = state.copyWith(salary: salary);
  void setLoading(bool isLoading) =>
      state = state.copyWith(isLoading: isLoading);

  Future<void> addTeacher() async {
    setLoading(true);

    try {
      if (state.fullName == null ||
          state.username == null ||
          state.email == null ||
          state.password == null) {
        throw Exception('Campos obrigatórios ausentes');
      }

      final authService = AuthService();

      final error = await authService.signup(
        username: state.username!,
        email: state.email!,
        password: state.password!,
        role: 'teacher',
      );

      if (error != null) throw Exception(error);

      String? imageUrl;

      if (state.imagePath != null) {
        final imageFile = File(state.imagePath!);

        if (imageFile.existsSync()) {
          final fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final reference = FirebaseStorage.instance.ref().child(
            'teachers/$fileName',
          );

          final uploadTask = reference.putFile(imageFile);
          final snapshot = await uploadTask.whenComplete(() => null);

          imageUrl = await snapshot.ref.getDownloadURL();
        } else {
          print(
            'Arquivo de imagem não encontrado no caminho: ${state.imagePath}',
          );
        }
      }

      final teacherId = DateTime.now().millisecondsSinceEpoch.toString();

      final teacherData = {
        'id': teacherId,
        'fullName': state.fullName,
        'username': state.username,
        'email': state.email,
        'birthdate': state.birthdate,
        'gender': state.gender?.name,
        'nationality': state.nationality,
        'address': state.address,
        'phone': state.phone,
        'subject': state.subject,
        'qualification': state.qualification,
        'yearsOfExperience': state.yearsOfExperience,
        'salary': state.salary,
        if (imageUrl != null) 'imagePath': imageUrl,
      };

      teacherData.removeWhere((key, value) => value == null);

      await _teachersCollection.add(teacherData);

      state = TeacherState();
    } catch (e) {
      print('Erro ao adicionar professor: $e');
      throw Exception('Falha ao adicionar professor');
    } finally {
      setLoading(false);
    }
  }
}
