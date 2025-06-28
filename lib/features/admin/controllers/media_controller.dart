import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school_app/features/admin/models/media_model.dart';

final mediaProvider = StateNotifierProvider<MediaNotifier, MediaState>((ref) {
  return MediaNotifier();
});

class MediaNotifier extends StateNotifier<MediaState> {
  MediaNotifier() : super(MediaState());

  final _collection = FirebaseFirestore.instance.collection('media');

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setFilePath(String path) {
    state = state.copyWith(filePath: path);
  }

  /// Selecionar qualquer tipo de arquivo
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: false,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final extension = path.split('.').last.toLowerCase();
      state = state.copyWith(filePath: path, fileExtension: extension);
    }
  }

  Future<void> uploadMedia() async {
    state = state.copyWith(isLoading: true);

    if (state.title == null || state.filePath == null) {
      throw Exception('Título e arquivo são obrigatórios.');
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final userId = currentUser?.uid ?? '';
      final file = File(state.filePath!);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child(
        'media/$fileName',
      );

      final uploadTask = storageRef.putFile(file);

      // Escutar eventos de progresso do upload
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        state = state.copyWith(progress: progress);
      });

      // Esperar o upload finalizar
      final snapshot = await uploadTask;

      final fileUrl = await snapshot.ref.getDownloadURL();

      final docId = _collection.doc().id;

      final mediaData = {
        'id': docId,
        'title': state.title,
        'description': state.description,
        'fileUrl': fileUrl,
        'fileExtension': state.fileExtension,
        'createdBy': userId,
        'createdAt': DateTime.now(),
        'updatedBy': userId,
        'updatedAt': DateTime.now(),
      };

      await _collection.doc(docId).set(mediaData);

      // Limpar estado e zerar progresso
      state = MediaState();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> deleteMedia(String docId, String fileUrl) async {
    try {
      // Deletar do Storage
      final ref = FirebaseStorage.instance.refFromURL(fileUrl);
      await ref.delete();

      // Deletar do Firestore
      await _collection.doc(docId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar arquivo: $e');
    }
  }
}
