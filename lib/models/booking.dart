import 'payment_method.dart';

class Booking {
  final String id;
  final String roomId;
  final String userId;
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final String paymentMethod;

  const Booking({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.paymentMethod,
  });

  int get durationHours => end.difference(start).inHours;

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as String,
      roomId: map['roomId'] as String,
      userId: map['userId'] as String,
      start: DateTime.parse(map['start'] as String),
      end: DateTime.parse(map['end'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      paymentMethod:
          map['paymentMethod'] as String? ?? PaymentMethods.frontDesk,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }
}
