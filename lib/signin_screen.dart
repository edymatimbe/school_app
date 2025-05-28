import 'package:flutter/material.dart';
import 'package:school_app/services/auth_service.dart';
import 'package:school_app/signup_screen.dart';
import 'package:school_app/views/admin/admin_screen.dart';
import 'package:school_app/views/home_screen.dart';
import 'package:school_app/views/student/student_screen.dart';
import 'package:school_app/views/teacher/teacher_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String role = 'Teacher';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordHidden = true;

  void signin() async {
    setState(() {
      isLoading = true;
    });

    String? result = await _authService.signin(
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminScreen()),
      );
    } else if (result == 'student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentScreen()),
      );
    } else if (result == 'teacher') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TeacherScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Icon
                Icon(Icons.school, size: 80, color: Colors.blueAccent),
                const SizedBox(height: 16),

                Text('Bem vindo de volta', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 8),
                Text('Entrar como $role'),
                const SizedBox(height: 24),

                const SizedBox(height: 24),

                _buildTextField(
                  controller: emailController,
                  hint: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                      hintText: 'Password',
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
                const SizedBox(height: 32),

                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: signin,
                      child: Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                const SizedBox(height: 20),
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
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
}
