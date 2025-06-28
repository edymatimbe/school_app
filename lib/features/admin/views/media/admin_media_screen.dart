import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:school_app/features/admin/models/media_model.dart';
import 'admin_media_create_screen.dart';

class AdminMediaScreen extends StatelessWidget {
  AdminMediaScreen({super.key});

  final CollectionReference mediaCollection = FirebaseFirestore.instance
      .collection('media');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 68, 68),
                Color.fromARGB(255, 195, 129, 48),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Todos Ficheiros',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            mediaCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma mídia encontrada.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            );
          }

          final mediaList =
              snapshot.data!.docs
                  .map(
                    (doc) =>
                        MediaState.fromMap(doc.data() as Map<String, dynamic>),
                  )
                  .toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: mediaList.length,
            itemBuilder: (context, index) {
              final media = mediaList[index];

              return GestureDetector(
                onTap: () {
                  if (media.fileUrl != null) {
                    _downloadAndOpenFile(
                      context,
                      media.fileUrl!,
                      _buildFileNameWithExtension(media),
                    );
                  }
                },
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildPreview(media.fileExtension, theme),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _buildFileNameWithExtension(media),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  media.createdAt != null
                                      ? DateFormat(
                                        'dd/MM/yyyy HH:mm',
                                      ).format(media.createdAt!)
                                      : '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _confirmDelete(context, media),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminMediaCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPreview(String? url, ThemeData theme) {
    if (url == null) {
      return Center(
        child: Icon(
          Icons.insert_drive_file,
          size: 72,
          color: theme.colorScheme.primary.withOpacity(0.4),
        ),
      );
    }

    final mimeType = lookupMimeType(url);

    if (mimeType != null && mimeType.startsWith('image/')) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder:
              (_, __, ___) => Center(
                child: Icon(
                  Icons.broken_image,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
              ),
        ),
      );
    }

    IconData icon = Icons.insert_drive_file;
    if (mimeType != null) {
      if (mimeType.startsWith('video/')) {
        icon = Icons.video_file;
      } else if (mimeType == 'application/pdf') {
        icon = Icons.picture_as_pdf;
      }
    }

    return Center(
      child: Icon(
        icon,
        size: 72,
        color: theme.colorScheme.primary.withOpacity(0.6),
      ),
    );
  }

  Future<void> _downloadAndOpenFile(
    BuildContext context,
    String url,
    String fileName,
  ) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';

      final file = File(filePath);
      if (!await file.exists()) {
        final response = await Dio().download(url, filePath);
        if (response.statusCode != 200) throw Exception('Erro ao baixar');
      }

      await OpenFilex.open(filePath);
    } catch (e) {
      if (Navigator.of(context, rootNavigator: true).context.mounted) {
        ScaffoldMessenger.of(
          Navigator.of(context, rootNavigator: true).context,
        ).showSnackBar(SnackBar(content: Text('Erro ao abrir: $e')));
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, MediaState media) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Excluir arquivo'),
            content: const Text('Tem certeza que deseja excluir este arquivo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        // Deletar do Firebase Storage
        final ref = FirebaseStorage.instance.refFromURL(media.fileUrl!);
        await ref.delete();

        // Deletar do Firestore
        await FirebaseFirestore.instance
            .collection('media')
            .doc(media.id)
            .delete();

        if (Navigator.of(context, rootNavigator: true).context.mounted) {
          ScaffoldMessenger.of(
            Navigator.of(context, rootNavigator: true).context,
          ).showSnackBar(
            const SnackBar(content: Text('Arquivo excluído com sucesso')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
        }
      }
    }
  }

  String _buildFileNameWithExtension(MediaState media) {
    final title = media.title ?? 'arquivo';
    final ext = media.fileExtension?.toLowerCase();
    if (ext != null &&
        ext.isNotEmpty &&
        !title.toLowerCase().endsWith('.$ext')) {
      return '$title.$ext';
    }
    return title;
  }
}
