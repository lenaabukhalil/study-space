import 'dart:async';

import 'package:flutter/foundation.dart';

import '../config/space_info.dart';
import '../models/booking.dart';
import '../models/booking_result.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';
import '../utils/formatters.dart';

class BookingProvider extends ChangeNotifier {
  static const int maxBookingsPerDay = 2;
  static const int maxDurationHours = 3;
  static const Duration cancellationNotice = Duration(hours: 1);

  final FirestoreService _firestore;
  final LocalStorageService _storage;

  int _preferredDuration = 1;
  bool _durationChanged = false;

  String? _currentUserId;
  String? _userName;
  String? _userEmail;
  StreamSubscription<List<Booking>>? _mySubscription;
  List<Booking> _myBookings = const [];
  bool _isLoadingMyBookings = false;
  String? _myBookingsError;

  String? _roomId;
  DateTime? _roomDay;
  StreamSubscription<Set<int>>? _roomDaySubscription;
  Set<int> _bookedHours = const {};
  bool _isLoadingRoomDay = false;
  String? _roomDayError;

  bool _isSubmitting = false;
  bool _disposed = false;

  BookingProvider(this._firestore, this._storage) {
    _restoreDuration();
  }

  int get preferredDuration => _preferredDuration;
  String? get currentUserId => _currentUserId;
  List<Booking> get myBookings => _myBookings;
  bool get isLoadingMyBookings => _isLoadingMyBookings;
  String? get myBookingsError => _myBookingsError;
  bool get isLoadingRoomDay => _isLoadingRoomDay;
  String? get roomDayError => _roomDayError;
  bool get isSubmitting => _isSubmitting;

  Set<int> get bookedHours => _bookedHours;

  void updateUser(String? userId, {String? name, String? email}) {
    _userName = (name == null || name.trim().isEmpty) ? null : name.trim();
    _userEmail = email;
    if (_currentUserId == userId) {
      return;
    }
    _currentUserId = userId;
    _mySubscription?.cancel();
    _mySubscription = null;
    _myBookings = const [];
    _myBookingsError = null;
    _isLoadingMyBookings = false;
    stopWatchingRoomDay();
    if (userId != null) {
      _subscribeMyBookings(userId);
    }
  }

  void setPreferredDuration(int hours) {
    if (hours < 1 || hours > maxDurationHours) {
      return;
    }
    _durationChanged = true;
    if (_preferredDuration == hours) {
      return;
    }
    _preferredDuration = hours;
    _storage.saveDuration(hours);
  }

  Future<void> _restoreDuration() async {
    final saved = await _storage.loadDuration();
    if (_durationChanged ||
        saved == null ||
        saved < 1 ||
        saved > maxDurationHours) {
      return;
    }
    _preferredDuration = saved;
    _notify();
  }

