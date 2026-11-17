import 'package:flutter/material.dart';

import '../models/room.dart';
import '../utils/formatters.dart';
import 'amenity_chips.dart';

class RoomInfoHeader extends StatelessWidget {
  final Room room;

  const RoomInfoHeader({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(room.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          Formatters.pricePerHour(room.pricePerHour),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        _InfoRow(
          icon: room.isDesk ? Icons.desk : Icons.meeting_room,
          text: room.isDesk ? 'Desk' : 'Room',
        ),
        _InfoRow(icon: Icons.people, text: Formatters.capacity(room.capacity)),
        const SizedBox(height: 12),
        AmenityChips(amenities: room.amenities),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
