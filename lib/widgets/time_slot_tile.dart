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

  (Color, Color, Color?) _colors(ColorScheme scheme) {
    if (isSelected) {
      return (scheme.primary, scheme.onPrimary, null);
    }
    if (isInRange) {
      return (scheme.primaryContainer, scheme.onPrimaryContainer, null);
    }
    if (isBooked) {
      return (scheme.errorContainer, scheme.onErrorContainer, null);
    }
    if (isPast || isUnavailable) {
      return (
        scheme.surfaceContainerHighest,
        scheme.onSurface.withValues(alpha: 0.38),
        null,
      );
    }
    return (scheme.surface, scheme.onSurface, scheme.outline);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (background, foreground, border) = _colors(theme.colorScheme);
    final caption = _caption;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: border == null ? BorderSide.none : BorderSide(color: border),
    );

    return Material(
      color: background,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: _isDisabled ? null : onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label(hour),
              style: theme.textTheme.labelLarge?.copyWith(color: foreground),
            ),
            if (caption != null)
              Text(
                caption,
                style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
              ),
          ],
        ),
      ),
    );
  }
}
