// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultItem _$SearchResultItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SearchResultItem',
      json,
      ($checkedConvert) {
        final val = SearchResultItem(
          fullName: $checkedConvert('full_name', (v) => v as String),
          htmlUrl: $checkedConvert('html_url', (v) => v as String),
          owner: $checkedConvert(
              'owner', (v) => GithubUser.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'fullName': 'full_name', 'htmlUrl': 'html_url'},
    );

Map<String, dynamic> _$SearchResultItemToJson(SearchResultItem instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'html_url': instance.htmlUrl,
      'owner': instance.owner.toJson(),
    };
