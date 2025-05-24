import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String content;

  const SuccessDialog({required this.title, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Ok"),
        ),
      ],
    );
  }
}
