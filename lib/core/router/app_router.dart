import 'package:fintrack/core/shell/shell_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/login_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/signup_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/splash_screen.dart';
import 'package:fintrack/features/auth/presentation/pages/welcome_screen.dart';
import 'package:fintrack/features/dashboard/pages/dashboard_screen.dart';
import 'package:fintrack/features/transactions/presentation/pages/add_transaction_screen.dart';
import 'package:fintrack/features/transactions/presentation/pages/transaction_screen.dart';
import 'package:flutter/material.dart';
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
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const DashboardScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
          // builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/transaction',
          // builder: (context, state) => const TransactionScreen(),
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TransactionScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1, 0);
                  const end = Offset.zero;
                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.easeInOut));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: '/budget',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TransactionScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final slideAnimation =
                      Tween(
                        begin: const Offset(0.15, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      );
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 350),
          ),
          // builder: (context, state) => const TransactionScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const TransactionScreen(),
        ),
      ],
    ),
  ],
);
