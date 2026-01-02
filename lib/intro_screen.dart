import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
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
  late AnimationController _ledController;
  late AnimationController _blastController;
  late AnimationController _cardPulseController;
  late AnimationController _shimmerController;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _blastAnimation;
  late Animation<double> _cardPulseAnimation;

  // Timer countdown
  int _remainingSeconds = 10;
  Timer? _countdownTimer;
  bool _isBlasting = false;

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

    _ledController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _blastController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

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

    _blastAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _blastController, curve: Curves.easeOut));

    _cardPulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _cardPulseController, curve: Curves.easeInOut),
    );

    _controller.forward();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _triggerBlast();
      }
    });
  }

  void _triggerBlast() async {
    setState(() => _isBlasting = true);
    _blastController.forward();
    _confettiController.play();

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/blast.mp3'));
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 1200));
    _navigateToWish();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _ledController.dispose();
    _blastController.dispose();
    _cardPulseController.dispose();
    _shimmerController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _navigateToWish() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                const WishScreen(name: "Beautiful"),
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
        onTap: _remainingSeconds > 0 ? null : _triggerBlast,
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

            // LED Lights on top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _ledController,
                builder: (context, child) {
                  return Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(15, (index) {
                        final offset =
                            (index * 0.2 + _ledController.value) % 1.0;
                        final opacity =
                            (math.sin(offset * math.pi * 2) + 1) / 2;
                        return Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.red,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue,
                              Colors.purple,
                            ][index % 5].withOpacity(opacity),
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.red,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                ][index % 5].withOpacity(opacity),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),

            // Floating GIFs (Hearts and Gifts)
            ...List.generate(20, (index) => _buildFloatingEmoji(index)),

            // Sparkle Overlay
            Positioned.fill(
              child: CustomPaint(
                painter: SparklePainter(animation: _pulseController),
              ),
            ),

            // Blast Effect
            if (_isBlasting)
              AnimatedBuilder(
                animation: _blastAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Transform.scale(
                      scale: 15 * _blastAnimation.value,
                      child: Opacity(
                        opacity: 1 - _blastAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.yellow.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Main content with PREMIUM CARD
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.minHeight,
                      ),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // PREMIUM CARD CONTAINER
                              AnimatedBuilder(
                                animation: _cardPulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _cardPulseAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 390,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFFFFF),
                                        Color(0xFFFFFAFC),
                                        Color(0xFFFFFFFF),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF69B4,
                                        ).withOpacity(0.6),
                                        blurRadius: 60,
                                        spreadRadius: 8,
                                        offset: const Offset(0, 25),
                                      ),
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.4),
                                        blurRadius: 50,
                                        spreadRadius: -5,
                                        offset: const Offset(0, 20),
                                      ),
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.3),
                                        blurRadius: 40,
                                        spreadRadius: -10,
                                        offset: const Offset(0, 15),
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.9),
                                        blurRadius: 25,
                                        offset: const Offset(-12, -12),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(37),
                                        border: Border.all(
                                          width: 2,
                                          color: const Color(
                                            0xFFFFB3C1,
                                          ).withOpacity(0.4),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(35),
                                        child: Container(
                                          padding: const EdgeInsets.all(40),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.white.withOpacity(0.98),
                                                const Color(0xFFFFFAFD),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              // Premium Top Badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 28,
                                                      vertical: 10,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFFF69B4),
                                                          Color(0xFFFF8FB4),
                                                          Color(0xFFFFB3C1),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFFFF69B4,
                                                      ).withOpacity(0.5),
                                                      blurRadius: 20,
                                                      offset: const Offset(
                                                        0,
                                                        8,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.celebration,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "✨ Count Down ✨",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                            letterSpacing: 1,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 30),

                                              // Countdown Timer - Premium Style
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 35,
                                                      vertical: 20,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFFFFF5F7),
                                                      const Color(
                                                        0xFFFFE5EC,
                                                      ).withOpacity(0.8),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFFFB3C1,
                                                    ).withOpacity(0.4),
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFFFF69B4,
                                                      ).withOpacity(0.2),
                                                      blurRadius: 15,
                                                      offset: const Offset(
                                                        0,
                                                        5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFFFF69B4,
                                                                ),
                                                                Color(
                                                                  0xFFFF8FB4,
                                                                ),
                                                              ],
                                                            ),
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(
                                                              0xFFFF69B4,
                                                            ).withOpacity(0.4),
                                                            blurRadius: 10,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.timer,
                                                        color: Colors.white,
                                                        size: 28,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    AnimatedBuilder(
                                                      animation:
                                                          _shimmerController,
                                                      builder: (
                                                        context,
                                                        child,
                                                      ) {
                                                        return ShaderMask(
                                                          shaderCallback: (
                                                            bounds,
                                                          ) {
                                                            return LinearGradient(
                                                              colors: const [
                                                                Color(
                                                                  0xFFFF69B4,
                                                                ),
                                                                Color(
                                                                  0xFFFF1493,
                                                                ),
                                                                Color(
                                                                  0xFFFF69B4,
                                                                ),
                                                              ],
                                                              stops: [
                                                                0.0,
                                                                _shimmerController
                                                                    .value,
                                                                1.0,
                                                              ],
                                                            ).createShader(
                                                              bounds,
                                                            );
                                                          },
                                                          child: Text(
                                                            '00:${_remainingSeconds.toString().padLeft(2, '0')}',
                                                            style:
                                                                GoogleFonts.orbitron(
                                                                  fontSize: 40,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  letterSpacing:
                                                                      3,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 35),

                                              // Gift emoji animation with premium circle
                                              AnimatedBuilder(
                                                animation: _pulseAnimation,
                                                builder: (context, child) {
                                                  return Transform.scale(
                                                    scale:
                                                        _pulseAnimation.value,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            30,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: RadialGradient(
                                                          colors: [
                                                            const Color(
                                                              0xFFFFB3C1,
                                                            ).withOpacity(0.3),
                                                            const Color(
                                                              0xFFFF69B4,
                                                            ).withOpacity(0.1),
                                                            Colors.transparent,
                                                          ],
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(
                                                              0xFFFF69B4,
                                                            ).withOpacity(
                                                              0.4 *
                                                                  _pulseAnimation
                                                                      .value,
                                                            ),
                                                            blurRadius:
                                                                40 *
                                                                _pulseAnimation
                                                                    .value,
                                                            spreadRadius:
                                                                10 *
                                                                _pulseAnimation
                                                                    .value,
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Text(
                                                        '🎁',
                                                        style: TextStyle(
                                                          fontSize: 100,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),

                                              const SizedBox(height: 35),

                                              // Main text with shimmer effect
                                              ShaderMask(
                                                shaderCallback: (bounds) {
                                                  return LinearGradient(
                                                    colors: [
                                                      const Color(0xFFFF69B4),
                                                      const Color(0xFFFF1493),
                                                      const Color(0xFFFF69B4),
                                                    ],
                                                  ).createShader(bounds);
                                                },
                                                child: Text(
                                                  'Something Special\nIs Coming...',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.greatVibes(
                                                    fontSize: 48,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 25),

                                              // Bottom message box
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 15,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFFFFF5F7),
                                                      const Color(
                                                        0xFFFFE5EC,
                                                      ).withOpacity(0.6),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFFFB3C1,
                                                    ).withOpacity(0.3),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      '🎉',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      'Get ready!',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 18,
                                                            color: const Color(
                                                              0xFFFF1493,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 0.5,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      '🎉',
                                                      style: TextStyle(
                                                        fontSize: 20,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Confetti
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 50,
                gravity: 0.3,
                colors: const [
                  Colors.pink,
                  Colors.yellow,
                  Colors.orange,
                  Colors.purple,
                  Colors.red,
                  Colors.blue,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingEmoji(int index) {
    final emojis = ['❤️', '💝', '🎁', '🎈', '⭐', '💖', '🎉', '✨'];
    final random = index * 47;
    final left = (random % 100).toDouble();
    final duration = 4 + (random % 5);
    final size = 25.0 + (random % 20).toDouble();

    return Positioned(
      left: MediaQuery.of(context).size.width * (left / 100),
      bottom: -50,
      child: TweenAnimationBuilder(
        key: ValueKey('emoji_$index'),
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
                opacity: (1 - value) * 0.9,
                child: Text(
                  emojis[index % emojis.length],
                  style: TextStyle(
                    fontSize: size,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
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
