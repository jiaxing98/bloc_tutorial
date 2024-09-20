import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/login/domain/models/user.dart';
import 'package:bloc_tutorial/login/domain/repositories/authentication_repository.dart';
import 'package:bloc_tutorial/login/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    return emit.onEach(_authenticationRepository.status, onData: (status) async {
      switch (status) {
        case AuthenticationStatus.authenticated:
          final user = await _tryGetUser();
          emit(user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated());
        case AuthenticationStatus.unauthenticated:
          emit(const AuthenticationState.unauthenticated());
        case AuthenticationStatus.unknown:
          emit(const AuthenticationState.unknown());
      }
      ;
    });
  }

  void _onLogoutPressed(AuthenticationLogoutPressed event, Emitter<AuthenticationState> emit) {
    _authenticationRepository.logout();
  }

  Future<User?> _tryGetUser() async {
    try {
      return await _userRepository.getUser();
    } catch (ex) {
      return null;
    }
  }
}
