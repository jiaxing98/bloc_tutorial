import 'package:json_annotation/json_annotation.dart';

part 'post_entity.g.dart';

@JsonSerializable()
class PostEntity {
  final int? id;
  final String? title;
  final String? body;

  PostEntity({
    this.id,
    this.title,
    this.body,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return _$PostEntityFromJson(json);
  }
}
