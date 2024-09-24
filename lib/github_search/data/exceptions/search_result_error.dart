import 'package:json_annotation/json_annotation.dart';

part 'search_result_error.g.dart';

@JsonSerializable()
class SearchResultError implements Exception {
  final String message;

  SearchResultError({required this.message});

  factory SearchResultError.fromJson(Map<String, dynamic> json) =>
      _$SearchResultErrorFromJson(json);
}
