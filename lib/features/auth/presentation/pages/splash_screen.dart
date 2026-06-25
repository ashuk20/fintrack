import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _ringController;

  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _ringPulse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _ringPulse = CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeInOut,
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    _textSlide = Tween<double>(
      begin: 20,
      end: 0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) context.go('/onboarding');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _ringPulse,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildRing(100, 0.15 + (_ringPulse.value * 0.1)),
                    _buildRing(76, 0.25 + (_ringPulse.value * 0.15)),
                    _buildRing(54, 0.4 + (_ringPulse.value * 0.2)),
                    ScaleTransition(scale: _logoScale, child: _buildLogoCore()),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _textSlide.value),
                  child: Opacity(
                    opacity: _textFade.value,
                    child: Column(
                      children: [
                        const Text(
                          "FINTRACK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 6,
                          ),
                        ),
                        const SizedBox(height: 8,),
                         Text(
                          "YOUR MONEY YOUR FUTURE",
                          style: TextStyle(
                            color: const Color(0xFFD4AF37),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRing(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(opacity),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildLogoCore() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        color: Color(0xFF0A1628),
        size: 30,
      ),
    );
  }
}
