import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking.dart';
import '../providers/booking_provider.dart';
import '../providers/rooms_provider.dart';
import '../widgets/booking_tile.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/content_width.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  Future<void> _confirmCancel(BuildContext context, Booking booking) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Cancel booking?',
      message: 'Are you sure you want to cancel this booking?',
    );

    if (!confirmed || !context.mounted) {
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
        backgroundColor: result.success
            ? null
            : Theme.of(context).colorScheme.error,
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
      body = const EmptyState(
        icon: Icons.event_busy,
        message: 'You have no bookings yet',
      );
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
      body: ContentWidth(child: body),
    );
  }
}
