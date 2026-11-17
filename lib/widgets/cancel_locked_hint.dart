import 'package:flutter/material.dart';

import '../providers/booking_provider.dart';
import '../utils/formatters.dart';

class CancelLockedHint extends StatelessWidget {
  const CancelLockedHint({super.key});

  @override
  Widget build(BuildContext context) {
    final notice = Formatters.hours(BookingProvider.cancellationNotice.inHours);

    return Tooltip(
      message: 'Bookings can be cancelled up to $notice before the start time',
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_clock, size: 20, color: Colors.grey.shade500),
            const SizedBox(height: 2),
            Text(
              "Can't cancel",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
