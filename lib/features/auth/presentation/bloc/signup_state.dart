part of 'signup_bloc.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState {
  final SignupStatus status;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String? errorMessage;

  const SignupState({
    this.status = SignupStatus.initial,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.errorMessage,
  });

  bool get passwordsMatch => password == confirmPassword;

  bool get isFormValid =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      passwordsMatch;

  SignupState copyWith({
    SignupStatus? status,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmpassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmpassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
