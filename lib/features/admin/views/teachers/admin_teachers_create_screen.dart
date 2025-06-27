import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_app/features/admin/controllers/teacher_controller.dart';
import 'package:school_app/features/admin/models/teachers_model.dart';

final isPasswordHiddenProvider = StateProvider<bool>((ref) => true);

class AdminTeachersCreateScreen extends ConsumerWidget {
  const AdminTeachersCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherState = ref.watch(teacherProvider);
    final teacherNotifier = ref.read(teacherProvider.notifier);
    final isPasswordHidden = ref.watch(isPasswordHiddenProvider);

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
          'Novo Professor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              teacherState.imagePath != null
                  ? Image.file(File(teacherState.imagePath!), height: 200)
                  : const Text(
                    'Sem imagem selecionada.',
                    textAlign: TextAlign.center,
                  ),
              ElevatedButton(
                onPressed: teacherNotifier.pickImage,
                child: const Text("Selecionar Imagem"),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hint: 'Nome Completo',
                onChanged: teacherNotifier.setFullName,
              ),
              const SizedBox(height: 16),
              // Data de nascimento com showDatePicker
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText:
                      teacherState.birthdate != null
                          ? '${teacherState.birthdate!.day.toString().padLeft(2, '0')}/'
                              '${teacherState.birthdate!.month.toString().padLeft(2, '0')}/'
                              '${teacherState.birthdate!.year}'
                          : 'Data de Nascimento',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: teacherState.birthdate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    teacherNotifier.setBirthdate(picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Nacionalidade',
                onChanged: teacherNotifier.setNationality,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Gender>(
                value: teacherState.gender,
                decoration: _inputDecoration('Gênero'),
                onChanged: teacherNotifier.setGender,
                items:
                    Gender.values.map((g) {
                      return DropdownMenuItem(value: g, child: Text(g.name));
                    }).toList(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Endereço',
                onChanged: teacherNotifier.setAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Telefone',
                onChanged: teacherNotifier.setPhone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Matéria',
                onChanged: teacherNotifier.setSubject,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Qualificação',
                onChanged: teacherNotifier.setQualification,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Anos de Experiência',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) => teacherNotifier.setYearsOfExperience(
                      int.tryParse(value) ?? 0,
                    ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Salário',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) => teacherNotifier.setSalary(
                      double.tryParse(value) ?? 0.0,
                    ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Dados de Acesso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hint: 'Usuário',
                onChanged: teacherNotifier.setUsername,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                onChanged: teacherNotifier.setEmail,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hint: 'Palavra-Passe',
                obscure: isPasswordHidden,
                onChanged: teacherNotifier.setPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    ref.read(isPasswordHiddenProvider.notifier).state =
                        !isPasswordHidden;
                  },
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed:
                teacherState.isLoading
                    ? null
                    : () async {
                      try {
                        await teacherNotifier.addTeacher();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Professor criado com sucesso!'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro: ${e.toString()}')),
                          );
                        }
                      }
                    },
            child:
                teacherState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: _inputDecoration(hint).copyWith(suffixIcon: suffixIcon),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
