import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../data/sample_rooms.dart';
import '../models/booking.dart';
import '../models/room.dart';

class SlotTakenException implements Exception {
  const SlotTakenException();
}

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _db.collection('rooms');
  CollectionReference<Map<String, dynamic>> get _bookings =>
      _db.collection('bookings');
  CollectionReference<Map<String, dynamic>> get _slots =>
      _db.collection('slots');
  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Future<void> seedRoomsIfEmpty() async {
    final existing = await _rooms.limit(1).get();
    if (existing.docs.isNotEmpty) {
      return;
    }
    final batch = _db.batch();
    for (final room in sampleRooms) {
      batch.set(_rooms.doc(room.id), room.toMap());
    }
    await batch.commit();
  }

  Stream<List<Room>> watchRooms() {
    return _rooms.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Room.fromMap(doc.id, doc.data())).toList(),
    );
  }

  Stream<List<Booking>> watchUserBookings(String uid) {
    return _bookings
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_toBookings)
        .map(
          (bookings) => bookings..sort((a, b) => a.start.compareTo(b.start)),
        );
  }

  Stream<List<Booking>> watchRoomBookingsOnDay(String roomId, DateTime day) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return _bookings
        .where('roomId', isEqualTo: roomId)
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
        .where('start', isLessThan: Timestamp.fromDate(dayEnd))
        .snapshots()
        .map(_toBookings);
  }

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) {
    return _users.doc(uid).set({
      'name': name,
      'email': email,
      'role': 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> createBooking({
    required String roomId,
    required String userId,
    required DateTime start,
    required DateTime end,
    required String paymentMethod,
  }) {
    final bookingRef = _bookings.doc();
    final slotRefs = slotIdsFor(roomId, start, end).map(_slots.doc).toList();
    final booking = Booking(
      id: bookingRef.id,
      roomId: roomId,
      userId: userId,
      start: start,
      end: end,
      createdAt: DateTime.now(),
      paymentMethod: paymentMethod,
    );

    return _db.runTransaction((transaction) async {
      for (final ref in slotRefs) {
        final slot = await transaction.get(ref);
        if (slot.exists) {
          throw const SlotTakenException();
        }
      }
      for (var i = 0; i < slotRefs.length; i++) {
        transaction.set(slotRefs[i], {
          'roomId': roomId,
          'bookingId': bookingRef.id,
          'userId': userId,
          'start': Timestamp.fromDate(start.add(Duration(hours: i))),
        });
      }
      transaction.set(bookingRef, booking.toMap());
      return bookingRef.id;
    });
  }

  Future<void> cancelBooking(Booking booking) {
    final batch = _db.batch();
    batch.delete(_bookings.doc(booking.id));
    for (final id in slotIdsFor(booking.roomId, booking.start, booking.end)) {
      batch.delete(_slots.doc(id));
    }
    return batch.commit();
  }

  static String slotId(String roomId, DateTime hourStart) {
    final day = DateFormat('yyyyMMdd').format(hourStart);
    final hour = hourStart.hour.toString().padLeft(2, '0');
    return '${roomId}_${day}_$hour';
  }

  static List<String> slotIdsFor(String roomId, DateTime start, DateTime end) {
    final hours = end.difference(start).inHours;
    return [
      for (var i = 0; i < hours; i++)
        slotId(roomId, start.add(Duration(hours: i))),
    ];
  }

  static String friendlyMessage(Object error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
          return 'You appear to be offline. Check your connection and try again.';
        case 'deadline-exceeded':
          return 'The connection timed out. Please try again.';
        case 'permission-denied':
          return 'You do not have permission to do this.';
        case 'failed-precondition':
          return 'The database is still being set up. Please try again shortly.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  List<Booking> _toBookings(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => Booking.fromMap(doc.id, doc.data()))
        .toList();
  }
}
