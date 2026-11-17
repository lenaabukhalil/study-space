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
    final scheme = Theme.of(context).colorScheme;
    final muted = TextStyle(color: Colors.grey.shade700);

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
            Text(Formatters.date(booking.start), style: muted),
            Text(
              '${Formatters.timeRange(booking.start, booking.end)} (${Formatters.hours(booking.durationHours)})',
              style: muted,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 14,
                  color: scheme.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    booking.paymentMethod,
                    style: TextStyle(fontSize: 12, color: scheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: canCancel
            ? IconButton(
                icon: Icon(Icons.cancel, color: Colors.red.shade400),
                tooltip: 'Cancel booking',
                onPressed: onCancel,
              )
            : const CancelLockedHint(),
      ),
    );
  }
}
