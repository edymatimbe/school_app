import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_app/features/admin/models/students_model.dart';
import 'package:school_app/services/auth_service.dart';

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>(
  (ref) => StudentNotifier(),
);

class StudentNotifier extends StateNotifier<StudentState> {
  StudentNotifier() : super(StudentState());

  final CollectionReference _studentsCollection = FirebaseFirestore.instance
      .collection('students');

  void pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        print('📷 Imagem selecionada: ${pickedFile.path}');
        state = state.copyWith(imagePath: pickedFile.path);
      } else {
        print('⚠️ Nenhuma imagem selecionada.');
      }
    } catch (e) {
      print('❌ Erro ao selecionar imagem: $e');
    }
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setBirthdate(DateTime birthdate) {
    state = state.copyWith(birthdate: birthdate);
  }

  void setGender(Gender? gender) {
    state = state.copyWith(gender: gender);
  }

  void setNationality(String nationality) {
    state = state.copyWith(nationality: nationality);
  }

  void setAddress(String address) {
    state = state.copyWith(address: address);
  }

  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void setGPA(double? gpa) {
    state = state.copyWith(gpa: gpa);
  }

  void setGrade(int? grade) {
    state = state.copyWith(grade: grade);
  }

  void setSemester(String semester) {
    state = state.copyWith(semester: semester);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> addStudent(
    String fullName,
    String username,
    String nationality,
    String address,
    String phone,
    String email,
    String password, // ADICIONAR ISSO
  ) async {
    setLoading(true);
    // 👉 LOG DE TODOS OS VALORES
    print('--- DADOS DO ESTUDANTE ---');
    print('Nome Completo: ${state.fullName}');
    print('Username: ${state.username}');
    print('Email: ${state.email}');
    print('Data de Nascimento: ${state.birthdate}');
    print('Gênero: ${state.gender}');
    print('Nacionalidade: ${state.nationality}');
    print('Endereço: ${state.address}');
    print('Telefone: ${state.phone}');
    print('Imagem: ${state.imagePath}');
    print('---------------------------');
    if (state.fullName == null ||
        state.username == null ||
        state.nationality == null ||
        state.address == null ||
        state.phone == null ||
        state.email == null) {
      throw Exception('All fields are required');
    }

    try {
      String? imageUrl;
      final authService = AuthService();

      final error = await authService.signup(
        username: username,
        email: email,
        password: password,
        role: 'student',
      );

      if (error != null) {
        throw Exception(error);
      }
      if (state.imagePath != null) {
        final imageFile = File(state.imagePath!);

        if (!imageFile.existsSync()) {
          throw Exception('Imagem não encontrada no caminho especificado.');
        }

        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final reference = FirebaseStorage.instance.ref().child(
          'image/$fileName',
        );

        final uploadTask = await reference.putFile(imageFile);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      final String studentId =
          DateTime.now().millisecondsSinceEpoch.toString(); // ID único

      final Map<String, dynamic> studentData = {
        'id': studentId,
        'fullName': state.fullName,
        'username': state.username,
        'email': state.email,
        'birthdate': state.birthdate,
        'gender': state.gender?.name,
        'nationality': state.nationality,
        'address': state.address,
        'phone': state.phone,
        'grade': state.grade ?? 0,
        'gpa': state.gpa ?? 0.00,
        'semester': state.semester ?? "",
        if (imageUrl != null) 'imagePath': imageUrl,
      };

      // Remove campos nulos
      studentData.removeWhere((key, value) => value == null);

      await _studentsCollection.add(studentData);

      // Limpar estado
      state = StudentState();
    } catch (e) {
      print('Erro ao adicionar estudante: $e');
      throw Exception('Falha ao adicionar estudante');
    } finally {
      setLoading(false);
    }
  }
}
