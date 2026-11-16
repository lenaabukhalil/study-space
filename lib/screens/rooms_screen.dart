import 'package:flutter/material.dart';

import '../data/sample_rooms.dart';
import '../widgets/room_card.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final rooms = _filter == 'all'
        ? sampleRooms
        : sampleRooms.where((room) => room.type == _filter).toList();

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
                _buildChip('All', 'all'),
                _buildChip('Rooms', 'room'),
                _buildChip('Desks', 'desk'),
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

  Widget _buildChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == value,
      selectedColor: Colors.blue.shade200,
      onSelected: (_) {
        setState(() {
          _filter = value;
        });
      },
    );
  }
}
