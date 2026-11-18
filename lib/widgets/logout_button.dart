import 'package:flutter/material.dart';

import '../theme/app_layout.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.formMaxWidth),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: error,
            side: BorderSide(color: error),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
    );
  }
}
