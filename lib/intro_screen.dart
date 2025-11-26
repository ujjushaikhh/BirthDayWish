import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wish_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _navigateToWish() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                const WishScreen(name: "Beautiful"), // Change name here
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _navigateToWish,
        child: Stack(
          children: [
            // Animated Premium Background
            AnimatedBuilder(
              animation: _rotateController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: SweepGradient(
                      center: Alignment.center,
                      startAngle: _rotateController.value * 2 * math.pi,
                      endAngle:
                          (_rotateController.value * 2 * math.pi) +
                          (2 * math.pi),
                      colors: const [
                        Color(0xFFFF6B9D),
                        Color(0xFFFFA07A),
                        Color(0xFFFFD700),
                        Color(0xFFC06C84),
                        Color(0xFF6C5B7B),
                        Color(0xFF355C7D),
                        Color(0xFFFF6B9D),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Sparkle Overlay
            Positioned.fill(
              child: CustomPaint(
                painter: SparklePainter(animation: _pulseController),
              ),
            ),

            // Animated floating shapes
            ...List.generate(30, (index) => _buildFloatingShape(index)),

            // Main content with glass morphism
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Glass Card Container
                      Container(
                        width: 380,
                        padding: const EdgeInsets.all(40),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Column(
                                children: [
                                  // Premium Lottie animation
                                  SizedBox(
                                    width: 280,
                                    height: 280,
                                    child: Lottie.network(
                                      'https://lottie.host/d3c1b4b8-6d8f-4f3e-9b4d-1401fbf95de1/RKMKxJGFPz.json',
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Main text with shimmer effect
                                  ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.pink.shade100,
                                          Colors.white,
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      'A Special Gift\nAwaits You',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.greatVibes(
                                        fontSize: 52,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 20,
                                            color: Colors.pink.withOpacity(0.5),
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Pulsing gift emoji with glow
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _pulseAnimation.value,
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                blurRadius:
                                                    30 * _pulseAnimation.value,
                                                spreadRadius:
                                                    5 * _pulseAnimation.value,
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            '🎁',
                                            style: TextStyle(fontSize: 70),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 30),

                                  // Tap instruction
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.touch_app,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Tap anywhere to open',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingShape(int index) {
    final random = index * 47;
    final left = (random % 100).toDouble();
    final duration = 4 + (random % 5);
    final size = 15.0 + (random % 25).toDouble();

    final icons = [
      Icons.favorite,
      Icons.star,
      Icons.celebration,
      Icons.cake,
      Icons.card_giftcard,
    ];

    return Positioned(
      left: MediaQuery.of(context).size.width * (left / 100),
      bottom: -50,
      child: TweenAnimationBuilder(
        key: ValueKey(index),
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: duration),
        onEnd: () {
          if (mounted) setState(() {});
        },
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(
              30 * math.sin(value * math.pi * 2) * (index % 2 == 0 ? 1 : -1),
              -MediaQuery.of(context).size.height * 1.2 * value,
            ),
            child: Transform.rotate(
              angle: value * math.pi * 4,
              child: Opacity(
                opacity: (1 - value) * 0.8,
                child: Icon(
                  icons[index % icons.length],
                  color:
                      [
                        Colors.pink.shade200,
                        Colors.purple.shade200,
                        Colors.orange.shade200,
                        Colors.yellow.shade200,
                        Colors.white,
                      ][index % 5],
                  size: size,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter for sparkle effect
class SparklePainter extends CustomPainter {
  final Animation<double> animation;

  SparklePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final sparkleSize = 2 + random.nextDouble() * 3;

      final opacity = (math.sin(animation.value * math.pi * 2 + i) + 1) / 2;
      paint.color = Colors.white.withOpacity(opacity * 0.4);

      canvas.drawCircle(Offset(x, y), sparkleSize, paint);
    }
  }

  @override
  bool shouldRepaint(SparklePainter oldDelegate) => true;
}
