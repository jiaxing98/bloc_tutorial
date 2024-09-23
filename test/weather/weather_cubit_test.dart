import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_tutorial/weather/domain/blocs/weather_cubit.dart';
import 'package:bloc_tutorial/weather/domain/models/temperature.dart';
import 'package:bloc_tutorial/weather/domain/models/weather.dart';
import 'package:bloc_tutorial/weather/domain/repositories/weather_repository.dart';
import 'package:bloc_tutorial/weather/extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/hydrated_bloc.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeather extends Mock implements Weather {
  @override
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
}

void main() {
  const weatherLocation = 'London';
  const weatherCondition = WeatherCondition.rainy;
  const weatherTemperature = 9.8;

  late MockWeatherRepository weatherRepository;
  late WeatherCubit sut;
  late Weather weather;

  initHydratedStorage();

  setUp(() {
    weatherRepository = MockWeatherRepository();
    sut = WeatherCubit(weatherRepository: weatherRepository);
    weather = MockWeather();

    when(() => weather.location).thenReturn(weatherLocation);
    when(() => weather.condition).thenReturn(weatherCondition);
    when(() => weather.temperature).thenReturn(const Temperature(value: weatherTemperature));
    when(() => weather.lastUpdated).thenReturn(DateTime.now().withoutMilliseconds);
    when(() => weatherRepository.getWeather(any())).thenAnswer((_) async => weather);
  });

  group("fetchWeather", () {
    blocTest<WeatherCubit, WeatherState>(
      'emits nothing when city is null',
      build: () => sut,
      act: (cubit) {
        cubit.fetchWeather(null);
      },
      expect: () => <WeatherState>[],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits nothing when city is empty',
      build: () => sut,
      act: (cubit) {
        cubit.fetchWeather("");
      },
      expect: () => <WeatherState>[],
    );

    blocTest<WeatherCubit, WeatherState>(
      'calls getWeather with correct city',
      build: () => sut,
      act: (cubit) {
        cubit.fetchWeather(weatherLocation);
      },
      verify: (_) {
        verify(() => weatherRepository.getWeather(weatherLocation)).called(1);
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, failure] when getWeather throws',
      setUp: () {
        when(() => weatherRepository.getWeather(any())).thenThrow(Exception());
      },
      build: () => sut,
      act: (cubit) {
        cubit.fetchWeather(weatherLocation);
      },
      expect: () => [
        WeatherState(status: WeatherStatus.loading),
        WeatherState(status: WeatherStatus.failure),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, success] when getWeather returns (celsius)',
      build: () => sut,
      act: (cubit) => cubit.fetchWeather(weatherLocation),
      expect: () => [
        WeatherState(status: WeatherStatus.loading),
        isA<WeatherState>()
            .having((w) => w.status, 'status', WeatherStatus.success) //
            .having(
              (w) => w.weather,
              'weather',
              isA<Weather>()
                  .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                  .having((w) => w.condition, 'condition', weatherCondition)
                  .having(
                    (w) => w.temperature,
                    'temperature',
                    const Temperature(value: weatherTemperature),
                  )
                  .having((w) => w.location, 'location', weatherLocation),
            ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, success] when getWeather returns (fahrenheit)',
      build: () => sut,
      seed: () => WeatherState(temperatureUnits: TemperatureUnits.fahrenheit),
      act: (cubit) => cubit.fetchWeather(weatherLocation),
      expect: () => [
        WeatherState(
          status: WeatherStatus.loading,
          temperatureUnits: TemperatureUnits.fahrenheit,
        ),
        isA<WeatherState>()
            .having((w) => w.status, 'status', WeatherStatus.success) //
            .having(
              (w) => w.weather,
              'weather',
              isA<Weather>()
                  .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                  .having((w) => w.condition, 'condition', weatherCondition)
                  .having(
                    (w) => w.temperature,
                    'temperature',
                    Temperature(value: weatherTemperature.toFahrenheit()),
                  )
                  .having((w) => w.location, 'location', weatherLocation),
            ),
      ],
    );
  });

  group("refreshWeather", () {
    blocTest<WeatherCubit, WeatherState>(
      'emits nothing when status is not success',
      build: () => sut,
      act: (cubit) => cubit.refreshWeather(),
      expect: () => <WeatherState>[],
      verify: (_) {
        verifyNever(() => weatherRepository.getWeather(any()));
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits nothing when location is null',
      build: () => sut,
      seed: () => WeatherState(status: WeatherStatus.success),
      act: (cubit) => cubit.refreshWeather(),
      expect: () => <WeatherState>[],
      verify: (_) {
        verifyNever(() => weatherRepository.getWeather(any()));
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'invokes getWeather with correct location',
      build: () => sut,
      seed: () => WeatherState(
        status: WeatherStatus.success,
        weather: Weather(
          location: weatherLocation,
          temperature: const Temperature(value: weatherTemperature),
          lastUpdated: DateTime(2020),
          condition: weatherCondition,
        ),
      ),
      act: (cubit) => cubit.refreshWeather(),
      verify: (_) {
        verify(() => weatherRepository.getWeather(weatherLocation)).called(1);
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits nothing when exception is thrown',
      setUp: () {
        when(
          () => weatherRepository.getWeather(any()),
        ).thenThrow(Exception('oops'));
      },
      build: () => sut,
      seed: () => WeatherState(
        status: WeatherStatus.success,
        weather: Weather(
          location: weatherLocation,
          temperature: const Temperature(value: weatherTemperature),
          lastUpdated: DateTime(2020),
          condition: weatherCondition,
        ),
      ),
      act: (cubit) => cubit.refreshWeather(),
      expect: () => <WeatherState>[],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits updated weather (celsius)',
      build: () => sut,
      seed: () => WeatherState(
        status: WeatherStatus.success,
        weather: Weather(
          location: weatherLocation,
          temperature: const Temperature(value: 0),
          lastUpdated: DateTime(2020),
          condition: weatherCondition,
        ),
      ),
      act: (cubit) => cubit.refreshWeather(),
      expect: () => <Matcher>[
        isA<WeatherState>()
            .having((w) => w.status, 'status', WeatherStatus.success) //
            .having(
              (w) => w.weather,
              'weather',
              isA<Weather>()
                  .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                  .having((w) => w.condition, 'condition', weatherCondition)
                  .having(
                    (w) => w.temperature,
                    'temperature',
                    const Temperature(value: weatherTemperature),
                  )
                  .having((w) => w.location, 'location', weatherLocation),
            ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits updated weather (fahrenheit)',
      build: () => sut,
      seed: () => WeatherState(
        temperatureUnits: TemperatureUnits.fahrenheit,
        status: WeatherStatus.success,
        weather: Weather(
          location: weatherLocation,
          temperature: const Temperature(value: 0),
          lastUpdated: DateTime(2020),
          condition: weatherCondition,
        ),
      ),
      act: (cubit) => cubit.refreshWeather(),
      expect: () => <Matcher>[
        isA<WeatherState>()
            .having((w) => w.status, 'status', WeatherStatus.success) //
            .having(
              (w) => w.weather,
              'weather',
              isA<Weather>()
                  .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                  .having((w) => w.condition, 'condition', weatherCondition)
                  .having(
                    (w) => w.temperature,
                    'temperature',
                    Temperature(value: weatherTemperature.toFahrenheit()),
                  )
                  .having((w) => w.location, 'location', weatherLocation),
            ),
      ],
    );
  });

  group('toggleUnits', () {
    blocTest<WeatherCubit, WeatherState>(
      'emits updated units when status is not success',
      build: () => sut,
      act: (cubit) => cubit.toggleUnits(),
      expect: () => <WeatherState>[
        WeatherState(temperatureUnits: TemperatureUnits.fahrenheit),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits updated units and temperature when status is success (celsius)',
      build: () => sut,
      seed: () => WeatherState(
        status: WeatherStatus.success,
        temperatureUnits: TemperatureUnits.fahrenheit,
        weather: Weather(
          location: weatherLocation,
          temperature: const Temperature(value: weatherTemperature),
          lastUpdated: DateTime(2020),
          condition: WeatherCondition.rainy,
        ),
      ),
      act: (cubit) => cubit.toggleUnits(),
      expect: () => <WeatherState>[
        WeatherState(
          status: WeatherStatus.success,
          weather: Weather(
            location: weatherLocation,
            temperature: Temperature(value: weatherTemperature.toCelsius()),
            lastUpdated: DateTime(2020),
            condition: WeatherCondition.rainy,
          ),
        ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits updated units and temperature when status is success (fahrenheit)',
      build: () => sut,
      seed: () => WeatherState(
        status: WeatherStatus.success,
        weather: Weather(
          location: weatherLocation,
          temperature: const Temperature(value: weatherTemperature),
          lastUpdated: DateTime(2020),
          condition: WeatherCondition.rainy,
        ),
      ),
      act: (cubit) => cubit.toggleUnits(),
      expect: () => <WeatherState>[
        WeatherState(
          status: WeatherStatus.success,
          temperatureUnits: TemperatureUnits.fahrenheit,
          weather: Weather(
            location: weatherLocation,
            temperature: Temperature(
              value: weatherTemperature.toFahrenheit(),
            ),
            lastUpdated: DateTime(2020),
            condition: WeatherCondition.rainy,
          ),
        ),
      ],
    );
  });
}
