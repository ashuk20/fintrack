part of 'signup_bloc.dart';

abstract class SignupEvent {}

class SignupFirstNameChanged extends SignupEvent {
  final String firstName;
  SignupFirstNameChanged(this.firstName);
}

class SignupLastNameChanged extends SignupEvent {
  final String lastName;
  SignupLastNameChanged(this.lastName);
}

class SignupEmailChanged extends SignupEvent {
  final String email;
  SignupEmailChanged(this.email);
}

class SignupPasswordChanged extends SignupEvent {
  final String password;
  SignupPasswordChanged(this.password);
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;

  SignupConfirmPasswordChanged(this.confirmPassword);
}

class SignupPasswordVisibilityToggled extends SignupEvent {}

class SignupConfirmPasswordVisibilityToggled extends SignupEvent {}

class SignupSubmitted extends SignupEvent {}

class SignupWithGoogle extends SignupEvent {}
