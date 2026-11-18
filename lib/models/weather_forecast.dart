import 'package:flutter/material.dart';

enum WeatherCondition {
  clear('Clear', Icons.wb_sunny_outlined),
  partlyCloudy('Partly cloudy', Icons.wb_cloudy_outlined),
  cloudy('Cloudy', Icons.cloud_outlined),
  fog('Fog', Icons.foggy),
  drizzle('Drizzle', Icons.grain),
  rain('Rain', Icons.water_drop_outlined),
  snow('Snow', Icons.ac_unit),
  thunderstorm('Thunderstorm', Icons.thunderstorm_outlined),
  unknown('Mixed', Icons.cloud_queue);

  final String label;
  final IconData icon;

  const WeatherCondition(this.label, this.icon);

  static WeatherCondition fromCode(int code) {
    return switch (code) {
      0 => clear,
      1 || 2 => partlyCloudy,
      3 => cloudy,
      45 || 48 => fog,
      >= 51 && <= 57 => drizzle,
      (>= 61 && <= 67) || (>= 80 && <= 82) => rain,
      (>= 71 && <= 77) || 85 || 86 => snow,
      >= 95 && <= 99 => thunderstorm,
      _ => unknown,
    };
  }
}

class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  const WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'] as String);
    return WeatherForecast(
      date: DateTime(date.year, date.month, date.day),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
    );
  }

  static List<WeatherForecast> listFromJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>;
    final dates = daily['time'] as List<dynamic>;
    final codes = daily['weathercode'] as List<dynamic>;
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>;
    final minTemps = daily['temperature_2m_min'] as List<dynamic>;

    return [
      for (var i = 0; i < dates.length; i++)
        if (codes[i] != null && maxTemps[i] != null && minTemps[i] != null)
          WeatherForecast.fromJson({
            'date': dates[i],
            'weatherCode': codes[i],
            'maxTemp': maxTemps[i],
            'minTemp': minTemps[i],
          }),
    ];
  }

  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);

  String get label => condition.label;

  IconData get icon => condition.icon;

  String get temperatureRange => '${maxTemp.round()}° / ${minTemp.round()}°';

  String get summary => '$label · $temperatureRange';
}
