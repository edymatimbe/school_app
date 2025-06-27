import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:school_app/core/widgets/button_form.dart';
import 'package:school_app/core/widgets/snack_bar.dart';
import 'package:school_app/core/widgets/text_field_form.dart';
import 'package:school_app/features/admin/controllers/student_controller.dart';

import '../../models/students_model.dart';

final isPasswordHiddenProvider = StateProvider<bool>((ref) => true);

class AdminStudentsCreateScreen extends ConsumerWidget {
  const AdminStudentsCreateScreen({super.key});
  // final fullNameController = TextEditingController();
  // final genderController = TextEditingController();
  // final nationalityController = TextEditingController();
  // final addressController = TextEditingController();
  // final phoneController = TextEditingController();

  // final usernameController = TextEditingController();
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  // Future<void> _selectBirthdate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(2005),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentProvider);
    final notifier = ref.read(studentProvider.notifier);
    final isPasswordHidden = ref.watch(isPasswordHiddenProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          'Novo Estudante',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 68, 68),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 15),
              state.imagePath != null
                  ? Image.file(File(state.imagePath!), height: 200)
                  : const Text(
                    'Sem imagem selecionada.',
                    textAlign: TextAlign.center,
                  ),
              ElevatedButton(
                onPressed: notifier.pickImage,
                child: const Text("Selecionar Imagem"),
              ),
              SizedBox(height: 20),

              TextFieldForm(
                label: 'Nome Completo',
                icon: Icons.person_2_outlined,
                onChanged: (value) => notifier.setFullName(value),
              ),
              SizedBox(height: 15),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText:
                      state.birthdate != null
                          ? '${state.birthdate!.day.toString().padLeft(2, '0')}/'
                              '${state.birthdate!.month.toString().padLeft(2, '0')}/'
                              '${state.birthdate!.year}'
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
                    initialDate: state.birthdate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    notifier.setBirthdate(picked);
                  }
                },
              ),
              SizedBox(height: 15),

              DropdownButtonFormField<Gender>(
                value: state.gender,
                decoration: InputDecoration(
                  // label: const Text('Gênero'),
                  prefixIcon: Icon(Icons.transgender_outlined),
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
                ),
                // hint: const Text('Gênero'),
                items: [
                  const DropdownMenuItem<Gender>(
                    value: null,
                    child: Text(
                      'Seleccione o gênero',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ...Gender.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(
                        gender.name[0].toUpperCase() + gender.name.substring(1),
                      ),
                    );
                  }),
                ],
                onChanged: (Gender? selectedGender) {
                  notifier.setGender(selectedGender);
                },
              ),
              SizedBox(height: 15),
              TextFieldForm(
                label: 'Nacionalidade',
                icon: Icons.rectangle_outlined,
                onChanged: (value) => notifier.setNationality(value),
              ),
              SizedBox(height: 15),
              TextFieldForm(
                label: 'Endereço',
                icon: Icons.pin_drop_outlined,
                onChanged: (value) => notifier.setAddress(value),
              ),
              SizedBox(height: 15),
              TextFieldForm(
                label: 'Telefone',
                icon: Icons.phone_outlined,
                onChanged: (value) => notifier.setPhone(value),
              ),
              SizedBox(height: 20),
              const Text(
                'Dados de Acesso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFieldForm(
                label: 'Nome de Utilizador',
                icon: Icons.person_2_outlined,
                onChanged: notifier.setUsername,
              ),
              SizedBox(height: 15),
              TextFieldForm(
                label: 'Email',
                icon: Icons.email_outlined,
                onChanged: notifier.setEmail,
              ),
              SizedBox(height: 15),
              _buildTextField(
                hint: 'Palavra-Passe',
                obscure: isPasswordHidden,
                onChanged: notifier.setPassword,
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

              // ButtonForm(
              //   onTab: () async {
              //     try {
              //       await notifier.addStudent();
              //       showSnackBar(context, 'ALuno adicionado com sucesso');
              //       Navigator.of(context).pop();
              //     } catch (e) {
              //       showSnackBar(context, 'Error: $e');
              //     }
              //   },
              //   text: 'Guardar',
              // ),
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
                state.isLoading
                    ? null
                    : () async {
                      try {
                        await notifier.addStudent();
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
                state.isLoading
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
