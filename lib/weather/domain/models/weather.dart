import 'package:bloc_tutorial/weather/data/entities/location_entity.dart';
import 'package:bloc_tutorial/weather/data/entities/weather_entity.dart';
import 'package:bloc_tutorial/weather/domain/models/temperature.dart';
import 'package:bloc_tutorial/weather/extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition { clear, rainy, cloudy, snowy, unknown }

@JsonSerializable()
class Weather extends Equatable {
  final String location;
  final Temperature temperature;
  final WeatherCondition condition;
  final DateTime lastUpdated;

  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.lastUpdated,
  });

  static final empty = Weather(
    location: '--',
    temperature: const Temperature(value: 0),
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
  );

  factory Weather.fromEntity(LocationEntity location, WeatherEntity weather) {
    return Weather(
      location: location.name!,
      temperature: Temperature(value: weather.temperature!),
      condition: _getConditionCode(weather.weatherCode),
      lastUpdated: DateTime.now().withoutMilliseconds,
    );
  }

  static WeatherCondition _getConditionCode(int? weatherCode) {
    return switch (weatherCode) {
      0 => WeatherCondition.clear,
      1 || 2 || 3 || 45 || 48 => WeatherCondition.cloudy,
      51 ||
      53 ||
      55 ||
      56 ||
      57 ||
      61 ||
      63 ||
      65 ||
      66 ||
      67 ||
      80 ||
      81 ||
      82 ||
      95 ||
      96 ||
      99 =>
        WeatherCondition.rainy,
      71 || 73 || 75 || 85 || 86 => WeatherCondition.snowy,
      _ => WeatherCondition.unknown,
    };
  }

  @override
  List<Object> get props => [
        location,
        temperature,
        condition,
        lastUpdated,
      ];

  Weather copyWith({
    String? location,
    Temperature? temperature,
    WeatherCondition? condition,
    DateTime? lastUpdated,
  }) {
    return Weather(
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return _$WeatherFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WeatherToJson(this);
  }
}
