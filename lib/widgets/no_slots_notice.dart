import 'package:flutter/material.dart';

class NoSlotsNotice extends StatelessWidget {
  final VoidCallback onPickDate;

  const NoSlotsNotice({super.key, required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.secondaryContainer,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Icon(Icons.event_busy, color: scheme.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No available times on this day. Try another date.',
                style: TextStyle(color: scheme.onSecondaryContainer),
              ),
            ),
            TextButton(onPressed: onPickDate, child: const Text('Pick date')),
          ],
        ),
      ),
    );
  }
}
