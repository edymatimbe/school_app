import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { masculino, feminino, outro }

class TeacherState {
  final String? id;
  final String? fullName;
  final String? username;
  final String? email;
  final String? password;
  final String? phone;
  final String? address;
  final DateTime? birthdate;
  final Gender? gender;
  final String? nationality;
  final String? imagePath;
  final String? subject;
  final String? qualification;
  final int? yearsOfExperience;
  final double? salary;
  final bool isLoading;

  TeacherState({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.password,
    this.phone,
    this.address,
    this.birthdate,
    this.gender,
    this.nationality,
    this.imagePath,
    this.subject,
    this.qualification,
    this.yearsOfExperience,
    this.salary,
    this.isLoading = false,
  });

  factory TeacherState.fromMap(Map<String, dynamic> map) {
    return TeacherState(
      id: map['id'],
      fullName: map['fullName'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      address: map['address'],
      birthdate:
          map['birthdate'] != null
              ? (map['birthdate'] is Timestamp
                  ? (map['birthdate'] as Timestamp).toDate()
                  : map['birthdate'] as DateTime)
              : null,
      gender:
          map['gender'] == 'masculino'
              ? Gender.masculino
              : map['gender'] == 'feminino'
              ? Gender.feminino
              : Gender.outro,
      nationality: map['nationality'],
      imagePath: map['imagePath'],
      subject: map['subject'],
      qualification: map['qualification'],
      yearsOfExperience: map['yearsOfExperience'],
      salary: map['salary'] != null ? (map['salary'] as num).toDouble() : null,
    );
  }

  TeacherState copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? password,
    String? phone,
    String? address,
    DateTime? birthdate,
    Gender? gender,
    String? nationality,
    String? imagePath,
    String? subject,
    String? qualification,
    int? yearsOfExperience,
    double? salary,
    bool? isLoading,
  }) {
    return TeacherState(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      imagePath: imagePath ?? this.imagePath,
      subject: subject ?? this.subject,
      qualification: qualification ?? this.qualification,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      salary: salary ?? this.salary,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
