import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/room_images.dart';
import '../models/room.dart';
import '../providers/admin_provider.dart';
import '../theme/app_layout.dart';
import '../utils/validators.dart';
import '../widgets/amenity_filter_chips.dart';
import '../widgets/content_width.dart';
import '../widgets/loading_button.dart';

class RoomFormScreen extends StatefulWidget {
  final Room? room;

  const RoomFormScreen({super.key, this.room});

  @override
  State<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends State<RoomFormScreen> {
  static const List<(String, String)> _types = [
    ('room', 'Room'),
    ('desk', 'Desk'),
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _capacityController;
  late final TextEditingController _priceController;
  late String _type;
  late String _imagePath;
  late Set<String> _amenities;

  bool get _isNew => widget.room == null;

  List<String> get _imageOptions {
    return {...RoomImages.all, _imagePath}.toList();
  }

  @override
  void initState() {
    super.initState();
    final room = widget.room;
    _nameController = TextEditingController(text: room?.name ?? '');
    _capacityController = TextEditingController(
      text: room?.capacity.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: room == null ? '' : _formatPrice(room.pricePerHour),
    );
    _type = room?.type ?? 'room';
    _imagePath = (room?.imagePath.isNotEmpty ?? false)
        ? room!.imagePath
        : RoomImages.all.first;
    _amenities = {...?room?.amenities};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    return price == price.roundToDouble()
        ? price.toInt().toString()
        : price.toString();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final room = Room(
      id: widget.room?.id ?? '',
      name: _nameController.text.trim(),
      type: _type,
      capacity: int.parse(_capacityController.text.trim()),
      pricePerHour: double.parse(_priceController.text.trim()),
      amenities: _amenities.toList(),
      imagePath: _imagePath,
    );
    final result = await context.read<AdminProvider>().saveRoom(
      room,
      isNew: _isNew,
    );
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    if (!result.success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(result.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(content: Text(_isNew ? 'Room added' : 'Room updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<AdminProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: Text(_isNew ? 'Add room' : 'Edit room')),
      body: ContentWidth(
        maxWidth: AppLayout.formMaxWidth,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: (value) => Validators.required(value, 'a name'),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _types
                    .map(
                      (type) => DropdownMenuItem(
                        value: type.$1,
                        child: Text(type.$2),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _type = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                validator: Validators.positiveInt,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  prefixIcon: Icon(Icons.people),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: Validators.positiveNumber,
                decoration: const InputDecoration(
                  labelText: 'Price per hour (JD)',
                  prefixIcon: Icon(Icons.payments),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _imagePath,
                decoration: const InputDecoration(
                  labelText: 'Image',
                  prefixIcon: Icon(Icons.image),
                ),
                items: _imageOptions
                    .map(
                      (path) => DropdownMenuItem(
                        value: path,
                        child: Text(RoomImages.label(path)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _imagePath = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              Text('Amenities', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              AmenityFilterChips(
                selected: _amenities,
                onChanged: (value) => setState(() => _amenities = value),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ContentWidth(
            maxWidth: AppLayout.formMaxWidth,
            child: LoadingButton(
              label: _isNew ? 'Add room' : 'Save changes',
              isLoading: isSaving,
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }
}
