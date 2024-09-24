import 'package:json_annotation/json_annotation.dart';

part 'github_user.g.dart';

@JsonSerializable()
class GithubUser {
  final String login;
  final String avatarUrl;

  const GithubUser({
    required this.login,
    required this.avatarUrl,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) => _$GithubUserFromJson(json);

  Map<String, dynamic> toJson() => _$GithubUserToJson(this);
}
