import 'package:fintrack/core/shell/shell_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/login_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/signup_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/splash_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/welcome_screen.dart';
import 'package:fintrack/features/dashboard/pages/dashboard_screen.dart';
import 'package:fintrack/features/transactions/presentation/pages/add_transaction_screen.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_screen.dart';
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
    GoRoute(
      path: '/add-transaction',
      builder: (context, state) => const AddTransactionScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/transaction',
          builder: (context, state) => const TransactionScreen(),
        ),
        GoRoute(
          path: '/budget',
          builder: (context, state) => const TransactionScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const TransactionScreen(),
        ),
      ],
    ),
  ],
);
