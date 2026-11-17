import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/space_info.dart';
import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_confirmation_sheet.dart';
import '../widgets/booking_policy_dialog.dart';
import '../widgets/booking_success_dialog.dart';
import '../widgets/date_selector.dart';
import '../widgets/duration_dropdown.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_button.dart';
import '../widgets/no_slots_notice.dart';
import '../widgets/room_image.dart';
import '../widgets/room_info_header.dart';
import '../widgets/selection_summary.dart';
import '../widgets/time_slot_grid.dart';

class RoomDetailsScreen extends StatefulWidget {
  final Room room;

  const RoomDetailsScreen({super.key, required this.room});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  late final BookingProvider _bookings;
  late DateTime _selectedDate;
  int? _selectedHour;
  int _duration = 1;

  @override
  void initState() {
    super.initState();
    _selectedDate = _today();
    _bookings = context.read<BookingProvider>();
    _bookings.watchRoomDay(widget.room.id, _selectedDate);
  }

  @override
  void dispose() {
    _bookings.stopWatchingRoomDay();
    super.dispose();
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isPast(int hour) {
    return _selectedDate == _today() && hour <= DateTime.now().hour;
  }

  bool _fits(int startHour, Set<int> bookedHours) {
    final closeHour = OpeningHours.forDate(_selectedDate).closeHour;
    if (startHour + _duration > closeHour) {
      return false;
    }
    for (var hour = startHour; hour < startHour + _duration; hour++) {
      if (bookedHours.contains(hour)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _pickDate() async {
    final today = _today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 14)),
    );
    if (picked != null && picked != _selectedDate) {
      _bookings.watchRoomDay(widget.room.id, picked);
      setState(() {
        _selectedDate = picked;
        _selectedHour = null;
      });
    }
  }

  void _changeDuration(int duration) {
    final booked = _bookings.bookedHours;
    setState(() {
      _duration = duration;
      final selected = _selectedHour;
      if (selected != null && !_fits(selected, booked)) {
        _selectedHour = null;
      }
    });
  }

  void _toggleSlot(int hour) {
    setState(() {
      _selectedHour = _selectedHour == hour ? null : hour;
    });
  }

  Future<void> _book() async {
    final room = widget.room;
    final start = _selectedDate.add(Duration(hours: _selectedHour!));
    final end = start.add(Duration(hours: _duration));

    final paymentMethod = await BookingConfirmationSheet.show(
      context,
      room: room,
      start: start,
      end: end,
    );
    if (paymentMethod == null || !mounted) {
      return;
    }

    final result = await _bookings.addBooking(
      roomId: room.id,
      start: start,
      end: end,
      paymentMethod: paymentMethod,
    );
    if (!mounted) {
      return;
    }

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _selectedHour = null;
    });
    await BookingSuccessDialog.show(
      context,
      roomName: room.name,
      start: start,
      end: end,
      total: room.pricePerHour * _duration,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Booking policy',
            onPressed: () => BookingPolicyDialog.show(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
              RoomImage(imagePath: room.imagePath, height: 240),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoomInfoHeader(room: room),
                    const SizedBox(height: 24),
                    DateSelector(date: _selectedDate, onChange: _pickDate),
                    const SizedBox(height: 16),
                    DurationDropdown(
                      value: _duration,
                      onChanged: _changeDuration,
                    ),
                    if (_selectedHour != null) ...[
                      const SizedBox(height: 12),
                      SelectionSummary(
                        start: _selectedDate.add(
                          Duration(hours: _selectedHour!),
                        ),
                        duration: _duration,
                        pricePerHour: room.pricePerHour,
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildSlots(provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LoadingButton(
            label: 'Book',
            isLoading: provider.isSubmitting,
            onPressed: _selectedHour == null ? null : _book,
          ),
        ),
      ),
    );
  }

  Widget _buildSlots(BookingProvider provider) {
    final error = provider.roomDayError;
    if (provider.isLoadingRoomDay) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return ErrorState(message: error, onRetry: provider.retryRoomDay);
    }
    final bookedHours = provider.bookedHours;
    final hours = OpeningHours.forDate(_selectedDate).slotHours;
    final hasAvailable = hours.any(
      (hour) => !_isPast(hour) && _fits(hour, bookedHours),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!hasAvailable) ...[
          NoSlotsNotice(onPickDate: _pickDate),
          const SizedBox(height: 12),
        ],
        TimeSlotGrid(
          hours: hours,
          selectedHour: _selectedHour,
          duration: _duration,
          isPast: _isPast,
          isBooked: bookedHours.contains,
          fitsDuration: (hour) => _fits(hour, bookedHours),
          onSelect: _toggleSlot,
        ),
      ],
    );
  }
}