  void retryMyBookings() {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }
    _subscribeMyBookings(userId);
    _notify();
  }

  void watchRoomDay(String roomId, DateTime date) {
    final day = _dayOf(date);
    if (_roomId == roomId && _roomDay == day) {
      return;
    }
    _roomId = roomId;
    _roomDay = day;
    _subscribeRoomDay();
  }

  void retryRoomDay() {
    if (_roomId == null) {
      return;
    }
    _subscribeRoomDay();
    _notify();
  }

  void stopWatchingRoomDay() {
    _roomDaySubscription?.cancel();
    _roomDaySubscription = null;
    _roomId = null;
    _roomDay = null;
    _bookedHours = const {};
    _roomDayError = null;
    _isLoadingRoomDay = false;
  }

  Future<BookingResult> addBooking({
    required String roomId,
    required DateTime start,
    required DateTime end,
    required String paymentMethod,
  }) async {
    final userId = _currentUserId;
    if (userId == null) {
      return const BookingResult.failure('Please sign in to book.');
    }

    final error = _validate(userId, roomId, start, end);
    if (error != null) {
      return BookingResult.failure(error);
    }

    _isSubmitting = true;
    _notify();
    try {
      await _firestore.createBooking(
        roomId: roomId,
        userId: userId,
        start: start,
        end: end,
        paymentMethod: paymentMethod,
        userName: _userName ?? _userEmail,
        userEmail: _userEmail,
      );
      return const BookingResult.success();
    } on SlotTakenException {
      return const BookingResult.failure(
        'This time was just booked by someone else',
      );
    } catch (e) {
      return BookingResult.failure(FirestoreService.friendlyMessage(e));
    } finally {
      _isSubmitting = false;
      _notify();
    }
  }

  bool canCancel(Booking booking) {
    final deadline = booking.start.subtract(cancellationNotice);
    return DateTime.now().isBefore(deadline);
  }

  Future<BookingResult> cancelBooking(String id) async {
    final booking = _myBookings.where((b) => b.id == id).firstOrNull;
    if (booking == null) {
      return const BookingResult.failure('This booking no longer exists.');
    }
    if (!canCancel(booking)) {
      return BookingResult.failure(
        'Bookings can only be cancelled up to '
        '${Formatters.hours(cancellationNotice.inHours)} before the start time.',
      );
    }
    try {
      await _firestore.cancelBooking(booking);
      return const BookingResult.success();
    } catch (e) {
      return BookingResult.failure(FirestoreService.friendlyMessage(e));
    }
  }

  String? _validate(
    String userId,
    String roomId,
    DateTime start,
    DateTime end,
  ) {
    final duration = end.difference(start);
    if (!end.isAfter(start) ||
        duration.inMinutes % 60 != 0 ||
        duration.inHours > maxDurationHours) {
      return 'Please choose a valid duration.';
    }

    if (start.isBefore(DateTime.now())) {
      return 'You cannot book a time in the past.';
    }

    final hours = OpeningHours.forDate(start);
    final day = _dayOf(start);
    final opens = day.add(Duration(hours: hours.openHour));
    final closes = day.add(Duration(hours: hours.closeHour));
    if (start.isBefore(opens) || end.isAfter(closes)) {
      return 'Please choose a time within opening hours (${hours.label}).';
    }

    final userBookingsThatDay = _myBookings
        .where((booking) => _isSameDay(booking.start, start))
        .length;
    if (userBookingsThatDay >= maxBookingsPerDay) {
      return 'You can only make $maxBookingsPerDay bookings per day.';
    }

    final watchingThisDay = _roomId == roomId && _roomDay == _dayOf(start);
    final hasOverlap =
        watchingThisDay &&
        [
          for (
            var hour = start.hour;
            hour < start.hour + duration.inHours;
            hour++
          )
            hour,
        ].any(_bookedHours.contains);
    if (hasOverlap) {
      return 'This time slot is already booked.';
    }

    return null;
  }

  void _subscribeMyBookings(String userId) {
    _mySubscription?.cancel();
    _isLoadingMyBookings = true;
    _myBookingsError = null;
    _mySubscription = _firestore
        .watchUserBookings(userId)
        .listen(
          (bookings) {
            _myBookings = bookings;
            _isLoadingMyBookings = false;
            _myBookingsError = null;
            _notify();
          },
          onError: (Object error) {
            _isLoadingMyBookings = false;
            _myBookingsError = FirestoreService.friendlyMessage(error);
            _notify();
          },
        );
  }

  void _subscribeRoomDay() {
    final roomId = _roomId;
    final day = _roomDay;
    if (roomId == null || day == null) {
      return;
    }
    _roomDaySubscription?.cancel();
    _bookedHours = const {};
    _isLoadingRoomDay = true;
    _roomDayError = null;
    _roomDaySubscription = _firestore
        .watchBookedHours(roomId, day)
        .listen(
          (hours) {
            _bookedHours = hours;
            _isLoadingRoomDay = false;
            _roomDayError = null;
            _notify();
          },
          onError: (Object error) {
            _isLoadingRoomDay = false;
            _roomDayError = FirestoreService.friendlyMessage(error);
            _notify();
          },
        );
  }

  DateTime _dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _mySubscription?.cancel();
    _roomDaySubscription?.cancel();
    super.dispose();
  }
}
