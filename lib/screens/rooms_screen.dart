import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/rooms_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/room_card.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  static const double _maxContentWidth = 1100;
  static const double _gutter = 16;
  static const double _cardHeight = 330;

  int _columnsFor(double width) {
    if (width < 600) {
      return 1;
    }
    if (width < 900) {
      return 2;
    }
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<RoomsProvider>().filteredRooms;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(
              constraints.maxWidth,
              _maxContentWidth,
            );
            final sidePadding = math.max(
              _gutter,
              (constraints.maxWidth - _maxContentWidth) / 2 + _gutter,
            );
            final padding = EdgeInsets.symmetric(horizontal: sidePadding);

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: padding.copyWith(top: 24, bottom: 12),
                  sliver: const SliverToBoxAdapter(child: GreetingHeader()),
                ),
                SliverPadding(
                  padding: padding.copyWith(bottom: 12),
                  sliver: const SliverToBoxAdapter(child: _FilterChips()),
                ),
                SliverPadding(
                  padding: padding.copyWith(bottom: 24),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _columnsFor(contentWidth),
                      mainAxisExtent: _cardHeight,
                      mainAxisSpacing: _gutter,
                      crossAxisSpacing: _gutter,
                    ),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) =>
                        RoomCard(room: rooms[index]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  static const List<(String, String)> _filters = [
    ('All', 'all'),
    ('Rooms', 'room'),
    ('Desks', 'desk'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.select<RoomsProvider, String>((p) => p.filter);

    return Wrap(
      spacing: 8,
      children: _filters
          .map(
            (filter) => ChoiceChip(
              label: Text(filter.$1),
              selected: current == filter.$2,
              onSelected: (_) =>
                  context.read<RoomsProvider>().setFilter(filter.$2),
            ),
          )
          .toList(),
    );
  }
}
