import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { masculino, feminino, outro }

class StudentState {
  final String? id;
  final String? fullName;
  final DateTime? birthdate;
  final Gender? gender;
  final String? nationality;
  final String? address;
  final String? phone;
  final String? imagePath;
  final int? grade;
  final double? gpa;
  final int? semester;
  final int? classroom;
  final String? username;
  final String? email;
  final String? password;
  final bool isLoading;

  StudentState({
    this.id,
    this.fullName,
    this.birthdate,
    this.gender,
    this.nationality,
    this.address,
    this.phone,
    this.imagePath,
    this.grade,
    this.gpa,
    this.semester,
    this.classroom,
    this.username,
    this.email,
    this.password,
    this.isLoading = false,
  });

  factory StudentState.fromMap(Map<String, dynamic> map) {
    return StudentState(
      id: map['id'],
      fullName: map['fullName'],
      username: map['username'],
      email: map['email'],
      birthdate:
          map['birthdate'] != null
              ? (map['birthdate'] as Timestamp).toDate()
              : null,
      gender:
          map['gender'] == 'masculino'
              ? Gender.masculino
              : map['gender'] == 'feminino'
              ? Gender.feminino
              : null,
      nationality: map['nationality'],
      address: map['address'],
      phone: map['phone'],
      imagePath: map['imagePath'],
      gpa: map['gpa'] != null ? (map['gpa'] as num).toDouble() : null,
      grade: map['grade'],
      semester: map['semester'],
      classroom: map['classroom'],
    );
  }

  StudentState copyWith({
    String? id,
    String? fullName,
    String? username,
    DateTime? birthdate,
    Gender? gender,
    String? nationality,
    String? address,
    String? phone,
    String? imagePath,
    double? gpa,
    int? grade,
    int? semester,
    int? classroom,
    bool? isLoading,
    String? email,
    String? password,
  }) {
    return StudentState(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
      gpa: gpa ?? this.gpa,
      grade: grade ?? this.grade,
      semester: semester ?? this.semester,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
