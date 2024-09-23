import 'package:bloc_tutorial/post/data/entities/post_entity.dart';
import 'package:bloc_tutorial/post/domain/models/post.dart';
import 'package:dio/dio.dart';

abstract class PostDataSource {
  Future<List<Post>> fetchPosts({required int startIndex});
}

const _postLimit = 20;

class PostDataSourceImpl extends PostDataSource {
  final Dio _dio;

  PostDataSourceImpl() : _dio = Dio()..options = _options;

  @override
  Future<List<Post>> fetchPosts({required int startIndex}) async {
    final response = await _dio.get(
      "/posts",
      queryParameters: {
        "_start": startIndex,
        "_limit": _postLimit,
      },
    );

    final data = (response.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((e) => PostEntity.fromJson(e));
    return data.map((e) => Post.fromEntity(e)).toList();
  }
}

BaseOptions get _options => BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      validateStatus: (statusCode) =>
          (statusCode != null && statusCode >= 200 && statusCode <= 300),
    );
