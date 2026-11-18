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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final end = start.add(Duration(hours: duration));
    final text =
        'Selected: ${Formatters.timeRange(start, end)} '
        '(${Formatters.hours(duration)}) · '
        '${Formatters.price(pricePerHour * duration)}';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.check_circle, size: 20, color: scheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
