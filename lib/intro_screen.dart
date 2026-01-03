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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive scaling factors
    final cardWidth = width * 0.9;
    final cardPadding = width * 0.08;
    final ledHeight = height * 0.07;
    final ledSize = width * 0.04;

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

            // LED Lights on top - RESPONSIVE
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _ledController,
                builder: (context, child) {
                  return Container(
                    height: ledHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(15, (index) {
                        final offset =
                            (index * 0.2 + _ledController.value) % 1.0;
                        final opacity =
                            (math.sin(offset * math.pi * 2) + 1) / 2;
                        return Container(
                          width: ledSize,
                          height: ledSize,
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
                                blurRadius: width * 0.04,
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

            // Main content with PREMIUM CARD - RESPONSIVE
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
                              // PREMIUM CARD CONTAINER - RESPONSIVE
                              AnimatedBuilder(
                                animation: _cardPulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _cardPulseAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: cardWidth,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      width * 0.1,
                                    ),
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
                                        blurRadius: width * 0.15,
                                        spreadRadius: 8,
                                        offset: Offset(0, height * 0.03),
                                      ),
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.4),
                                        blurRadius: width * 0.12,
                                        spreadRadius: -5,
                                        offset: Offset(0, height * 0.025),
                                      ),
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.3),
                                        blurRadius: width * 0.1,
                                        spreadRadius: -10,
                                        offset: Offset(0, height * 0.018),
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.9),
                                        blurRadius: width * 0.06,
                                        offset: Offset(
                                          -width * 0.03,
                                          -width * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        width * 0.1,
                                      ),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          width * 0.092,
                                        ),
                                        border: Border.all(
                                          width: 2,
                                          color: const Color(
                                            0xFFFFB3C1,
                                          ).withOpacity(0.4),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          width * 0.087,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(cardPadding),
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
                                              // Premium Top Badge - RESPONSIVE
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.07,
                                                  vertical: height * 0.012,
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
                                                      BorderRadius.circular(
                                                        width * 0.06,
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFFFF69B4,
                                                      ).withOpacity(0.5),
                                                      blurRadius: width * 0.05,
                                                      offset: Offset(
                                                        0,
                                                        height * 0.01,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.celebration,
                                                      color: Colors.white,
                                                      size: width * 0.05,
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.02,
                                                    ),
                                                    Text(
                                                      "✨ Count Down ✨",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize:
                                                                width * 0.038,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                            letterSpacing: 1,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: height * 0.035),

                                              // Countdown Timer - RESPONSIVE
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.087,
                                                  vertical: height * 0.024,
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
                                                      BorderRadius.circular(
                                                        width * 0.075,
                                                      ),
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
                                                      blurRadius: width * 0.037,
                                                      offset: Offset(
                                                        0,
                                                        height * 0.006,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        width * 0.025,
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
                                                            blurRadius:
                                                                width * 0.025,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.timer,
                                                        color: Colors.white,
                                                        size: width * 0.07,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.037,
                                                    ),
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
                                                                  fontSize:
                                                                      width *
                                                                      0.1,
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

                                              SizedBox(height: height * 0.04),

                                              // Gift emoji - RESPONSIVE
                                              AnimatedBuilder(
                                                animation: _pulseAnimation,
                                                builder: (context, child) {
                                                  return Transform.scale(
                                                    scale:
                                                        _pulseAnimation.value,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        width * 0.075,
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
                                                                width *
                                                                0.1 *
                                                                _pulseAnimation
                                                                    .value,
                                                            spreadRadius:
                                                                width *
                                                                0.025 *
                                                                _pulseAnimation
                                                                    .value,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        '🎁',
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * 0.25,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),

                                              SizedBox(height: height * 0.04),

                                              // Main text - RESPONSIVE
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
                                                    fontSize: width * 0.12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: height * 0.03),

                                              // Bottom message - RESPONSIVE
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.075,
                                                  vertical: height * 0.018,
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
                                                      BorderRadius.circular(
                                                        width * 0.062,
                                                      ),
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
                                                    Text(
                                                      '🎉',
                                                      style: TextStyle(
                                                        fontSize: width * 0.05,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.025,
                                                    ),
                                                    Text(
                                                      'Get ready!',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize:
                                                                width * 0.045,
                                                            color: const Color(
                                                              0xFFFF1493,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 0.5,
                                                          ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.025,
                                                    ),
                                                    Text(
                                                      '🎉',
                                                      style: TextStyle(
                                                        fontSize: width * 0.05,
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
    final size = MediaQuery.of(context).size;
    final emojis = ['❤️', '💝', '🎁', '🎈', '⭐', '💖', '🎉', '✨'];
    final random = index * 47;
    final left = (random % 100).toDouble();
    final duration = 4 + (random % 5);
    final emojiSize = size.width * 0.06 + (random % 20).toDouble();

    return Positioned(
      left: size.width * (left / 100),
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
              -size.height * 1.2 * value,
            ),
            child: Transform.rotate(
              angle: value * math.pi * 4,
              child: Opacity(
                opacity: (1 - value) * 0.9,
                child: Text(
                  emojis[index % emojis.length],
                  style: TextStyle(
                    fontSize: emojiSize,
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
