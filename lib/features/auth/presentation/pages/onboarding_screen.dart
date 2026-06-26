import 'package:fintrack/features/auth/presentation/bloc/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingSlide {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });
}

final List<OnboardingSlide> slides = [
  const OnboardingSlide(
    icon: Icons.account_balance_wallet_rounded,
    title: 'Track Every Rupee',
    subtitle:
        'Know exactly where your money goes.\n Income, expense , all in one place.',
    iconColor: Color(0xFFD4AF37),
  ),
  const OnboardingSlide(
    icon: Icons.pie_chart_rounded,
    title: 'Smart Budgeting',
    subtitle:
        'Set monthly budgets by category\nand get alert before you overspend.',
    iconColor: Color(0xFF4CAF50),
  ),
  const OnboardingSlide(
    icon: Icons.trending_up_rounded,
    title: 'Grow your Wealth',
    subtitle:
        'Visualise your financial growth\nand make smarter money decisions.',
    iconColor: Color(0xFF2196F3),
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _iconController;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupIconAnimation();
  }

  void _setupIconAnimation() {
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconScale = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );
    _iconFade = CurvedAnimation(parent: _iconController, curve: Curves.easeIn);

    _iconController.forward();
  }

  void _animateIcon() {
    _iconController.reset();
    _iconController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listenWhen: (previous, current) => current.isDone != previous.isDone,
        listener: (context, state) {
          if (state.isDone) context.go('/welcome');
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFF0A1628),
              body: SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextButton(
                          onPressed: () => context.read<OnboardingBloc>().add(
                            OnboadingSkipped(),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: slides.length,
                        onPageChanged: (index) {
                          context.read<OnboardingBloc>().add(
                            OnboardingPageChanged(index),
                          );
                          _animateIcon();
                        },
                        itemBuilder: (context, index) {
                          return _buildSlide(slides[index]);
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        slides.length,
                        (i) => _buildDot(i == state.currentPage),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          if (state.currentPage > 0)
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton(
                                  onPressed: () {
                                    context.read<OnboardingBloc>().add(
                                      OnboadingPreviousPage(),
                                    );
                                    _pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                    _animateIcon();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFD4AF37),
                                    side: const BorderSide(
                                      color: Color(0xFFD4AF37),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (state.currentPage > 0) const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (state.isLastPage) {
                                    context.read<OnboardingBloc>().add(
                                      OnboadingSkipped(),
                                    );
                                  } else {
                                    context.read<OnboardingBloc>().add(
                                      OnboadingNextPage(),
                                    );
                                    _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeOut,
                                    );
                                    _animateIcon();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4AF37),
                                  foregroundColor: const Color(0xFF0A1628),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  state.isLastPage ? 'Get Started' : 'Next',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _iconScale,
            child: FadeTransition(
              opacity: _iconFade,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: slide.iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: slide.iconColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(slide.icon, size: 56, color: slide.iconColor),
              ),
            ),
          ),
          const SizedBox(height: 48),

          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFD4AF37)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
