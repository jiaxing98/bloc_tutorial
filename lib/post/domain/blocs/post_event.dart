part of 'post_bloc.dart';

@immutable
sealed class PostEvent extends Equatable {}

final class PostFetched extends PostEvent {
  @override
  List<Object?> get props => [];
}
