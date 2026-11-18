import 'package:flutter/material.dart';

import '../models/payment_method.dart';
import '../models/room.dart';
import '../utils/formatters.dart';
import 'payment_method_selector.dart';
import 'summary_row.dart';

class BookingConfirmationSheet extends StatefulWidget {
  final Room room;
  final DateTime start;
  final DateTime end;

  const BookingConfirmationSheet({
    super.key,
    required this.room,
    required this.start,
    required this.end,
  });

  static Future<String?> show(
    BuildContext context, {
    required Room room,
    required DateTime start,
    required DateTime end,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) =>
          BookingConfirmationSheet(room: room, start: start, end: end),
    );
  }

  @override
  State<BookingConfirmationSheet> createState() =>
      _BookingConfirmationSheetState();
}

class _BookingConfirmationSheetState extends State<BookingConfirmationSheet> {
  String _paymentMethod = PaymentMethods.frontDesk;

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final hours = widget.end.difference(widget.start).inHours;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Confirm your booking',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SummaryRow(icon: Icons.chair_alt, label: 'Space', value: room.name),
            SummaryRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: Formatters.date(widget.start),
            ),
            SummaryRow(
              icon: Icons.schedule,
              label: 'Time',
              value:
                  '${Formatters.timeRange(widget.start, widget.end)} (${Formatters.hours(hours)})',
            ),
            const Divider(height: 24),
            SummaryRow(
              icon: Icons.payments,
              label: 'Total',
              value: Formatters.price(room.pricePerHour * hours),
              emphasize: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Payment method',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            PaymentMethodSelector(
              value: _paymentMethod,
              onChanged: (method) => setState(() => _paymentMethod = method),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, _paymentMethod),
              child: const Text('Confirm booking'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
