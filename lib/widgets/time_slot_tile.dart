import 'package:flutter/material.dart';

class TimeSlotTile extends StatelessWidget {
  final int hour;
  final bool isSelected;
  final bool isPast;
  final bool isBooked;
  final bool isUnavailable;
  final VoidCallback onTap;

  const TimeSlotTile({
    super.key,
    required this.hour,
    required this.isSelected,
    required this.isPast,
    required this.isBooked,
    required this.isUnavailable,
    required this.onTap,
  });

  static String label(int hour) {
    String format(int h) => '${h.toString().padLeft(2, '0')}:00';
    return '${format(hour)} - ${format(hour + 1)}';
  }

  bool get _isDisabled => isPast || isBooked || isUnavailable;

  String? get _caption {
    if (isBooked) {
      return 'Booked';
    }
    if (isUnavailable && !isPast) {
      return 'Too long';
    }
    return null;
  }

  Color _backgroundColor(ColorScheme scheme) {
    if (isBooked) {
      return Colors.red.shade100;
    }
    if (isPast || isUnavailable) {
      return Colors.grey.shade200;
    }
    if (isSelected) {
      return scheme.primary;
    }
    return scheme.primaryContainer.withValues(alpha: 0.5);
  }

  Color _textColor(ColorScheme scheme) {
    if (isBooked) {
      return Colors.red.shade700;
    }
    if (isPast || isUnavailable) {
      return Colors.grey.shade500;
    }
    if (isSelected) {
      return scheme.onPrimary;
    }
    return scheme.onPrimaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = _textColor(scheme);
    final caption = _caption;

    return Material(
      color: _backgroundColor(scheme),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _isDisabled ? null : onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label(hour),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            if (caption != null)
              Text(caption, style: TextStyle(fontSize: 11, color: textColor)),
          ],
        ),
      ),
    );
  }
}
