import 'package:bloc_tutorial/post/app.dart';
import 'package:bloc_tutorial/post/data/data_sources/post_data_source.dart';
import 'package:bloc_tutorial/post/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

void main() {
  injectDependencies();

  Bloc.observer = const PostBlocObserver();
  runApp(const PostApp());
}

void injectDependencies() {
  sl.registerSingleton<PostDataSource>(PostDataSourceImpl());
}
