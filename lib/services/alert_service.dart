import 'package:flutter/material.dart';

class AlertService {
  static void showSuccess(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content), backgroundColor: Colors.green),
    );
  }

  static void showError(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content), backgroundColor: Colors.red),
    );
  }
}
