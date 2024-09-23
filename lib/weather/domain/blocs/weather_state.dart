part of 'weather_cubit.dart';

enum WeatherStatus { initial, loading, success, failure }

@JsonSerializable()
final class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather weather;
  final TemperatureUnits temperatureUnits;

  WeatherState({
    this.status = WeatherStatus.initial,
    Weather? weather,
    this.temperatureUnits = TemperatureUnits.celsius,
  }) : weather = weather ?? Weather.empty;

  @override
  List<Object> get props => [status, weather, temperatureUnits];

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    TemperatureUnits? temperatureUnits,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      temperatureUnits: temperatureUnits ?? this.temperatureUnits,
    );
  }

  factory WeatherState.fromJson(Map<String, dynamic> json) {
    return _$WeatherStateFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WeatherStateToJson(this);
  }
}
