import 'package:flutter/foundation.dart';

import '../models/weather_forecast.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service;

  List<WeatherForecast> _forecasts = const [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;

  WeatherProvider(this._service);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  WeatherForecast? forecastFor(DateTime date) {
    return _forecasts
        .where(
          (forecast) =>
              forecast.date.year == date.year &&
              forecast.date.month == date.month &&
              forecast.date.day == date.day,
        )
        .firstOrNull;
  }

  Future<void> load() async {
    if (_isLoading) {
      return;
    }
    final cached = _service.cachedForecast;
    if (cached != null) {
      if (!identical(cached, _forecasts) || _errorMessage != null) {
        _forecasts = cached;
        _errorMessage = null;
        _notify();
      }
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _notify();
    try {
      _forecasts = await _service.fetchForecast();
    } on WeatherException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  Future<void> retry() => load();

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _service.dispose();
    super.dispose();
  }
}
