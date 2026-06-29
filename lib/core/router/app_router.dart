import 'package:fintrack/features/auth/presentation/pages/login_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/signup_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/splash_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/welcome_screen.dart';
import 'package:fintrack/features/dashboard/pages/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => DashboardScreen()),
  ],
);
