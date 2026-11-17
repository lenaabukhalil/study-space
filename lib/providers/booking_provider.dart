import 'package:flutter/foundation.dart';

import '../models/booking.dart';
import '../models/booking_result.dart';

class BookingProvider extends ChangeNotifier {
  static const int maxBookingsPerDay = 2;

  final List<Booking> _bookings = [];
  String? _currentUserId;

  String? get currentUserId => _currentUserId;

  List<Booking> get bookings => List.unmodifiable(_bookings);

  List<Booking> get myBookings {
    final userId = _currentUserId;
    if (userId == null) {
      return const [];
    }
    return bookingsForUser(userId);
  }

  void updateUser(String? userId) {
    if (_currentUserId == userId) {
      return;
    }
    _currentUserId = userId;
    if (userId == null) {
      _bookings.clear();
    }
  }

  BookingResult addBooking({
    required String roomId,
    required DateTime start,
    required DateTime end,
  }) {
    final userId = _currentUserId;
    if (userId == null) {
      return const BookingResult.failure('Please sign in to book.');
    }

    if (start.isBefore(DateTime.now())) {
      return const BookingResult.failure('You cannot book a time in the past.');
    }

    final hasOverlap = _bookings.any(
      (booking) =>
          booking.roomId == roomId &&
          start.isBefore(booking.end) &&
          end.isAfter(booking.start),
    );
    if (hasOverlap) {
      return const BookingResult.failure('This time slot is already booked.');
    }

    final userBookingsThatDay = _bookings
        .where(
          (booking) =>
              booking.userId == userId && _isSameDay(booking.start, start),
        )
        .length;
    if (userBookingsThatDay >= maxBookingsPerDay) {
      return const BookingResult.failure(
        'You can only make $maxBookingsPerDay bookings per day.',
      );
    }

    final now = DateTime.now();
    _bookings.add(
      Booking(
        id: now.microsecondsSinceEpoch.toString(),
        roomId: roomId,
        userId: userId,
        start: start,
        end: end,
        createdAt: now,
      ),
    );
    notifyListeners();
    return const BookingResult.success();
  }

  void cancelBooking(String id) {
    _bookings.removeWhere((booking) => booking.id == id);
    notifyListeners();
  }

  List<Booking> bookingsForRoomOnDate(String roomId, DateTime date) {
    return _bookings
        .where(
          (booking) =>
              booking.roomId == roomId && _isSameDay(booking.start, date),
        )
        .toList();
  }

  List<Booking> bookingsForUser(String userId) {
    return _bookings.where((booking) => booking.userId == userId).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
