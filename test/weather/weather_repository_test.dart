import 'package:bloc_tutorial/weather/data/data_sources/weather_data_source.dart';
import 'package:bloc_tutorial/weather/data/entities/location_entity.dart';
import 'package:bloc_tutorial/weather/data/entities/weather_entity.dart';
import 'package:bloc_tutorial/weather/domain/models/temperature.dart';
import 'package:bloc_tutorial/weather/domain/models/weather.dart';
import 'package:bloc_tutorial/weather/domain/repositories/weather_repository.dart';
import 'package:bloc_tutorial/weather/extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherDataSource extends Mock implements WeatherDataSource {}

class MockLocationEntity extends Mock implements LocationEntity {}

class MockWeatherEntity extends Mock implements WeatherEntity {}

void main() {
  late WeatherDataSource weatherDS;
  late WeatherRepository sut;

  setUp(() {
    weatherDS = MockWeatherDataSource();
    sut = WeatherRepositoryImpl(weatherDS: weatherDS);
  });

  group("getWeather", () {
    const city = "chicago";
    const latitude = 41.85003;
    const longitude = -87.65005;

    test("calls locationSearch with correct city", () async {
      // act
      try {
        await sut.getWeather(city);
      } catch (ex) {}

      // assert
      verify(() => weatherDS.locationSearch(city)).called(1);
    });

    test("throws when locationSearch fails", () async {
      // assign
      final exception = Exception();
      when(() => weatherDS.locationSearch(any())).thenThrow(exception);

      // act & assert
      expect(() async => sut.getWeather(city), throwsA(exception));
    });

    test("calls getWeather with correct latitude/longitude", () async {
      // assign
      final location = MockLocationEntity();

      when(() => location.latitude).thenReturn(latitude);
      when(() => location.longitude).thenReturn(longitude);
      when(() => weatherDS.locationSearch(any())).thenAnswer((_) async => location);

      // act
      try {
        await sut.getWeather(city);
      } catch (_) {}

      // assert
      verify(() => weatherDS.getWeather(latitude, longitude)).called(1);
    });

    test("throws when getWeather fails", () async {
      // assign
      final exception = Exception();
      final location = MockLocationEntity();

      when(() => location.latitude).thenReturn(latitude);
      when(() => location.longitude).thenReturn(longitude);
      when(() => weatherDS.locationSearch(any())).thenAnswer((_) async => location);
      when(() => weatherDS.getWeather(any(), any())).thenThrow(exception);

      // act & assert
      expect(() => sut.getWeather(city), throwsA(exception)); //
    });

    test("returns correct weather on success (clear)", () async {
      // assign
      final location = MockLocationEntity();
      final weather = MockWeatherEntity();

      when(() => location.name).thenReturn(city);
      when(() => location.latitude).thenReturn(latitude);
      when(() => location.longitude).thenReturn(longitude);
      when(() => weather.temperature).thenReturn(42.42);
      when(() => weather.weatherCode).thenReturn(0);
      when(() => weatherDS.locationSearch(any())).thenAnswer((_) async => location);
      when(() => weatherDS.getWeather(any(), any())).thenAnswer((_) async => weather);

      // act
      final actual = await sut.getWeather(city);

      // assert
      expect(
        actual,
        Weather(
          location: city,
          temperature: const Temperature(value: 42.42),
          condition: WeatherCondition.clear,
          lastUpdated: DateTime.now().withoutMilliseconds,
        ),
      );
    });

    test("returns correct weather on success (cloudy)", () async {
      // assign
      final location = MockLocationEntity();
      final weather = MockWeatherEntity();

      when(() => location.name).thenReturn(city);
      when(() => location.latitude).thenReturn(latitude);
      when(() => location.longitude).thenReturn(longitude);
      when(() => weather.temperature).thenReturn(42.42);
      when(() => weather.weatherCode).thenReturn(0);
      when(() => weather.weatherCode).thenReturn(1);
      when(() => weatherDS.locationSearch(any())).thenAnswer((_) async => location);
      when(() => weatherDS.getWeather(any(), any())).thenAnswer((_) async => weather);

      // act
      final actual = await sut.getWeather(city);

      // assert
      expect(
        actual,
        Weather(
          location: city,
          temperature: const Temperature(value: 42.42),
          condition: WeatherCondition.cloudy,
          lastUpdated: DateTime.now().withoutMilliseconds,
        ),
      );
    });

    test("returns correct weather on success (rainy)", () async {
      // assign
      final location = MockLocationEntity();
      final weather = MockWeatherEntity();

      when(() => location.name).thenReturn(city);
      when(() => location.latitude).thenReturn(latitude);
      when(() => location.longitude).thenReturn(longitude);
      when(() => weather.temperature).thenReturn(42.42);
      when(() => weather.weatherCode).thenReturn(0);
      when(() => weather.weatherCode).thenReturn(51);
      when(() => weatherDS.locationSearch(any())).thenAnswer((_) async => location);
      when(() => weatherDS.getWeather(any(), any())).thenAnswer((_) async => weather);

      // act
      final actual = await sut.getWeather(city);

      // assert
      expect(
        actual,
        Weather(
          location: city,
          temperature: const Temperature(value: 42.42),
          condition: WeatherCondition.rainy,
          lastUpdated: DateTime.now().withoutMilliseconds,
        ),
      );
    });

    test("returns correct weather on success (snowy)", () async {
      // assign
      final location = MockLocationEntity();
      final weather = MockWeatherEntity();

      when(() => location.name).thenReturn(city);
      when(() => location.latitude).thenReturn(latitude);
      when(() => location.longitude).thenReturn(longitude);
      when(() => weather.temperature).thenReturn(42.42);
      when(() => weather.weatherCode).thenReturn(0);
      when(() => weather.weatherCode).thenReturn(71);
      when(() => weatherDS.locationSearch(any())).thenAnswer((_) async => location);
      when(() => weatherDS.getWeather(any(), any())).thenAnswer((_) async => weather);

      // act
      final actual = await sut.getWeather(city);

      // assert
      expect(
        actual,
        Weather(
          location: city,
          temperature: const Temperature(value: 42.42),
          condition: WeatherCondition.snowy,
          lastUpdated: DateTime.now().withoutMilliseconds,
        ),
      );
    });

    test("returns correct weather on success (unknown)", () async {
      // assign
      final location = MockLocationEntity();
      final weather = MockWeatherEntity();

      when(() => location.name).thenReturn(city);
      when(() => location.latitude).thenReturn(latitude);
      when(() => location.longitude).thenReturn(longitude);
      when(() => weather.temperature).thenReturn(42.42);
      when(() => weather.weatherCode).thenReturn(0);
      when(() => weather.weatherCode).thenReturn(-1);
      when(() => weatherDS.locationSearch(any())).thenAnswer((_) async => location);
      when(() => weatherDS.getWeather(any(), any())).thenAnswer((_) async => weather);

      // act
      final actual = await sut.getWeather(city);

      // assert
      expect(
        actual,
        Weather(
          location: city,
          temperature: const Temperature(value: 42.42),
          condition: WeatherCondition.unknown,
          lastUpdated: DateTime.now().withoutMilliseconds,
        ),
      );
    });
  });
}
