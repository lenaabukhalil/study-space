import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/room.dart';
import '../services/firestore_service.dart';

class RoomsProvider extends ChangeNotifier {
  final FirestoreService _firestore;
  StreamSubscription<List<Room>>? _subscription;

  String? _userId;
  List<Room> _rooms = const [];
  String _filter = 'all';
  bool _isLoading = true;
  String? _errorMessage;
  bool _disposed = false;

  RoomsProvider(this._firestore);

  String get filter => _filter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Room> get rooms => _rooms;

  List<Room> get filteredRooms {
    if (_filter == 'all') {
      return _rooms;
    }
    return _rooms.where((room) => room.type == _filter).toList();
  }

  void updateUser(String? userId) {
    if (_userId == userId) {
      return;
    }
    _userId = userId;
    _subscription?.cancel();
    _subscription = null;
    _rooms = const [];
    _isLoading = true;
    _errorMessage = null;
    if (userId != null) {
      _subscribe();
    }
  }

  void setFilter(String value) {
    if (_filter == value) {
      return;
    }
    _filter = value;
    _notify();
  }

  Room? roomById(String id) {
    return _rooms.where((room) => room.id == id).firstOrNull;
  }

  void retry() {
    if (_userId == null) {
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    _notify();
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _firestore.watchRooms().listen(
      (rooms) {
        _rooms = rooms;
        _isLoading = false;
        _errorMessage = null;
        _notify();
      },
      onError: (Object error) {
        _isLoading = false;
        _errorMessage = FirestoreService.friendlyMessage(error);
        _notify();
      },
    );
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
