import 'package:flutter/material.dart';

import 'time_slot_tile.dart';

class TimeSlotGrid extends StatelessWidget {
  final List<int> hours;
  final int? selectedHour;
  final int duration;
  final bool Function(int hour) isPast;
  final bool Function(int hour) isBooked;
  final bool Function(int hour) fitsDuration;
  final ValueChanged<int> onSelect;

  const TimeSlotGrid({
    super.key,
    required this.hours,
    required this.selectedHour,
    required this.duration,
    required this.isPast,
    required this.isBooked,
    required this.fitsDuration,
    required this.onSelect,
  });

  bool _isInRange(int hour) {
    final start = selectedHour;
    return start != null && hour > start && hour < start + duration;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 160,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2,
      children: hours
          .map(
            (hour) => TimeSlotTile(
              hour: hour,
              isSelected: selectedHour == hour,
              isInRange: _isInRange(hour),
              isPast: isPast(hour),
              isBooked: isBooked(hour),
              isUnavailable: !isBooked(hour) && !fitsDuration(hour),
              onTap: () => onSelect(hour),
            ),
          )
          .toList(),
    );
  }
}
