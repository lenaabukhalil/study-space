import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/space_info.dart';

class DateSelector extends StatelessWidget {
  final DateTime date;
  final VoidCallback onChange;

  const DateSelector({super.key, required this.date, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(date),
                style: theme.textTheme.titleMedium,
              ),
              Text(
                'Open ${OpeningHours.forDate(date).label}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onChange,
          icon: const Icon(Icons.calendar_today, size: 18),
          label: const Text('Change'),
        ),
      ],
    );
  }
}
