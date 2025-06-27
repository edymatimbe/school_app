import 'package:flutter/material.dart';

class TextFieldForm extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? hintText;
  final IconData? icon;
  final Color? iconColor;
  final bool obscure;
  final Function(String)? onChanged;

  const TextFieldForm({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.hintText,
    this.iconColor,
    this.icon,
    this.obscure = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: Text(label, style: TextStyle(color: Colors.grey)),
        prefixIcon:
            icon != null
                ? Icon(
                  icon,
                  color: iconColor ?? const Color.fromARGB(255, 0, 0, 0),
                )
                : null,
        hintText: hintText,
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
