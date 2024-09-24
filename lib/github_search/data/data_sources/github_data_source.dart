import 'package:bloc_tutorial/github_search/data/entities/search_result.dart';
import 'package:bloc_tutorial/github_search/data/exceptions/search_result_error.dart';
import 'package:dio/dio.dart';

abstract class GithubDataSource {
  Future<SearchResult> search(String term);
}

class GithubDataSourceImpl extends GithubDataSource {
  final Dio _dio;

  GithubDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<SearchResult> search(String term) async {
    final response = await _dio.get(
      "https://api.github.com/search/repositories",
      queryParameters: {
        "q": term,
      },
    );

    if (response.statusCode != 200) throw SearchResultError.fromJson(response.data);

    return SearchResult.fromJson(response.data);
  }
}
