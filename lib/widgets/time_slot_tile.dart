import 'package:flutter/material.dart';

class TimeSlotTile extends StatelessWidget {
  final int hour;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const TimeSlotTile({
    super.key,
    required this.hour,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  static String label(int hour) {
    String format(int h) => '${h.toString().padLeft(2, '0')}:00';
    return '${format(hour)} - ${format(hour + 1)}';
  }

  Color get _backgroundColor {
    if (isDisabled) {
      return Colors.grey.shade300;
    }
    if (isSelected) {
      return Colors.blue;
    }
    return Colors.blue.shade50;
  }

  Color get _textColor {
    if (isDisabled) {
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
        onTap: isDisabled ? null : onTap,
        child: Center(
          child: Text(
            label(hour),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}
