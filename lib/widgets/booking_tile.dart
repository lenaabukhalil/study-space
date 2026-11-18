import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../utils/formatters.dart';
import 'cancel_locked_hint.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;
  final String roomName;
  final bool canCancel;
  final VoidCallback onCancel;

  const BookingTile({
    super.key,
    required this.booking,
    required this.roomName,
    required this.canCancel,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onSurfaceVariant,
    );

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
            Text(Formatters.date(booking.start), style: muted),
            Text(
              '${Formatters.timeRange(booking.start, booking.end)} (${Formatters.hours(booking.durationHours)})',
              style: muted,
            ),
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 16,
                  color: scheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.paymentMethod,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: canCancel
            ? IconButton(
                icon: Icon(Icons.cancel_outlined, color: scheme.error),
                tooltip: 'Cancel booking',
                onPressed: onCancel,
              )
            : const CancelLockedHint(),
      ),
    );
  }
}
