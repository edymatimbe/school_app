import 'package:flutter/material.dart';
import 'package:school_app/services/auth_service.dart';
import 'package:school_app/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? role;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordHidden = true;

  final AuthService _authService = AuthService();

  void _signup() async {
    setState(() {
      isLoading = true;
    });

    String? result = await _authService.signup(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: 'student',
    );
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registado com sucesso, entre na sua conta $result'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SigninScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('O registo falhou $result')));
    }
  }

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

                Text('Registar', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 8),
                Text('Entrar como $role'),
                const SizedBox(height: 24),

                // Role toggle
                const SizedBox(height: 24),

                SizedBox(
                  height: 50,
                  child: _buildTextField(
                    controller: nameController,
                    hint: 'Name',
                    icon: Icons.person,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                SizedBox(
                  height: 50,
                  child: _buildTextField(
                    controller: emailController,
                    hint: 'Email',
                    icon: Icons.email,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
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
                Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
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
                      onPressed: _signup,
                      child: Text(
                        'Registar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                const SizedBox(height: 20),
                Text(
                  'Return to login',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
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
  }) {
    return TextField(
      controller: controller,
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
