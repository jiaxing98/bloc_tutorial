import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temperature.g.dart';

enum TemperatureUnits { fahrenheit, celsius }

@JsonSerializable()
class Temperature extends Equatable {
  final double value;

  @override
  List<Object> get props => [value];

  const Temperature({required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return _$TemperatureFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TemperatureToJson(this);
  }
}
