import 'dart:math';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snipply/main/theme/themes.dart';
import 'package:snipply/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _backgroundGradient;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    _navigate();
  }

  void _initAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
          ),
        );

    // Background animations
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _backgroundGradient = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Particle animations
    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
  }

  void _startAnimations() {
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });
  }

  Future<void> _navigate() async {
  await Future.delayed(const Duration(seconds: 4));

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (!mounted) return;

    // Add debug print to verify token
    debugPrint('Splash token check: ${token != null ? 'exists' : 'null'}');
    
    Navigator.pushNamedAndRemoveUntil(
      context,
      token != null ? AppRoute.home : AppRoute.loginName,
      (route) => false,
    );
  } catch (e) {
    debugPrint('Splash navigation error: $e');
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoute.loginName,
      (route) => false,
    );
  }
}

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _particleController,
          _logoController,
          _textController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppColors.backgroundDark,
                    AppColors.backgroundDark2,
                    _backgroundGradient.value,
                  )!,
                  Color.lerp(
                    AppColors.backgroundDark3,
                    AppColors.gradientDark1,
                    _backgroundGradient.value,
                  )!,
                  Color.lerp(
                    AppColors.gradientDark1,
                    AppColors.gradientDark2,
                    _backgroundGradient.value,
                  )!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated particles
                ...List.generate(20, (index) {
                  final offset = Offset(
                    (index * 50.0) % MediaQuery.of(context).size.width,
                    (index * 80.0) % MediaQuery.of(context).size.height,
                  );
                  return _buildParticle(offset, index);
                }),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo
                      Transform.scale(
  scale: _logoScale.value,
  child: Container(
    width: 200,  // Increased from 140
    height: 200, // Increased from 140
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Looper image (circular border)
        Container(
          width: 200,  // Increased proportionally
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/looper.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        
        // Logo image (square but clipped to circle)
        ClipOval(
          child: Container(
            width: 120,  // Increased from 80 (maintaining same ratio)
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
                      const SizedBox(height: 40),

                      // Animated text
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.secondary,
                                        AppColors.tertiary,
                                      ],
                                    ).createShader(bounds),
                                child: const Text(
                                  'Snipply',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Snip It. Sell It. Scale It. ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textWhite80,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      FadeTransition(
                        opacity: _textOpacity,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: LoadingIndicator(
                            indicatorType: Indicator.pacman,
                            colors: [AppColors.secondary],
                            strokeWidth: 2,
                            pathBackgroundColor: Colors.black,

                            /// Optional, the stroke backgroundColor
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticle(Offset initialOffset, int index) {
    final animationOffset = _particleAnimation.value * 2 * 3.14159;
    final x =
        initialOffset.dx +
        30 * (index % 3 + 1) * (0.5 + 0.5 * sin(animationOffset + index * 0.5));
    final y =
        initialOffset.dy +
        40 *
            (index % 2 + 1) *
            (0.5 + 0.5 * cos(animationOffset * 0.8 + index * 0.3));

    return Positioned(
      left: x % MediaQuery.of(context).size.width,
      top: y % MediaQuery.of(context).size.height,
      child: Container(
        width: 2 + (index % 3),
        height: 2 + (index % 3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: [
            AppColors.primary,
            AppColors.secondary,
            AppColors.tertiary,
          ][index % 3].withOpacity(0.6),
          boxShadow: [
            BoxShadow(
              color: [
                AppColors.primary,
                AppColors.secondary,
                AppColors.tertiary,
              ][index % 3].withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
