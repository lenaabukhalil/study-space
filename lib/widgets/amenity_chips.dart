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
      spacing: 6,
      runSpacing: 6,
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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: scheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}
