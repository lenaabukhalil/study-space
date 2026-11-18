import 'package:flutter/material.dart';

import '../models/weather_forecast.dart';
import '../utils/formatters.dart';
import 'summary_row.dart';
import 'weather_summary_row.dart';

class BookingSuccessDialog extends StatelessWidget {
  final String roomName;
  final DateTime start;
  final DateTime end;
  final double total;
  final String paymentMethod;
  final WeatherForecast? weather;

  const BookingSuccessDialog({
    super.key,
    required this.roomName,
    required this.start,
    required this.end,
    required this.total,
    required this.paymentMethod,
    this.weather,
  });

  static Future<void> show(
    BuildContext context, {
    required String roomName,
    required DateTime start,
    required DateTime end,
    required double total,
    required String paymentMethod,
    WeatherForecast? weather,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => BookingSuccessDialog(
        roomName: roomName,
        start: start,
        end: end,
        total: total,
        paymentMethod: paymentMethod,
        weather: weather,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forecast = weather;

    return AlertDialog(
      icon: Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.primary,
        size: 48,
      ),
      title: const Text('Booking confirmed'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SummaryRow(icon: Icons.chair_alt, label: 'Space', value: roomName),
            SummaryRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: Formatters.date(start),
            ),
            SummaryRow(
              icon: Icons.schedule,
              label: 'Time',
              value: Formatters.timeRange(start, end),
            ),
            if (forecast != null) WeatherSummaryRow(forecast: forecast),
            SummaryRow(
              icon: Icons.account_balance_wallet,
              label: 'Payment',
              value: paymentMethod,
            ),
            const Divider(height: 24),
            SummaryRow(
              icon: Icons.payments,
              label: 'Total',
              value: Formatters.price(total),
              emphasize: true,
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
