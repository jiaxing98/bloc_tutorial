import 'package:bloc_tutorial/weather/data/entities/location_entity.dart';
import 'package:bloc_tutorial/weather/data/entities/weather_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LocationEntity", () {
    test("fromJson returns correct LocationEntity object", () {
      // assign
      final Map<String, dynamic> json = {
        "id": 4887389,
        "name": "Chicago",
        "latitude": 41.85003,
        "longitude": -87.65005,
      };

      // assert
      expect(
        LocationEntity.fromJson(json),
        isA<LocationEntity>()
            .having((e) => e.id, "id", 4887389)
            .having((e) => e.name, "name", "Chicago")
            .having((e) => e.latitude, "latitude", 41.85003)
            .having((e) => e.longitude, "longitude", -87.65005),
      );
    });
  });

  group('WeatherEntity', () {
    test('fromJson returns correct WeatherEntity object', () {
      // assign
      final Map<String, dynamic> json = {
        "temperature": 15.3,
        "weathercode": 63,
      };

      expect(
        WeatherEntity.fromJson(json),
        isA<WeatherEntity>()
            .having((e) => e.temperature, 'temperature', 15.3)
            .having((e) => e.weatherCode, 'weatherCode', 63),
      );
    });
  });
}
