import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/space_info.dart';

class DateSelector extends StatelessWidget {
  final DateTime date;
  final VoidCallback onChange;

  const DateSelector({super.key, required this.date, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Open ${OpeningHours.forDate(date).label}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: onChange,
          icon: const Icon(Icons.calendar_today, size: 18),
          label: const Text('Change'),
        ),
      ],
    );
  }
}
