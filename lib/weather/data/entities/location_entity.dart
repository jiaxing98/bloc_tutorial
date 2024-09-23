import 'package:json_annotation/json_annotation.dart';

part 'location_entity.g.dart';

@JsonSerializable(createToJson: false)
class LocationEntity {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;

  LocationEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return _$LocationEntityFromJson(json);
  }
}
