import 'package:bloc_tutorial/weather/data/entities/location_entity.dart';
import 'package:uuid/uuid.dart';

class Location {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromEntity(LocationEntity entity) {
    return Location(
      id: entity.id?.toString() ?? const Uuid().v4(),
      name: entity.name ?? "",
      latitude: entity.latitude ?? 0.0,
      longitude: entity.longitude ?? 0.0,
    );
  }
}
