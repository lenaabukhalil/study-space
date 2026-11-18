import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking.dart';
import '../providers/admin_provider.dart';
import '../providers/rooms_provider.dart';
import 'admin_booking_tile.dart';
import 'confirm_dialog.dart';
import 'content_width.dart';
import 'date_selector.dart';
import 'empty_state.dart';
import 'error_state.dart';

class AdminBookingsTab extends StatelessWidget {
  const AdminBookingsTab({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final admin = context.read<AdminProvider>();
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: admin.selectedDate,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      admin.setDate(picked);
    }
  }

  Future<void> _confirmCancel(BuildContext context, Booking booking) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Cancel booking?',
      message:
          'This removes the booking for '
          '${booking.userName ?? 'this customer'}. Continue?',
      confirmLabel: 'Cancel booking',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    final result = await context.read<AdminProvider>().cancelBooking(booking);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success ? 'Booking cancelled' : result.errorMessage!,
        ),
        backgroundColor: result.success
            ? null
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final rooms = context.watch<RoomsProvider>();
    final error = admin.error;
    final bookings = admin.bookings;

    Widget body;
    if (admin.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      body = ErrorState(message: error, onRetry: admin.retry);
    } else if (bookings.isEmpty) {
      body = const EmptyState(
        icon: Icons.event_available,
        message: 'No bookings on this day',
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return AdminBookingTile(
            booking: booking,
            roomName: rooms.roomById(booking.roomId)?.name ?? 'Unknown room',
            onCancel: () => _confirmCancel(context, booking),
          );
        },
      );
    }

    return ContentWidth(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: DateSelector(
              date: admin.selectedDate,
              onChange: () => _pickDate(context),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
