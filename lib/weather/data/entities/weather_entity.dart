import 'package:json_annotation/json_annotation.dart';

part 'weather_entity.g.dart';

@JsonSerializable(createToJson: false)
class WeatherEntity {
  final double? temperature;
  @JsonKey(name: 'weathercode')
  final int? weatherCode;

  const WeatherEntity({
    required this.temperature,
    required this.weatherCode,
  });

  factory WeatherEntity.fromJson(Map<String, dynamic> json) {
    return _$WeatherEntityFromJson(json);
  }
}
