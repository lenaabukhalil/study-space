import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/rooms_provider.dart';
import '../widgets/room_card.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomsProvider = context.watch<RoomsProvider>();
    final rooms = roomsProvider.filteredRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudySpace'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                _buildChip(context, roomsProvider.filter, 'All', 'all'),
                _buildChip(context, roomsProvider.filter, 'Rooms', 'room'),
                _buildChip(context, roomsProvider.filter, 'Desks', 'desk'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) => RoomCard(room: rooms[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String currentFilter,
    String label,
    String value,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: currentFilter == value,
      selectedColor: Colors.blue.shade200,
      onSelected: (_) => context.read<RoomsProvider>().setFilter(value),
    );
  }
}
