part of 'post_bloc.dart';

@immutable
sealed class PostEvent extends Equatable {
  const PostEvent();
}

final class PostFetched extends PostEvent {
  const PostFetched();

  @override
  List<Object?> get props => [];
}
