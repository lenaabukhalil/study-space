import 'package:flutter/foundation.dart';

import '../services/local_storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final LocalStorageService _storage;

  String? _userId;
  Set<String> _roomIds = const {};
  bool _disposed = false;

  FavoritesProvider(this._storage);

  Set<String> get roomIds => _roomIds;

  bool isFavorite(String roomId) => _roomIds.contains(roomId);

  void updateUser(String? userId) {
    if (_userId == userId) {
      return;
    }
    _userId = userId;
    _roomIds = const {};
    if (userId != null) {
      _load(userId);
    }
  }

  Future<void> toggle(String roomId) async {
    final userId = _userId;
    if (userId == null) {
      return;
    }
    final updated = {..._roomIds};
    if (!updated.remove(roomId)) {
      updated.add(roomId);
    }
    _roomIds = Set.unmodifiable(updated);
    _notify();
    await _storage.saveFavorites(userId, _roomIds);
  }

  Future<void> _load(String userId) async {
    final ids = await _storage.loadFavorites(userId);
    if (_userId != userId) {
      return;
    }
    _roomIds = Set.unmodifiable(ids);
    _notify();
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
