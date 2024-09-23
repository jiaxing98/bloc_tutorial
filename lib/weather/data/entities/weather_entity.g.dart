// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherEntity _$WeatherEntityFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WeatherEntity',
      json,
      ($checkedConvert) {
        final val = WeatherEntity(
          temperature:
              $checkedConvert('temperature', (v) => (v as num?)?.toDouble()),
          weatherCode:
              $checkedConvert('weathercode', (v) => (v as num?)?.toInt()),
        );
        return val;
      },
      fieldKeyMap: const {'weatherCode': 'weathercode'},
    );
