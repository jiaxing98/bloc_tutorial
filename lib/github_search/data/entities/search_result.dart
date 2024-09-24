import 'package:bloc_tutorial/github_search/data/entities/search_result_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final List<SearchResultItem> items;

  const SearchResult({required this.items});

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
}
