import 'package:flutter/material.dart';

import '../providers/booking_provider.dart';
import '../utils/formatters.dart';

class BookingPolicyDialog extends StatelessWidget {
  const BookingPolicyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const BookingPolicyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.info_outline,
        color: Theme.of(context).colorScheme.primary,
        size: 40,
      ),
      title: const Text('Booking policy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PolicyItem(
            icon: Icons.event_available,
            text:
                'Free cancellation up to ${Formatters.hours(BookingProvider.cancellationNotice.inHours)} before the start time. After that, bookings can\'t be cancelled.',
          ),
          _PolicyItem(
            icon: Icons.repeat,
            text:
                'Maximum ${BookingProvider.maxBookingsPerDay} bookings per day.',
          ),
          const _PolicyItem(
            icon: Icons.schedule,
            text: 'Please arrive on time.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PolicyItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
