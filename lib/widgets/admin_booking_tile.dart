import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../utils/formatters.dart';

class AdminBookingTile extends StatelessWidget {
  final Booking booking;
  final String roomName;
  final VoidCallback onCancel;

  const AdminBookingTile({
    super.key,
    required this.booking,
    required this.roomName,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = TextStyle(color: scheme.onSurfaceVariant);
    final name = booking.userName ?? 'Unknown customer';
    final email = booking.userEmail;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: CircleAvatar(
          backgroundColor: scheme.secondaryContainer,
          child: Icon(Icons.event, color: scheme.primary),
        ),
        title: Text(
          roomName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${Formatters.timeRange(booking.start, booking.end)} '
              '(${Formatters.hours(booking.durationHours)})',
              style: muted,
            ),
            Text(name, style: muted),
            if (email != null && email != name) Text(email, style: muted),
            const SizedBox(height: 2),
            Text(
              booking.paymentMethod,
              style: TextStyle(fontSize: 12, color: scheme.primary),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: scheme.error),
          tooltip: 'Cancel booking',
          onPressed: onCancel,
        ),
      ),
    );
  }
}
