import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(const AuthState()) {
    on<AuthEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<AuthPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<AuthPasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<AuthLoginWithEmail>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      try {
         print('state emai : ${state}');
        await _firebaseAuth.signInWithEmailAndPassword(
          email: state.email.trim(),
          password: state.password.trim(),
        );
        emit(state.copyWith(status: AuthStatus.success));
      } on FirebaseAuthException catch (e) {
        print('Firebase error code : ${e.code}');
        print('Firebase error message : ${e.message}');
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: _mapFirebaseError(e.code),
          ),
        );
      }
    });

    on<AuthLoginWithGoogle>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      try {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          emit(state.copyWith(status: AuthStatus.initial));
          return;
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        print('credential credential: ${credential}');
        await _firebaseAuth.signInWithCredential(credential);
        emit(state.copyWith(status: AuthStatus.success));
      } catch (e) {
        print('Error auth: ${e}');
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: 'Google sign-in failed. Please try again.',
          ),
        );
      }
    });
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password.Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Email or Password is incorrect.Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.Please check yournetwork';
      default:
        return 'Something went wrong. Please try again. ${code}';
    }
  }
}
