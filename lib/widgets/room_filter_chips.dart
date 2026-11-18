import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/rooms_provider.dart';

class RoomFilterChips extends StatelessWidget {
  const RoomFilterChips({super.key});

  static const List<(String, String)> _filters = [
    ('All', RoomsProvider.filterAll),
    ('Rooms', 'room'),
    ('Desks', 'desk'),
    ('Favorites', RoomsProvider.filterFavorites),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.select<RoomsProvider, String>((p) => p.filter);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _filters
          .map(
            (filter) => ChoiceChip(
              label: Text(filter.$1),
              avatar: filter.$2 == RoomsProvider.filterFavorites
                  ? const Icon(Icons.favorite_border, size: 18)
                  : null,
              selected: current == filter.$2,
              onSelected: (_) =>
                  context.read<RoomsProvider>().setFilter(filter.$2),
            ),
          )
          .toList(),
    );
  }
}
