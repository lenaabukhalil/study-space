import 'package:flutter/material.dart';

import '../models/room.dart';
import '../utils/formatters.dart';
import 'amenity_chips.dart';
import 'price_text.dart';

class RoomInfoHeader extends StatelessWidget {
  final Room room;

  const RoomInfoHeader({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(room.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        PriceText(
          text: Formatters.pricePerHour(room.pricePerHour),
          large: true,
        ),
        const SizedBox(height: 12),
        _InfoRow(
          icon: room.isDesk ? Icons.desk : Icons.meeting_room_outlined,
          text: room.isDesk ? 'Desk' : 'Room',
        ),
        const SizedBox(height: 8),
        _InfoRow(
          icon: Icons.people_outline,
          text: Formatters.capacity(room.capacity),
        ),
        const SizedBox(height: 16),
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
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, size: 20, color: muted),
        const SizedBox(width: 8),
        Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: muted)),
      ],
    );
  }
}
