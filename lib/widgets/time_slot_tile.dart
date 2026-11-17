import 'package:flutter/material.dart';

class TimeSlotTile extends StatelessWidget {
  final int hour;
  final bool isSelected;
  final bool isPast;
  final bool isBooked;
  final VoidCallback onTap;

  const TimeSlotTile({
    super.key,
    required this.hour,
    required this.isSelected,
    required this.isPast,
    required this.isBooked,
    required this.onTap,
  });

  static String label(int hour) {
    String format(int h) => '${h.toString().padLeft(2, '0')}:00';
    return '${format(hour)} - ${format(hour + 1)}';
  }

  bool get _isDisabled => isPast || isBooked;

  Color get _backgroundColor {
    if (isBooked) {
      return Colors.red.shade100;
    }
    if (isPast) {
      return Colors.grey.shade300;
    }
    if (isSelected) {
      return Colors.blue;
    }
    return Colors.blue.shade50;
  }

  Color get _textColor {
    if (isBooked) {
      return Colors.red.shade700;
    }
    if (isPast) {
      return Colors.grey.shade600;
    }
    if (isSelected) {
      return Colors.white;
    }
    return Colors.blue.shade900;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _isDisabled ? null : onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label(hour),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
            if (isBooked)
              Text(
                'Booked',
                style: TextStyle(fontSize: 11, color: _textColor),
              ),
          ],
        ),
      ),
    );
  }
}
