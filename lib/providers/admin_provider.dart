import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/booking.dart';
import '../models/booking_result.dart';
import '../models/room.dart';
import '../services/firestore_service.dart';

class AdminProvider extends ChangeNotifier {
  final FirestoreService _firestore;

  bool _isAdmin = false;
  DateTime _selectedDate = _today();
  StreamSubscription<List<Booking>>? _subscription;
  List<Booking> _bookings = const [];
  bool _isLoading = false;
  String? _error;
  bool _isSaving = false;
  bool _disposed = false;

  AdminProvider(this._firestore);

  bool get isAdmin => _isAdmin;
  DateTime get selectedDate => _selectedDate;
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSaving => _isSaving;

  void updateAdmin(bool isAdmin) {
    if (_isAdmin == isAdmin) {
      return;
    }
    _isAdmin = isAdmin;
    _subscription?.cancel();
    _subscription = null;
    _bookings = const [];
    _error = null;
    _isLoading = false;
    if (isAdmin) {
      unawaited(_firestore.seedRoomsIfEmpty().catchError((Object _) {}));
      _subscribe();
    }
  }

  void setDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    if (day == _selectedDate) {
      return;
    }
    _selectedDate = day;
    _subscribe();
    _notify();
  }

  void retry() {
    _subscribe();
    _notify();
  }

  Future<BookingResult> saveRoom(Room room, {required bool isNew}) async {
    _isSaving = true;
    _notify();
    try {
      if (isNew) {
        await _firestore.addRoom(room);
      } else {
        await _firestore.updateRoom(room);
      }
      return const BookingResult.success();
    } catch (e) {
      return BookingResult.failure(FirestoreService.friendlyMessage(e));
    } finally {
      _isSaving = false;
      _notify();
    }
  }

  Future<BookingResult> deleteRoom(Room room) async {
    try {
      if (await _firestore.hasFutureBookings(room.id)) {
        return const BookingResult.failure(
          'This room has upcoming bookings. Cancel them first in the '
          'Bookings tab, then delete the room.',
        );
      }
      await _firestore.deleteRoom(room.id);
      return const BookingResult.success();
    } catch (e) {
      return BookingResult.failure(FirestoreService.friendlyMessage(e));
    }
  }

  Future<BookingResult> cancelBooking(Booking booking) async {
    try {
      await _firestore.cancelBooking(booking);
      return const BookingResult.success();
    } catch (e) {
      return BookingResult.failure(FirestoreService.friendlyMessage(e));
    }
  }

  void _subscribe() {
    if (!_isAdmin) {
      return;
    }
    _subscription?.cancel();
    _bookings = const [];
    _isLoading = true;
    _error = null;
    _subscription = _firestore
        .watchBookingsOnDay(_selectedDate)
        .listen(
          (bookings) {
            _bookings = bookings;
            _isLoading = false;
            _error = null;
            _notify();
          },
          onError: (Object error) {
            _isLoading = false;
            _error = FirestoreService.friendlyMessage(error);
            _notify();
          },
        );
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
