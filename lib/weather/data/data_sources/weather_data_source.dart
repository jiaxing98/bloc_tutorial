import 'package:bloc_tutorial/weather/data/entities/location_entity.dart';
import 'package:bloc_tutorial/weather/data/entities/weather_entity.dart';
import 'package:bloc_tutorial/weather/data/exceptions/weather_exception.dart';
import 'package:dio/dio.dart';

abstract class WeatherDataSource {
  Future<LocationEntity> locationSearch(String query);
  Future<WeatherEntity> getWeather(double latitude, double longitude);
}

class WeatherDataSourceImpl extends WeatherDataSource {
  final Dio _dio;

  WeatherDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<LocationEntity> locationSearch(String query) async {
    try {
      final response = await _dio.get(
        "https://geocoding-api.open-meteo.com/v1/search",
        queryParameters: {
          "name": query,
          "count": "1",
        },
      );

      final Map<String, dynamic> data = response.data;
      if (!data.containsKey("results")) throw LocationNotFoundFailure();

      final results = (data["results"] as List<dynamic>).cast<Map<String, dynamic>>();
      if (results.isEmpty) throw LocationNotFoundFailure();

      return LocationEntity.fromJson(results.first);
    } on DioException catch (ex) {
      throw WeatherRequestFailure();
    }
  }

  @override
  Future<WeatherEntity> getWeather(double latitude, double longitude) async {
    try {
      final response = await _dio.get(
        "https://api.open-meteo.com/v1/forecast",
        queryParameters: {
          "latitude": latitude,
          "longitude": longitude,
          "current_weather": true,
        },
      );

      final Map<String, dynamic> data = response.data;
      if (!data.containsKey("current_weather")) throw WeatherNotFoundFailure();

      return WeatherEntity.fromJson(data["current_weather"]);
    } on DioException catch (ex) {
      throw WeatherRequestFailure();
    }
  }
}
