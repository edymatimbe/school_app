import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_app/features/admin/controllers/media_controller.dart';

class AdminMediaCreateScreen extends ConsumerWidget {
  const AdminMediaCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(mediaProvider);
    final mediaNotifier = ref.read(mediaProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
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
        backgroundColor: const Color.fromARGB(255, 255, 68, 68),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Título
              TextField(
                onChanged: mediaNotifier.setTitle,
                decoration: InputDecoration(
                  labelText: "Título",
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Descrição
              TextField(
                onChanged: mediaNotifier.setDescription,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Arquivo selecionado em Card
              if (media.filePath != null)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            File(media.filePath!).uri.pathSegments.last,
                            style: theme.textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Barra de progresso estilizada
              if (media.progress > 0 && media.progress < 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: media.progress,
                          minHeight: 12,
                          color: theme.colorScheme.primary,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${(media.progress * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 32),

              // Botão Selecionar Arquivo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: mediaNotifier.pickFile,
                  icon: const Icon(Icons.attach_file_outlined),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Selecionar Arquivo",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                    elevation: 4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botão Enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      media.isLoading
                          ? null
                          : () async {
                            final scaffoldContext = context;
                            try {
                              await mediaNotifier.uploadMedia();
                              if (scaffoldContext.mounted) {
                                ScaffoldMessenger.of(
                                  scaffoldContext,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text('Upload concluído'),
                                  ),
                                );
                                Navigator.pop(scaffoldContext);
                              }
                            } catch (e) {
                              if (scaffoldContext.mounted) {
                                ScaffoldMessenger.of(
                                  scaffoldContext,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao enviar mídia: $e'),
                                  ),
                                );
                              }
                            }
                          },
                  icon:
                      media.isLoading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                          : const Icon(Icons.cloud_upload_outlined),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      media.isLoading ? 'Guardando...' : 'Guardar',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
