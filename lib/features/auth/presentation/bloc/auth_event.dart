part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthEmailChanged extends AuthEvent {
  final String email;
  AuthEmailChanged(this.email);
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  AuthPasswordChanged(this.password);
}

class AuthLoginWithEmail extends AuthEvent {}

class AuthLoginWithGoogle extends AuthEvent {}

class AuthLogoutREquestd extends AuthEvent {}

class AuthPasswordVisibilityToggled extends AuthEvent {}
