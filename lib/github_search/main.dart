import 'package:bloc_tutorial/github_search/app.dart';
import 'package:bloc_tutorial/github_search/data/data_sources/github_cache.dart';
import 'package:bloc_tutorial/github_search/data/data_sources/github_data_source.dart';
import 'package:bloc_tutorial/github_search/domain/repositories/github_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt githubSL = GetIt.instance;

void main() {
  injectDependencies();
  runApp(const GithubApp());
}

void injectDependencies() {
  githubSL.registerSingleton<GithubCache>(GithubCache());
  githubSL.registerSingleton<GithubDataSource>(GithubDataSourceImpl(dio: Dio()));
  githubSL.registerSingleton<GithubRepository>(
    GithubRepository(
      githubSL.get<GithubCache>(),
      githubSL.get<GithubDataSource>(),
    ),
  );
}
