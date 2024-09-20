import 'package:bloc_tutorial/login/domain/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (ctx, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Authentication Failure")),
            );
        }
      },
      child: Align(
        alignment: Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

//region _UsernameInput
class _UsernameInput extends StatelessWidget {
  const _UsernameInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select((LoginBloc bloc) => bloc.state.username.displayError);

    return TextField(
      key: const Key("loginForm_usernameInput_textField"),
      onChanged: (username) {
        context.read<LoginBloc>().add(LoginUsernameChanged(username: username));
      },
      decoration: InputDecoration(
        labelText: "username",
        errorText: displayError != null ? "Invalid username" : null,
      ),
    );
  }
}
//endregion

//region _PasswordInput
class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select((LoginBloc bloc) => bloc.state.password.displayError);

    return TextField(
      key: const Key("loginForm_usernameInput_textField"),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password: password));
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "password",
        errorText: displayError != null ? "Invalid password" : null,
      ),
    );
  }
}
//endregion

//region _LoginButton
class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess =
        context.select((LoginBloc bloc) => bloc.state.status.isInProgressOrSuccess);
    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);

    if (isInProgressOrSuccess) return const CircularProgressIndicator();

    return ElevatedButton(
      key: const Key('loginForm_continue_submitButton'),
      onPressed: isValid ? () => context.read<LoginBloc>().add(const LoginSubmitted()) : null,
      child: const Text('Login'),
    );
  }
}
//endregion
