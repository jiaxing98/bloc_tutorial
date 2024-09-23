import 'package:bloc_tutorial/weather/app.dart';
import 'package:bloc_tutorial/weather/data/data_sources/weather_data_source.dart';
import 'package:bloc_tutorial/weather/domain/repositories/weather_repository.dart';
import 'package:bloc_tutorial/weather/observer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

GetIt weatherSL = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const WeatherBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getTemporaryDirectory(),
  );
  injectDependencies();

  runApp(const WeatherApp());
}

void injectDependencies() {
  weatherSL.registerSingleton<WeatherDataSource>(
    WeatherDataSourceImpl(dio: Dio()),
  );

  weatherSL.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(weatherDS: weatherSL.get<WeatherDataSource>()),
  );
}
