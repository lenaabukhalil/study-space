import 'package:flutter/material.dart';

import '../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final isRoom = room.type == 'room';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: isRoom ? Colors.blue.shade100 : Colors.green.shade100,
          child: Icon(
            isRoom ? Icons.meeting_room : Icons.desk,
            color: isRoom ? Colors.blue.shade700 : Colors.green.shade700,
          ),
        ),
        title: Text(
          room.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${isRoom ? 'Room' : 'Desk'} • Capacity: ${room.capacity}',
        ),
        trailing: Icon(
          room.hasProjector ? Icons.videocam : Icons.videocam_off,
          color: room.hasProjector ? Colors.orange : Colors.grey.shade400,
        ),
      ),
    );
  }
}
