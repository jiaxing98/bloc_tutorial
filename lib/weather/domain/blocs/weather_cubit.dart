import 'package:bloc_tutorial/weather/domain/models/temperature.dart';
import 'package:bloc_tutorial/weather/domain/models/weather.dart';
import 'package:bloc_tutorial/weather/domain/repositories/weather_repository.dart';
import 'package:bloc_tutorial/weather/extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_cubit.g.dart';
part 'weather_state.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherCubit({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherState());

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = await _weatherRepository.getWeather(city);
      final units = state.temperatureUnits;
      final value =
          units.isFahrenheit ? weather.temperature.value.toFahrenheit() : weather.temperature.value;

      emit(
        state.copyWith(
            status: WeatherStatus.success,
            temperatureUnits: units,
            weather: weather.copyWith(temperature: Temperature(value: value))),
      );
    } on Exception catch (ex) {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weather == Weather.empty) return;

    try {
      final weather = await _weatherRepository.getWeather(state.weather.location);
      final units = state.temperatureUnits;
      final value =
          units.isFahrenheit ? weather.temperature.value.toFahrenheit() : weather.temperature.value;

      emit(
        state.copyWith(
            status: WeatherStatus.success,
            temperatureUnits: units,
            weather: weather.copyWith(temperature: Temperature(value: value))),
      );
    } on Exception catch (ex) {
      emit(state);
    }
  }

  void toggleUnits() {
    final units = state.temperatureUnits.isFahrenheit
        ? TemperatureUnits.celsius
        : TemperatureUnits.fahrenheit;

    if (!state.status.isSuccess) {
      emit(state.copyWith(temperatureUnits: units));
      return;
    }

    final weather = state.weather;
    if (weather != Weather.empty) {
      final temperature = weather.temperature;
      final value =
          units.isCelsius ? temperature.value.toCelsius() : temperature.value.toFahrenheit();

      emit(
        state.copyWith(
            temperatureUnits: units,
            weather: weather.copyWith(temperature: Temperature(value: value))),
      );
    }
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    return WeatherState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    return state.toJson();
  }
}
