import 'package:flutter/material.dart';

Widget _defaultTextField({
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
