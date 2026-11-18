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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = booking.userName ?? 'Unknown customer';
    final email = booking.userEmail;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Icon(Icons.event, color: scheme.primary),
        ),
        title: Text(roomName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${Formatters.timeRange(booking.start, booking.end)} '
              '(${Formatters.hours(booking.durationHours)})',
            ),
            Text(name),
            if (email != null && email != name) Text(email),
            Text(
              booking.paymentMethod,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.primary,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel_outlined, color: scheme.error),
          tooltip: 'Cancel booking',
          onPressed: onCancel,
        ),
      ),
    );
  }
}
