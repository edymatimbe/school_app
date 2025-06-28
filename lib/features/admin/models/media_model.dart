import 'package:cloud_firestore/cloud_firestore.dart';

class MediaState {
  final String? id;
  final String? title;
  final String? description;
  final String? filePath; // caminho local temporário, não salvo no Firestore
  final String? fileUrl; // URL salvo no Firestore
  final String? fileExtension;
  final double progress; // controle local, não salvo
  final bool isLoading;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  MediaState({
    this.id,
    this.title,
    this.description,
    this.filePath,
    this.fileUrl,
    this.fileExtension,
    this.progress = 0,
    this.isLoading = false,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  MediaState copyWith({
    String? id,
    String? title,
    String? description,
    String? filePath,
    String? fileUrl,
    String? fileExtension,
    double? progress,
    bool? isLoading,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return MediaState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      fileExtension: fileExtension ?? this.fileExtension,
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  // Mapeia dados do Firestore, ignora progress e isLoading
  factory MediaState.fromMap(Map<String, dynamic> map) {
    return MediaState(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      fileUrl: map['fileUrl'],
      fileExtension: map['fileExtension'],
      createdBy: map['createdBy'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedBy: map['updatedBy'],
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),

      // Provide default values for local-only fields
      progress: 0,
      isLoading: false,
    );
  }

  // Para salvar no Firestore, só campos que pertencem ao documento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'fileExtension': fileExtension,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
