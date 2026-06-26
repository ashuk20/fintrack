part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String email;
  final String password;
  final String? errorMessage;
  final bool isPasswordVisible;

  const AuthState({
    this.status = AuthStatus.initial,
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.isPasswordVisible = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? password,
    String? errorMessage,
    bool? isPasswordVisible,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
