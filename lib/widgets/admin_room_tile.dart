import 'package:flutter/material.dart';

import '../models/room.dart';
import '../utils/formatters.dart';

class AdminRoomTile extends StatelessWidget {
  final Room room;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminRoomTile({
    super.key,
    required this.room,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.secondaryContainer,
          child: Icon(
            room.isDesk ? Icons.desk : Icons.meeting_room,
            color: scheme.primary,
          ),
        ),
        title: Text(
          room.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${room.isDesk ? 'Desk' : 'Room'} · '
          '${Formatters.capacity(room.capacity)} · '
          '${Formatters.pricePerHour(room.pricePerHour)}',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: scheme.primary),
              tooltip: 'Edit room',
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: scheme.error),
              tooltip: 'Delete room',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
