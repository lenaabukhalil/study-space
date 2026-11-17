import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/booking.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;
  final String roomName;
  final VoidCallback onCancel;

  const BookingTile({
    super.key,
    required this.booking,
    required this.roomName,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, d MMM yyyy').format(booking.start);
    final timeFormat = DateFormat('HH:mm');
    final time =
        '${timeFormat.format(booking.start)} - ${timeFormat.format(booking.end)}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.event, color: Colors.blue.shade700),
        ),
        title: Text(
          roomName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$date\n$time'),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: Colors.red.shade400),
          tooltip: 'Cancel booking',
          onPressed: onCancel,
        ),
      ),
    );
  }
}
