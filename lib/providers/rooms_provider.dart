import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/room.dart';
import '../services/firestore_service.dart';

class RoomsProvider extends ChangeNotifier {
  final FirestoreService _firestore;
  StreamSubscription<List<Room>>? _subscription;

  List<Room> _rooms = const [];
  String _filter = 'all';
  bool _isLoading = true;
  String? _errorMessage;

  RoomsProvider(this._firestore) {
    _subscribe();
  }

  String get filter => _filter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

  void retry() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _firestore.watchRooms().listen(
      (rooms) {
        _rooms = rooms;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object error) {
        _isLoading = false;
        _errorMessage = FirestoreService.friendlyMessage(error);
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
