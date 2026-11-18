import 'package:flutter/material.dart';

class AmenityChips extends StatelessWidget {
  final List<String> amenities;
  final int? maxCount;

  const AmenityChips({super.key, required this.amenities, this.maxCount});

  static const Map<String, IconData> _icons = {
    'Wi-Fi': Icons.wifi,
    'AC': Icons.ac_unit,
    'Whiteboard': Icons.edit_note,
    'Screen': Icons.tv,
    'Coffee': Icons.coffee,
    'Quiet Zone': Icons.volume_off,
  };

  @override
  Widget build(BuildContext context) {
    final visible = maxCount == null
        ? amenities
        : amenities.take(maxCount!).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: visible
          .map(
            (amenity) => _AmenityChip(
              label: amenity,
              icon: _icons[amenity] ?? Icons.check,
            ),
          )
          .toList(),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AmenityChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: muted),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
