import 'package:bloc_tutorial/weather/data/data_sources/weather_data_source.dart';
import 'package:bloc_tutorial/weather/domain/models/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
}

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherDataSource _weatherDS;

  WeatherRepositoryImpl({required WeatherDataSource weatherDS}) : _weatherDS = weatherDS;

  @override
  Future<Weather> getWeather(String city) async {
    final location = await _weatherDS.locationSearch(city);
    final weather = await _weatherDS.getWeather(location.latitude!, location.longitude!);

    return Weather.fromEntity(location, weather);
  }
}
