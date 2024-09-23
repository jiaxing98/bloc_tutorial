import 'package:bloc_tutorial/weather/domain/blocs/weather_cubit.dart';
import 'package:bloc_tutorial/weather/domain/repositories/weather_repository.dart';
import 'package:bloc_tutorial/weather/extension.dart';
import 'package:bloc_tutorial/weather/main.dart';
import 'package:bloc_tutorial/weather/presentation/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(weatherRepository: weatherSL.get<WeatherRepository>()),
      child: const WeatherAppView(),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final seedColor = context.select((WeatherCubit cubit) => cubit.state.weather.toColor);

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        textTheme: GoogleFonts.rajdhaniTextTheme(),
      ),
      home: const WeatherPage(),
    );
  }
}
