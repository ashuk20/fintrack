import 'package:fintrack/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: BlocListener<SignupBloc, SignupState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            context.go('/dashboard');
          }
          if (state.status == SignupStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/welcome'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color(0xFFD4AF37),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: const Color(0xFFD4AF37),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start your financial journey today',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('FIRST NAME'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _firstNameController,
                            hint: 'Ashwini',
                            onChanged: (val) => context.read<SignupBloc>().add(
                              SignupFirstNameChanged(val),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('LAST NAME'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _lastNameController,
                            hint: 'khodake',
                            onChanged: (val) => context.read<SignupBloc>().add(
                              SignupLastNameChanged(val),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                const SizedBox(height: 32),
                _buildLabel('EMAIL'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _emailController,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) =>
                      context.read<SignupBloc>().add(SignupEmailChanged(val)),
                ),

                const SizedBox(height: 16),
                _buildLabel('PASSWORD'),
                const SizedBox(height: 6),
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.isPasswordVisible !=
                      current.isPasswordVisible,
                  builder: (context, state) {
                    return _buildTextField(
                      controller: _passwordController,
                      hint: '••••••••',
                      obscure: !state.isPasswordVisible,
                      onChanged: (val) => context.read<SignupBloc>().add(
                        SignupPasswordChanged(val),
                      ),
                      suffix: IconButton(
                        onPressed: () => context.read<SignupBloc>().add(
                          SignupPasswordVisibilityToggled(),
                        ),
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: Colors.white38,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                _buildLabel('CONFIRM PASSWORD'),
                const SizedBox(height: 6),
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.isConfirmPasswordVisible !=
                          current.isConfirmPasswordVisible ||
                      previous.passwordsMatch != current.passwordsMatch,
                  builder: (context, state) {
                    return _buildTextField(
                      controller: _confirmPasswordController,
                      hint: '••••••••',
                      obscure: !state.isConfirmPasswordVisible,
                      onChanged: (val) => context.read<SignupBloc>().add(
                        SignupConfirmPasswordChanged(val),
                      ),
                      hasError:
                          _confirmPasswordController.text.isNotEmpty &&
                          !state.passwordsMatch,
                      suffix: IconButton(
                        onPressed: () => context.read<SignupBloc>().add(
                          SignupConfirmPasswordVisibilityToggled(),
                        ),
                        icon: Icon(
                          state.isConfirmPasswordVisible
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: Colors.white38,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),

                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.passwordsMatch != current.passwordsMatch,
                  builder: (context, state) {
                    if (_confirmPasswordController.text.isNotEmpty &&
                        !state.passwordsMatch) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Passwords do not match',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 28),
                BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state.status == SignupStatus.loading
                            ? null
                            : () => context.read<SignupBloc>().add(
                                SignupSubmitted(),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: const Color(0xFF0A1628),
                          disabledBackgroundColor: const Color(
                            0xFFD4AF37,
                          ).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: state.status == SignupStatus.loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0A1628),
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or sign up with',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.1)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.read<SignupBloc>().add(SignupWithGoogle()),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.15)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Image.network(
                      'https://www.google.com/favicon.ico',
                      width: 20,
                      height: 20,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.g_mobiledata, color: Colors.white),
                    ),
                    label: Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 11,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool obscure = false,
    bool hasError = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.redAccent : Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.redAccent : Color(0xFFD4AF37),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
