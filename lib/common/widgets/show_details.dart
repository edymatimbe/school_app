import 'package:flutter/material.dart';

class DetailsBottomSheet extends StatelessWidget {
  final String title;
  final Widget? content;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const DetailsBottomSheet({
    super.key,
    required this.title,
    this.content,
    this.buttonText = 'Sair',
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          if (content != null) content!,
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onButtonPressed ?? () => Navigator.pop(context),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}

void showDetailsBottomSheet({
  required BuildContext context,
  required String title,
  Widget? content,
  String buttonText = 'Sair',
  VoidCallback? onButtonPressed,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return DetailsBottomSheet(
        title: title,
        content: content,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
      );
    },
  );
}
