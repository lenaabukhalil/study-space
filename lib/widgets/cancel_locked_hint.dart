import 'package:flutter/material.dart';

import '../providers/booking_provider.dart';
import '../utils/formatters.dart';

class CancelLockedHint extends StatelessWidget {
  const CancelLockedHint({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final notice = Formatters.hours(BookingProvider.cancellationNotice.inHours);

    return Tooltip(
      message: 'Bookings can be cancelled up to $notice before the start time',
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_clock, size: 20, color: muted),
            Text(
              "Can't cancel",
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
