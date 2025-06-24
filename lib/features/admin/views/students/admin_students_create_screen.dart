// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:school_app/core/widgets/button_form.dart';
import 'package:school_app/core/widgets/snack_bar.dart';
import 'package:school_app/core/widgets/text_field_form.dart';
import 'package:school_app/features/admin/controllers/student_controller.dart';

import '../../models/students_model.dart';

class AdminStudentsCreateScreen extends ConsumerWidget {
  AdminStudentsCreateScreen({super.key});
  final fullNameController = TextEditingController();
  final genderController = TextEditingController();
  final nationalityController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
    final birthdateController = TextEditingController(
      text:
          state.birthdate != null
              ? DateFormat('dd/MM/yyyy').format(state.birthdate!)
              : '',
    );

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
          child: Column(
            children: [
              SizedBox(height: 15),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child:
                      state.imagePath != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(state.imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                          : (state.isLoading)
                          ? CircularProgressIndicator()
                          : GestureDetector(
                            onTap: notifier.pickImage,
                            child: const Icon(Icons.camera),
                          ),
                ),
              ),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 20,
                child: Text('Dados do aluno', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 10),
              TextFieldForm(
                controller: fullNameController,
                label: 'Nome Completo',
                icon: Icons.person_2_outlined,
                onChanged: (value) => notifier.setFullName(value),
              ),
              SizedBox(height: 15),
              TextField(
                controller: birthdateController,
                readOnly: true,
                decoration: InputDecoration(
                  label: Text(
                    'Data de Nascimento',
                    style: TextStyle(color: Colors.grey),
                  ),
                  prefixIcon: const Icon(Icons.date_range_outlined),
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
                controller: nationalityController,
                label: 'Nacionalidade',
                icon: Icons.rectangle_outlined,
                onChanged: (value) => notifier.setNationality(value),
              ),
              SizedBox(height: 15),
              TextFieldForm(
                controller: addressController,
                label: 'Endereço',
                icon: Icons.pin_drop_outlined,
                onChanged: (value) => notifier.setAddress(value),
              ),
              SizedBox(height: 15),
              TextFieldForm(
                controller: phoneController,
                label: 'Telefone',
                icon: Icons.phone_outlined,
                onChanged: (value) => notifier.setPhone(value),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 20,
                child: Text('Dados de acesso', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 10),
              TextFieldForm(
                controller: usernameController,
                label: 'Nome de Utilizador',
                icon: Icons.person_2_outlined,
                onChanged: (value) => notifier.setUsername(value),
              ),
              SizedBox(height: 15),
              TextFieldForm(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                onChanged: (value) => notifier.setEmail(value),
              ),
              SizedBox(height: 15),
              TextFieldForm(
                controller: passwordController,
                label: 'Palavra-passe',
                icon: Icons.lock_outline,
                obscure: true,
              ),

              ButtonForm(
                onTab: () async {
                  try {
                    await notifier.addStudent(
                      fullNameController.text,
                      usernameController.text,
                      nationalityController.text,
                      addressController.text,
                      phoneController.text,
                      emailController.text,
                      passwordController.text,
                    );
                    showSnackBar(context, 'ALuno adicionado com sucesso');
                    Navigator.of(context).pop();
                  } catch (e) {
                    showSnackBar(context, 'Error: $e');
                  }
                },
                text: 'Guardar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
