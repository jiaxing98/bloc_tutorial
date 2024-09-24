// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultError _$SearchResultErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SearchResultError',
      json,
      ($checkedConvert) {
        final val = SearchResultError(
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$SearchResultErrorToJson(SearchResultError instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
