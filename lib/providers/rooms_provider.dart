import 'package:flutter/foundation.dart';

import '../data/sample_rooms.dart';
import '../models/room.dart';

class RoomsProvider extends ChangeNotifier {
  final List<Room> _rooms = sampleRooms;
  String _filter = 'all';

  String get filter => _filter;

  List<Room> get filteredRooms {
    if (_filter == 'all') {
      return _rooms;
    }
    return _rooms.where((room) => room.type == _filter).toList();
  }

  void setFilter(String value) {
    if (_filter == value) {
      return;
    }
    _filter = value;
    notifyListeners();
  }

  Room? roomById(String id) {
    return _rooms.where((room) => room.id == id).firstOrNull;
  }
}
