import 'package:bloc_tutorial/login/app.dart';
import 'package:bloc_tutorial/login/domain/repositories/authentication_repository.dart';
import 'package:bloc_tutorial/login/domain/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

void main() {
  injectDependencies();

  runApp(const LoginApp());
}

void injectDependencies() {
  sl.registerSingleton<AuthenticationRepository>(AuthenticationRepository());
  sl.registerSingleton<UserRepository>(UserRepository());
}
