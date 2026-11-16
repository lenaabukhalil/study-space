import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/room.dart';
import '../widgets/room_image.dart';
import '../widgets/time_slot_tile.dart';

class RoomDetailsScreen extends StatefulWidget {
  final Room room;

  const RoomDetailsScreen({super.key, required this.room});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  static const int _firstHour = 8;
  static const int _lastHour = 20;

  late DateTime _selectedDate;
  int? _selectedHour;

  @override
  void initState() {
    super.initState();
    _selectedDate = _today();
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isPast(int hour) {
    return _selectedDate == _today() && hour <= DateTime.now().hour;
  }

  Future<void> _pickDate() async {
    final today = _today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 14)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedHour = null;
      });
    }
  }

  void _toggleSlot(int hour) {
    setState(() {
      _selectedHour = _selectedHour == hour ? null : hour;
    });
  }

  void _book() {
    final date = DateFormat('EEE, d MMM yyyy').format(_selectedDate);
    final time = TimeSlotTile.label(_selectedHour!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.room.name} • $date • $time')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView(
        children: [
          RoomImage(imageUrl: room.imageUrl, height: 220),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfo(room),
                const SizedBox(height: 24),
                _buildDateSelector(),
                const SizedBox(height: 16),
                _buildSlotGrid(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _selectedHour == null ? null : _book,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Book'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(Room room) {
    final isRoom = room.type == 'room';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          isRoom ? Icons.meeting_room : Icons.desk,
          isRoom ? 'Room' : 'Desk',
        ),
        _buildInfoRow(Icons.people, 'Capacity: ${room.capacity}'),
        _buildInfoRow(
          room.hasProjector ? Icons.videocam : Icons.videocam_off,
          room.hasProjector ? 'Projector available' : 'No projector',
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        Expanded(
          child: Text(
            DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.calendar_today, size: 18),
          label: const Text('Change'),
        ),
      ],
    );
  }

  Widget _buildSlotGrid() {
    final hours = List.generate(
      _lastHour - _firstHour,
      (index) => _firstHour + index,
    );

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: hours
          .map(
            (hour) => TimeSlotTile(
              hour: hour,
              isSelected: _selectedHour == hour,
              isDisabled: _isPast(hour),
              onTap: () => _toggleSlot(hour),
            ),
          )
          .toList(),
    );
  }
}
