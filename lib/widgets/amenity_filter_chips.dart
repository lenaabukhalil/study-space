import 'package:flutter/material.dart';

import '../data/amenities.dart';

class AmenityFilterChips extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  const AmenityFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  void _toggle(String amenity, bool isSelected) {
    final next = {...selected};
    if (isSelected) {
      next.add(amenity);
    } else {
      next.remove(amenity);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Amenities.all
          .map(
            (amenity) => FilterChip(
              label: Text(amenity),
              selected: selected.contains(amenity),
              onSelected: (value) => _toggle(amenity, value),
            ),
          )
          .toList(),
    );
  }
}
