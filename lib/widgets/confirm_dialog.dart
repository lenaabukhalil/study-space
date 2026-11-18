import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Yes',
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel, style: TextStyle(color: errorColor)),
        ),
      ],
    );
  }
}
