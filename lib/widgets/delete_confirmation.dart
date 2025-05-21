import 'package:flutter/material.dart';

class DeleteConfirmation extends StatelessWidget {
  final String title;
  final String content;
  final bool isActionDisabled;

  const DeleteConfirmation({
    required this.title,
    required this.content,
    this.isActionDisabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions:
          isActionDisabled
              ? [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Ok"),
                ),
              ]
              : [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text("Yes, Delete it"),
                ),
              ],
    );
  }
}
