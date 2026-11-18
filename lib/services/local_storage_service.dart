import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _filterKey = 'rooms_filter';
  static const String _durationKey = 'booking_duration';
  static const String _favoritesPrefix = 'favorites_';

  final SharedPreferencesAsync _prefs;

  LocalStorageService({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  String _favoritesKey(String uid) => '$_favoritesPrefix$uid';

  Future<Set<String>> loadFavorites(String uid) async {
    try {
      final ids = await _prefs.getStringList(_favoritesKey(uid));
      return {...?ids};
    } catch (_) {
      return {};
    }
  }

  Future<void> saveFavorites(String uid, Set<String> roomIds) async {
    try {
      await _prefs.setStringList(_favoritesKey(uid), roomIds.toList());
    } catch (_) {}
  }

  Future<String?> loadFilter() async {
    try {
      return await _prefs.getString(_filterKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveFilter(String filter) async {
    try {
      await _prefs.setString(_filterKey, filter);
    } catch (_) {}
  }

  Future<int?> loadDuration() async {
    try {
      return await _prefs.getInt(_durationKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDuration(int hours) async {
    try {
      await _prefs.setInt(_durationKey, hours);
    } catch (_) {}
  }
}
