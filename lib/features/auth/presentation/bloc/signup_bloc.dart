import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SignupBloc() : super(const SignupState()) {
    on<SignupFirstNameChanged>((event, emit) {
      emit(state.copyWith(firstName: event.firstName));
    });

    on<SignupLastNameChanged>((event, emit) {
      emit(state.copyWith(lastName: event.lastName));
    });

    on<SignupEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<SignupPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SignupConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmpassword: event.confirmPassword));
    });

    on<SignupPasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });
    on<SignupConfirmPasswordVisibilityToggled>((event, emit) {
      emit(
        state.copyWith(
          isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
        ),
      );
    });

    on<SignupSubmitted>((event, emit) async {
      if (!state.isFormValid) {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Please fill all fields correctly.',
          ),
        );
        return;
      }

      if (!state.passwordsMatch) {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Passwords do not match.',
          ),
        );
        return;
      }

      if (state.password.length < 6) {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Password must be at least 6 characters.',
          ),
        );
        return;
      }
      emit(state.copyWith(status: SignupStatus.loading));

      try {
        final userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(
              email: state.email.trim(),
              password: state.password.trim(),
            );
        await userCredential.user?.updateDisplayName(
          '${state.firstName} ${state.lastName}',
        );

        emit(state.copyWith(status: SignupStatus.success));
      } on FirebaseAuthException catch (e) {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: _mapFirebaseError(e.code),
          ),
        );
      }
    });
    on<SignupWithGoogle>((event, emit) async {
      emit(state.copyWith(status: SignupStatus.loading));
      try {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          emit(state.copyWith(status: SignupStatus.initial));
          return;
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        emit(state.copyWith(status: SignupStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Google sign up failed.Please try again.',
          ),
        );
      }
    });
  }
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Sign up is currently disabled. Try again later.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
