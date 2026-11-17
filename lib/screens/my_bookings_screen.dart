import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking.dart';
import '../providers/booking_provider.dart';
import '../providers/rooms_provider.dart';
import '../widgets/booking_tile.dart';
import '../widgets/error_state.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  Future<void> _confirmCancel(BuildContext context, Booking booking) async {
    final errorColor = Theme.of(context).colorScheme.error;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Yes', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final result = await context.read<BookingProvider>().cancelBooking(
      booking.id,
    );
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success ? 'Booking cancelled' : result.errorMessage!,
        ),
        backgroundColor: result.success ? null : errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final bookings = bookingProvider.myBookings;
    final error = bookingProvider.myBookingsError;
    final roomsProvider = context.watch<RoomsProvider>();

    Widget body;
    if (bookingProvider.isLoadingMyBookings) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      body = ErrorState(
        message: error,
        onRetry: bookingProvider.retryMyBookings,
      );
    } else if (bookings.isEmpty) {
      body = const _EmptyBookings();
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingTile(
            booking: booking,
            roomName:
                roomsProvider.roomById(booking.roomId)?.name ?? 'Unknown room',
            canCancel: bookingProvider.canCancel(booking),
            onCancel: () => _confirmCancel(context, booking),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: body,
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 64, color: muted),
          const SizedBox(height: 12),
          Text(
            'You have no bookings yet',
            style: TextStyle(fontSize: 16, color: muted),
          ),
        ],
      ),
    );
  }
}
