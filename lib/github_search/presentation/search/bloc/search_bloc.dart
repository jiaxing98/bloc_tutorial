import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/github_search/data/entities/search_result_item.dart';
import 'package:bloc_tutorial/github_search/data/exceptions/search_result_error.dart';
import 'package:bloc_tutorial/github_search/domain/repositories/github_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GithubRepository _githubRepository;

  SearchBloc({required GithubRepository githubRepository})
      : _githubRepository = githubRepository,
        super(SearchStateEmpty()) {
    on<TextChanged>(_onTextChanged);
  }

  Future<void> _onTextChanged(TextChanged event, Emitter<SearchState> emit) async {
    final searchTerm = event.text;

    if (searchTerm.isEmpty) return emit(SearchStateEmpty());

    emit(SearchStateLoading());

    try {
      final results = await _githubRepository.search(searchTerm);
      emit(SearchStateSuccess(results.items));
    } catch (error) {
      emit(
        error is SearchResultError
            ? SearchStateError(error.message)
            : const SearchStateError('something went wrong'),
      );
    }
  }
}

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}
