import 'package:bloc_tutorial/login/domain/blocs/authentication_bloc.dart';
import 'package:bloc_tutorial/login/domain/repositories/authentication_repository.dart';
import 'package:bloc_tutorial/login/domain/repositories/user_repository.dart';
import 'package:bloc_tutorial/login/main.dart';
import 'package:bloc_tutorial/login/presentation/homepage.dart';
import 'package:bloc_tutorial/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/splash_page.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(
        authenticationRepository: sl.get<AuthenticationRepository>(),
        userRepository: sl.get<UserRepository>(),
      )..add(AuthenticationSubscriptionRequested()),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        builder: (ctx, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (ctx, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil(HomePage.route(), (route) => false);
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil(LoginPage.route(), (route) => false);
                case AuthenticationStatus.unknown:
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => SplashPage.route(),
      ),
    );
  }
}
