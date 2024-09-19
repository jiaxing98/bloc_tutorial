import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/post/data/data_sources/post_data_source.dart';
import 'package:bloc_tutorial/post/domain/models/post.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'post_event.dart';
part 'post_state.dart';

const _throttleDuration = Duration(milliseconds: 100);

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostDataSource _postDS;

  PostBloc({required PostDataSource postDS})
      : _postDS = postDS,
        super(const PostState()) {
    on<PostFetched>(_onPostFetched, transformer: throttleDroppable(_throttleDuration));
  }

  Future<void> _onPostFetched(PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;

    try {
      final posts = await _postDS.fetchPosts(startIndex: state.posts.length);
      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      return emit(
        state.copyWith(
          status: PostStatus.success,
          posts: [...state.posts, ...posts],
        ),
      );
    } catch (ex) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return events.throttleTime(duration).switchMap(mapper);
    };
  }
}
