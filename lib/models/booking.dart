import 'package:cloud_firestore/cloud_firestore.dart';

import 'payment_method.dart';

class Booking {
  final String id;
  final String roomId;
  final String userId;
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final String paymentMethod;
  final String? userName;
  final String? userEmail;

  const Booking({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.paymentMethod,
    this.userName,
    this.userEmail,
  });

  int get durationHours => end.difference(start).inHours;

  factory Booking.fromMap(String id, Map<String, dynamic> map) {
    final start = (map['start'] as Timestamp).toDate();
    return Booking(
      id: id,
      roomId: map['roomId'] as String,
      userId: map['userId'] as String,
      start: start,
      end: (map['end'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? start,
      paymentMethod:
          map['paymentMethod'] as String? ?? PaymentMethods.frontDesk,
      userName: map['userName'] as String?,
      userEmail: map['userEmail'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'userId': userId,
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
      'createdAt': FieldValue.serverTimestamp(),
      'paymentMethod': paymentMethod,
      'userName': userName,
      'userEmail': userEmail,
    };
  }
}
