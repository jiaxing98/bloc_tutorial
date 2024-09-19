import 'package:bloc_tutorial/post/data/entities/post_entity.dart';
import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  final int id;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [id, title, body];

  factory Post.fromEntity(PostEntity entity) {
    return Post(
      id: entity.id!,
      title: entity.title ?? "",
      body: entity.body ?? "",
    );
  }
}
