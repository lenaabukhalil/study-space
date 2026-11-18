import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_forecast.dart';

class WeatherException implements Exception {
  final String message;

  const WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
  static const Duration timeout = Duration(seconds: 10);
  static const Duration cacheDuration = Duration(minutes: 30);

  static final Uri _forecastUri = Uri.https(
    'api.open-meteo.com',
    '/v1/forecast',
    {
      'latitude': '31.95',
      'longitude': '35.93',
      'daily': 'weathercode,temperature_2m_max,temperature_2m_min',
      'timezone': 'Asia/Amman',
      'forecast_days': '16',
    },
  );

  final http.Client _client;
  List<WeatherForecast>? _cache;
  DateTime? _cachedAt;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  List<WeatherForecast>? get cachedForecast {
    final cachedAt = _cachedAt;
    if (_cache == null || cachedAt == null) {
      return null;
    }
    if (DateTime.now().difference(cachedAt) > cacheDuration) {
      return null;
    }
    return _cache;
  }

  Future<List<WeatherForecast>> fetchForecast() async {
    final cached = cachedForecast;
    if (cached != null) {
      return cached;
    }

    final http.Response response;
    try {
      response = await _client.get(_forecastUri).timeout(timeout);
    } on TimeoutException {
      throw const WeatherException(
        'The weather service took too long to respond.',
      );
    } on http.ClientException {
      throw const WeatherException(
        'No internet connection. Check your network and try again.',
      );
    } catch (_) {
      throw const WeatherException('Could not reach the weather service.');
    }

    if (response.statusCode != 200) {
      throw WeatherException(
        'The weather service is unavailable (error ${response.statusCode}).',
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final forecasts = WeatherForecast.listFromJson(json);
      _cache = List.unmodifiable(forecasts);
      _cachedAt = DateTime.now();
      return _cache!;
    } catch (_) {
      throw const WeatherException(
        'Received an unexpected response from the weather service.',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
