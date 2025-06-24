import 'package:flutter/material.dart';

class ButtonForm extends StatelessWidget {
  final VoidCallback onTab;
  final String text;
  final Color? color;

  const ButtonForm({
    super.key,
    required this.onTab,
    required this.text,
    this.color = const Color.fromARGB(255, 255, 68, 68),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTab,
        child: Text(text, style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }
}
