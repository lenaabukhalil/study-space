import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class DurationDropdown extends StatelessWidget {
  static const List<int> options = [1, 2, 3];

  final int value;
  final ValueChanged<int> onChanged;

  const DurationDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Duration',
        prefixIcon: Icon(Icons.hourglass_bottom),
      ),
      items: options
          .map(
            (hours) => DropdownMenuItem(
              value: hours,
              child: Text(Formatters.hours(hours)),
            ),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) {
          onChanged(selected);
        }
      },
    );
  }
}
