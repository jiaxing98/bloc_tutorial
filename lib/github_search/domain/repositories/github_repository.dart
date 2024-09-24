import 'dart:async';

import 'package:bloc_tutorial/github_search/data/data_sources/github_cache.dart';
import 'package:bloc_tutorial/github_search/data/data_sources/github_data_source.dart';
import 'package:bloc_tutorial/github_search/data/entities/search_result.dart';

class GithubRepository {
  final GithubCache cache;
  final GithubDataSource githubDS;

  const GithubRepository(this.cache, this.githubDS);

  Future<SearchResult> search(String term) async {
    final cachedResult = cache.get(term);
    if (cachedResult != null) return cachedResult;

    final result = await githubDS.search(term);
    cache.set(term, result);
    return result;
  }
}
