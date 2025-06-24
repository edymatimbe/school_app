import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_app/common/widgets/date_picker_text_field.dart';

class AdminTeachersCreateScreen extends StatefulWidget {
  const AdminTeachersCreateScreen({super.key});

  @override
  State<AdminTeachersCreateScreen> createState() =>
      _AdminTeachersCreateScreenState();
}

class _AdminTeachersCreateScreenState extends State<AdminTeachersCreateScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 255, 68, 68),
                const Color.fromARGB(255, 195, 129, 48),
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
        backgroundColor: const Color.fromARGB(255, 255, 68, 68),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 200)
                  : const Text(
                    'No image selected.',
                    textAlign: TextAlign.center,
                  ),
              ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
              const SizedBox(height: 20),
              _buildTextField(
                controller: nameController,
                hint: 'Nome Completo',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: nameController,
                hint: 'Data de Nascimento',
              ),

              const SizedBox(height: 16),
              _buildTextField(
                controller: nameController,
                hint: 'Nacionalidade',
              ),
              const SizedBox(height: 16),
              _buildTextField(controller: nameController, hint: 'Genero'),
              const SizedBox(height: 16),
              _buildTextField(controller: nameController, hint: 'Endereço'),
              const SizedBox(height: 16),
              _buildTextField(controller: nameController, hint: 'Telefone'),
              const SizedBox(height: 26),
              Text(
                'Dados de Acesso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(controller: emailController, hint: 'Email'),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    hintText: 'Palavra-Passe',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Estudante criado com sucesso!')),
              );
            },
            child: const Text('Guardar', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  IconData? icon,
  bool obscure = false,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
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
    ),
  );
}
