import 'package:flutter/material.dart';

class NoSlotsNotice extends StatelessWidget {
  final VoidCallback onPickDate;

  const NoSlotsNotice({super.key, required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Icon(Icons.event_busy, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No available times on this day. Try another date.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(onPressed: onPickDate, child: const Text('Pick date')),
          ],
        ),
      ),
    );
  }
}
