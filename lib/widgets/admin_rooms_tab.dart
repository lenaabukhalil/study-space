import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/room.dart';
import '../providers/admin_provider.dart';
import '../providers/rooms_provider.dart';
import '../screens/room_form_screen.dart';
import 'admin_room_tile.dart';
import 'confirm_dialog.dart';
import 'error_state.dart';

class AdminRoomsTab extends StatelessWidget {
  const AdminRoomsTab({super.key});

  void _openForm(BuildContext context, [Room? room]) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => RoomFormScreen(room: room)));
  }

  Future<void> _confirmDelete(BuildContext context, Room room) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete room?',
      message: 'Are you sure you want to delete "${room.name}"?',
      confirmLabel: 'Delete',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    final result = await context.read<AdminProvider>().deleteRoom(room);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.success ? 'Room deleted' : result.errorMessage!),
        backgroundColor: result.success
            ? null
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoomsProvider>();
    final error = provider.errorMessage;
    final rooms = provider.rooms;

    Widget body;
    if (provider.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      body = ErrorState(message: error, onRetry: provider.retry);
    } else if (rooms.isEmpty) {
      body = Center(
        child: Text(
          'No rooms yet',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return AdminRoomTile(
            room: room,
            onEdit: () => _openForm(context, room),
            onDelete: () => _confirmDelete(context, room),
          );
        },
      );
    }

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add room'),
      ),
    );
  }
}
