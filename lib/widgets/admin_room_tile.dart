import 'package:flutter/material.dart';

import '../models/room.dart';
import '../utils/formatters.dart';
import 'price_text.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Icon(
            room.isDesk ? Icons.desk : Icons.meeting_room_outlined,
            color: scheme.primary,
          ),
        ),
        title: Text(room.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${room.isDesk ? 'Desk' : 'Room'} · '
              '${Formatters.capacity(room.capacity)}',
            ),
            PriceText(text: Formatters.pricePerHour(room.pricePerHour)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: scheme.primary),
              tooltip: 'Edit room',
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: scheme.error),
              tooltip: 'Delete room',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
