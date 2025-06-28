import 'package:cloud_firestore/cloud_firestore.dart';

class CourseState {
  final int? id;
  final String? name;
  final String? description;
  final bool isLoading;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  CourseState({
    this.id,
    this.name,
    this.description,
    this.isLoading = false,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  CourseState copyWith({
    int? id,
    String? name,
    String? description,
    bool? isLoading,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return CourseState(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CourseState.fromMap(Map<String, dynamic> map) {
    return CourseState(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdBy: map['createdBy'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedBy: map['updatedBy'],
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
