import 'package:flutter/material.dart';

AppBar appBar(String title) {
  return AppBar(
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
    title: Text(title, style: TextStyle(color: Colors.white)),
    backgroundColor: const Color.fromARGB(255, 255, 68, 68),
  );
}
