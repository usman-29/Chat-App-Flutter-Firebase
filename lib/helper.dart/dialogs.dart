import 'package:flutter/material.dart';

class Dialogs {
  // displaying error
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blue.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // show loading circle
  static void showProgress(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}
