import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class SelectionSummary extends StatelessWidget {
  final DateTime start;
  final int duration;
  final double pricePerHour;

  const SelectionSummary({
    super.key,
    required this.start,
    required this.duration,
    required this.pricePerHour,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final end = start.add(Duration(hours: duration));
    final text =
        'Selected: ${Formatters.timeRange(start, end)} '
        '(${Formatters.hours(duration)}) · '
        '${Formatters.price(pricePerHour * duration)}';

    return Row(
      children: [
        Icon(Icons.check_circle, size: 18, color: scheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: scheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
