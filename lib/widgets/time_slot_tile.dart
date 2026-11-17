import 'package:flutter/material.dart';

class TimeSlotTile extends StatelessWidget {
  final int hour;
  final bool isSelected;
  final bool isInRange;
  final bool isPast;
  final bool isBooked;
  final bool isUnavailable;
  final VoidCallback onTap;

  const TimeSlotTile({
    super.key,
    required this.hour,
    required this.isSelected,
    required this.isInRange,
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
    if (isSelected) {
      return scheme.primary;
    }
    if (isInRange) {
      return Color.alphaBlend(
        scheme.primary.withValues(alpha: 0.35),
        scheme.surface,
      );
    }
    if (isBooked) {
      return scheme.errorContainer;
    }
    if (isPast || isUnavailable) {
      return scheme.surfaceContainerHighest;
    }
    return scheme.primaryContainer.withValues(alpha: 0.5);
  }

  Color _textColor(ColorScheme scheme, Color background) {
    if (isSelected || isInRange) {
      final isDark =
          ThemeData.estimateBrightnessForColor(background) == Brightness.dark;
      return isDark ? scheme.onPrimary : scheme.onPrimaryContainer;
    }
    if (isBooked) {
      return scheme.onErrorContainer;
    }
    if (isPast || isUnavailable) {
      return scheme.onSurface.withValues(alpha: 0.38);
    }
    return scheme.onPrimaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = _backgroundColor(scheme);
    final textColor = _textColor(scheme, background);
    final caption = _caption;

    return Material(
      color: background,
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
