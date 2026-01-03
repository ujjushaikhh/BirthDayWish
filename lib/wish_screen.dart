import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class WishScreen extends StatefulWidget {
  final String name;
  const WishScreen({super.key, this.name = "My Love"});

  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> with TickerProviderStateMixin {
  late ConfettiController confetti;
  late AnimationController _shimmerController;
  late AnimationController _floatController;
  late AnimationController _letterController;
  late AnimationController _cardPulseController;
  late Animation<double> _letterSlideAnimation;
  late Animation<double> _letterRotateAnimation;
  late Animation<double> _letterScaleAnimation;
  late Animation<double> _cardPulseAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool showMain = false;
  bool showLetter = false;
  bool isCelebrating = false;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();

    confetti = ConfettiController(duration: const Duration(seconds: 4));

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _letterController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _cardPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _letterSlideAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _letterController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _letterRotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _letterController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _letterScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _letterController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _cardPulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _cardPulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => showMain = true);
        confetti.play();
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () async {
      try {
        await _audioPlayer.play(AssetSource('audio/happybirthday.mp3'));
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    confetti.dispose();
    _shimmerController.dispose();
    _floatController.dispose();
    _letterController.dispose();
    _cardPulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) async {
    setState(() {
      _tapPosition = details.globalPosition;
    });
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/blast.mp3'));
      confetti.play();
    } catch (_) {}
  }

  void _openLetter() {
    setState(() => showLetter = true);
    _letterController.forward();
  }

  void _closeLetter() {
    _letterController.reverse().then((_) {
      if (mounted) {
        setState(() => showLetter = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Stack(
          children: [
            // Premium Animated Background with shimmer
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFFff9a9e),
                        Color(0xFFfad0c4),
                        Color(0xFFffeaa7),
                        Color(0xFFfcb69f),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        0.0,
                        _shimmerController.value * 0.4,
                        _shimmerController.value * 0.7,
                        1.0,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Floating Hearts
            ...List.generate(18, (i) => _floatingParticles(i)),

            // LOTTIE ANIMATIONS - RESPONSIVE

            // Sparkles Burst - Top Left Corner
            Positioned(
              top: height * 0.05,
              left: width * 0.02,
              child: Lottie.asset(
                'assets/lottie/Sparkles_burst.json',
                width: width * 0.5,
                height: height * 0.25,
                fit: BoxFit.contain,
              ),
            ),

            // Fireworks - Top Right Corner
            Positioned(
              top: height * 0.04,
              right: width * 0.01,
              child: Lottie.asset(
                'assets/lottie/Fireworks.json',
                width: width * 0.58,
                height: height * 0.28,
                fit: BoxFit.contain,
              ),
            ),

            // Blast/Confetti Rain - Top Center (falling effect)
            Positioned(
              top: 0,
              left: width * 0.25,
              child: Lottie.asset(
                'assets/lottie/Confetti.json',
                width: width * 0.42,
                height: height * 0.21,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              top: 0,
              right: width * 0.25,
              child: Lottie.asset(
                'assets/lottie/PartyPopper.json',
                width: width * 0.42,
                height: height * 0.21,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              top: 0,
              left: width * 0.25,
              child: Lottie.asset(
                'assets/lottie/Blast.json',
                width: width * 0.5,
                height: height * 0.31,
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),

            // Balloons - Bottom Right Corner
            Positioned(
              bottom: height * 0.075,
              right: width * 0.025,
              child: Lottie.asset(
                'assets/lottie/Balloons.json',
                width: width * 0.75,
                height: height * 0.37,
                fit: BoxFit.contain,
              ),
            ),

            // Gift/Present - Bottom Left Corner
            Positioned(
              bottom: height * 0.087,
              left: width * 0.025,
              child: Lottie.asset(
                'assets/lottie/Balloons.json',
                width: width * 0.75,
                height: height * 0.37,
                fit: BoxFit.contain,
              ),
            ),

            // Main Content - RESPONSIVE
            Center(
              child: AnimatedOpacity(
                opacity: showMain ? 1 : 0,
                duration: const Duration(milliseconds: 1500),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.1),

                      // Animated floating title - RESPONSIVE
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 10 * _floatController.value),
                            child: child,
                          );
                        },
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xFFFFB3C1),
                                Colors.white,
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            "Happy Birthday",
                            style: GoogleFonts.greatVibes(
                              fontSize: width * 0.175,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  color: Color(0xFFFF69B4),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.012),

                      Text(
                        widget.name,
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.08,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          shadows: const [
                            Shadow(color: Colors.black26, blurRadius: 10),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      // PREMIUM CARD - RESPONSIVE
                      AnimatedBuilder(
                        animation: _cardPulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cardPulseAnimation.value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: width * 0.9,
                          margin: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.087),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFFFFF),
                                Color(0xFFFFF5F7),
                                Color(0xFFFFFFFF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF69B4).withOpacity(0.4),
                                blurRadius: width * 0.125,
                                spreadRadius: 5,
                                offset: Offset(0, height * 0.025),
                              ),
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: width * 0.1,
                                spreadRadius: -5,
                                offset: Offset(0, height * 0.018),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.9),
                                blurRadius: width * 0.05,
                                offset: Offset(-width * 0.025, -width * 0.025),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                width * 0.087,
                              ),
                              border: Border.all(width: 3, color: Colors.white),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  width * 0.08,
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: const Color(
                                    0xFFFFB3C1,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  width * 0.075,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(width * 0.087),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.95),
                                        const Color(0xFFFFFAFD),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // Decorative top element - RESPONSIVE
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.062,
                                          vertical: height * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF69B4),
                                              Color(0xFFFFB3C1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            width * 0.05,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFFF69B4,
                                              ).withOpacity(0.4),
                                              blurRadius: width * 0.037,
                                              offset: Offset(0, height * 0.006),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "✨ Special Day ✨",
                                          style: GoogleFonts.poppins(
                                            fontSize: width * 0.035,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: height * 0.031),

                                      // Central Lottie Animation - RESPONSIVE
                                      Container(
                                        height: height * 0.22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              const Color(
                                                0xFFFFB3C1,
                                              ).withOpacity(0.2),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        child: Lottie.asset(
                                          'assets/lottie/pink_cake.json',
                                          width: width * 0.45,
                                          height: height * 0.22,
                                          fit: BoxFit.contain,
                                        ),
                                      ),

                                      SizedBox(height: height * 0.031),

                                      // Message with decorative elements - RESPONSIVE
                                      Container(
                                        padding: EdgeInsets.all(width * 0.05),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF5F7),
                                          borderRadius: BorderRadius.circular(
                                            width * 0.05,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFFFFB3C1,
                                            ).withOpacity(0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          "I hope your heart smiles today,\nbecause you deserve the world —\nand a little more. ✨💝",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: width * 0.041,
                                            color: const Color(0xFF333333),
                                            height: 1.8,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: height * 0.037),

                                      // Premium Gift Button - RESPONSIVE
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            width * 0.075,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF69B4),
                                              Color(0xFFFF8FB4),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFFF69B4,
                                              ).withOpacity(0.5),
                                              blurRadius: width * 0.05,
                                              offset: Offset(0, height * 0.012),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: _openLetter,
                                          icon: Icon(
                                            Icons.card_giftcard,
                                            size: width * 0.06,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            "Open Gift 🎁",
                                            style: GoogleFonts.poppins(
                                              fontSize: width * 0.042,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.1,
                                              vertical: height * 0.022,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    width * 0.075,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: height * 0.018),

                                      // Tap hint with icon - RESPONSIVE
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.touch_app,
                                            color: const Color(
                                              0xFFFF69B4,
                                            ).withOpacity(0.7),
                                            size: width * 0.045,
                                          ),
                                          SizedBox(width: width * 0.02),
                                          Text(
                                            "Tap anywhere for magic ✨",
                                            style: GoogleFonts.poppins(
                                              fontSize: width * 0.032,
                                              color: const Color(0xFF666666),
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.1),
                    ],
                  ),
                ),
              ),
            ),

            // Confetti Overlay - Position based on tap
            if (_tapPosition != null)
              Positioned(
                left: _tapPosition!.dx,
                top: _tapPosition!.dy,
                child: ConfettiWidget(
                  confettiController: confetti,
                  blastDirection: 0,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 30,
                  gravity: 0.3,
                  emissionFrequency: 0.05,
                  colors: const [
                    Colors.pink,
                    Colors.white,
                    Colors.orange,
                    Colors.yellow,
                    Colors.purple,
                    Colors.red,
                  ],
                ),
              ),

            // Letter Overlay
            if (showLetter) _buildLetterOverlay(),
          ],
        ),
      ),
    );
  }

  // Animated Letter Overlay - RESPONSIVE
  Widget _buildLetterOverlay() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return AnimatedBuilder(
      animation: _letterController,
      builder: (context, child) {
        return Stack(
          children: [
            // Dark backdrop
            GestureDetector(
              onTap: _closeLetter,
              child: Container(
                color: Colors.black.withOpacity(
                  (0.7 * (1 - _letterSlideAnimation.value)).clamp(0.0, 0.7),
                ),
              ),
            ),

            // Animated Letter
            Center(
              child: Transform.translate(
                offset: Offset(0, height * _letterSlideAnimation.value),
                child: Transform.rotate(
                  angle: _letterRotateAnimation.value,
                  child: Transform.scale(
                    scale: _letterScaleAnimation.value,
                    child: Container(
                      width: width * 0.9,
                      height: height * 0.65,
                      margin: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(width * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: width * 0.1,
                            offset: Offset(0, height * 0.018),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Decorative Border Pattern
                          Positioned.fill(
                            child: Container(
                              margin: EdgeInsets.all(width * 0.05),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFFC0CB),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  width * 0.037,
                                ),
                              ),
                            ),
                          ),

                          // Letter Content
                          Padding(
                            padding: EdgeInsets.all(width * 0.1),
                            child: Column(
                              children: [
                                // Decorative hearts at top - RESPONSIVE
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: const Color(0xFFFF69B4),
                                      size: width * 0.055,
                                    ),
                                    SizedBox(width: width * 0.025),
                                    Icon(
                                      Icons.favorite,
                                      color: const Color(0xFFFFC0CB),
                                      size: width * 0.045,
                                    ),
                                    SizedBox(width: width * 0.025),
                                    Icon(
                                      Icons.favorite,
                                      color: const Color(0xFFFF69B4),
                                      size: width * 0.055,
                                    ),
                                  ],
                                ),

                                SizedBox(height: height * 0.031),

                                // Greeting - RESPONSIVE
                                Text(
                                  "Dear ${widget.name},",
                                  style: GoogleFonts.dancingScript(
                                    fontSize: width * 0.08,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD14D72),
                                  ),
                                ),

                                SizedBox(height: height * 0.031),

                                // Message content - RESPONSIVE
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      "On this special day, I want you to know how incredibly amazing you are. Your smile lights up every room, your kindness touches every heart, and your presence makes the world a better place.\n\n"
                                      "May this year bring you countless reasons to smile, endless opportunities to grow, and beautiful moments that take your breath away.\n\n"
                                      "You deserve all the happiness in the universe and more. Keep shining, keep smiling, and never forget how truly special you are!\n\n"
                                      "With all my love and warm wishes,\nHappy Birthday! 🎂✨💝",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: width * 0.037,
                                        color: const Color(0xFF654321),
                                        height: 1.8,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: height * 0.031),

                                // Close Button - RESPONSIVE
                                ElevatedButton(
                                  onPressed: _closeLetter,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF69B4),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.125,
                                      vertical: height * 0.017,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        width * 0.062,
                                      ),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: Text(
                                    "Close Letter 💌",
                                    style: GoogleFonts.poppins(
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
              ),
            ),
          ],
        );
      },
    );
  }

  // Floating Hearts - RESPONSIVE
  Widget _floatingParticles(int i) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return TweenAnimationBuilder<double>(
      key: ValueKey('heart_$i'),
      tween: Tween(begin: 1, end: 0),
      duration: Duration(seconds: 5 + (i % 4)),
      onEnd: () {
        if (mounted) setState(() {});
      },
      builder: (context, value, child) {
        return Positioned(
          left: (i * 60) % width,
          bottom: -30 + (height * (1 - value)),
          child: Opacity(
            opacity: value * 0.7,
            child: Transform.rotate(
              angle: value * math.pi * 2,
              child: Icon(
                Icons.favorite,
                color:
                    [
                      const Color(0xFFFFC0CB),
                      const Color(0xFFFF69B4),
                      const Color(0xFFDDA0DD),
                      const Color(0xFFFFB347),
                    ][i % 4],
                size: width * 0.037 + (i % 10).toDouble(),
              ),
            ),
          ),
        );
      },
    );
  }
}
