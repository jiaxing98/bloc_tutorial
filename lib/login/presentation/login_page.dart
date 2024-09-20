import 'package:bloc_tutorial/login/domain/blocs/login_bloc.dart';
import 'package:bloc_tutorial/login/domain/repositories/authentication_repository.dart';
import 'package:bloc_tutorial/login/main.dart';
import 'package:bloc_tutorial/login/presentation/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (_) => LoginBloc(authenticationRepository: sl.get<AuthenticationRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
