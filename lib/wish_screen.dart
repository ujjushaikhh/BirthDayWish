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

    // Determine if desktop/tablet
    final isDesktop = width > 900;
    final isTablet = width > 600 && width <= 900;

    return Scaffold(
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Stack(
          children: [
            // Premium Animated Background
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

            // LOTTIE ANIMATIONS - Responsive positioning
            Positioned(
              top: 40,
              left: 10,
              child: Lottie.asset(
                'assets/lottie/Sparkles_burst.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 30,
              right: 5,
              child: Lottie.asset(
                'assets/lottie/Fireworks.json',
                width: 230,
                height: 230,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              left: size.width * 0.25,
              child: Lottie.asset(
                'assets/lottie/Confetti.json',
                width: 170,
                height: 170,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              right: size.width * 0.25,
              child: Lottie.asset(
                'assets/lottie/PartyPopper.json',
                width: 170,
                height: 170,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              left: size.width * 0.25,
              child: Lottie.asset(
                'assets/lottie/Blast.json',
                width: size.width * 0.5,
                height: 250,
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
            Positioned(
              bottom: 60,
              right: 10,
              child: Lottie.asset(
                'assets/lottie/Balloons.json',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 70,
              left: 10,
              child: Lottie.asset(
                'assets/lottie/Balloons.json',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),

            // Main Content - PROPERLY RESPONSIVE
            Center(
              child: SafeArea(
                child: AnimatedOpacity(
                  opacity: showMain ? 1 : 0,
                  duration: const Duration(milliseconds: 1500),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 40 : 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: isDesktop ? 60 : 80),

                          // Animated floating title
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
                                  fontSize:
                                      isDesktop ? 80 : (isTablet ? 65 : 70),
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

                          const SizedBox(height: 10),

                          Text(
                            widget.name,
                            style: GoogleFonts.poppins(
                              fontSize: isDesktop ? 38 : (isTablet ? 34 : 32),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                              shadows: const [
                                Shadow(color: Colors.black26, blurRadius: 10),
                              ],
                            ),
                          ),

                          SizedBox(height: isDesktop ? 50 : 40),

                          // PREMIUM CARD - Fixed for all screen sizes
                          AnimatedBuilder(
                            animation: _cardPulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _cardPulseAnimation.value,
                                child: child,
                              );
                            },
                            child: Container(
                              width: isDesktop ? 500 : (isTablet ? 450 : 360),
                              constraints: BoxConstraints(
                                maxWidth: isDesktop ? 500 : 360,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
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
                                    color: const Color(
                                      0xFFFF69B4,
                                    ).withOpacity(0.4),
                                    blurRadius: 50,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 20),
                                  ),
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.3),
                                    blurRadius: 40,
                                    spreadRadius: -5,
                                    offset: const Offset(0, 15),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    blurRadius: 20,
                                    offset: const Offset(-10, -10),
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      width: 2,
                                      color: const Color(
                                        0xFFFFB3C1,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        isDesktop ? 40 : (isTablet ? 35 : 35),
                                      ),
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Decorative top badge
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: isDesktop ? 28 : 25,
                                              vertical: isDesktop ? 10 : 8,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF69B4),
                                                  Color(0xFFFFB3C1),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFFFF69B4,
                                                  ).withOpacity(0.4),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              "✨ Special Day ✨",
                                              style: GoogleFonts.poppins(
                                                fontSize: isDesktop ? 16 : 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: isDesktop ? 30 : 25),

                                          // Pink Cake Lottie
                                          Container(
                                            height:
                                                isDesktop
                                                    ? 200
                                                    : (isTablet ? 190 : 180),
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
                                              width:
                                                  isDesktop
                                                      ? 200
                                                      : (isTablet ? 190 : 180),
                                              height:
                                                  isDesktop
                                                      ? 200
                                                      : (isTablet ? 190 : 180),
                                              fit: BoxFit.contain,
                                            ),
                                          ),

                                          SizedBox(height: isDesktop ? 30 : 25),

                                          // Message
                                          Container(
                                            padding: EdgeInsets.all(
                                              isDesktop ? 22 : 20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFF5F7),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                fontSize:
                                                    isDesktop
                                                        ? 18
                                                        : (isTablet
                                                            ? 17
                                                            : 16.5),
                                                color: const Color(0xFF333333),
                                                height: 1.8,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: isDesktop ? 35 : 30),

                                          // Gift Button
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
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
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 10),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton.icon(
                                              onPressed: _openLetter,
                                              icon: Icon(
                                                Icons.card_giftcard,
                                                size: isDesktop ? 26 : 24,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                "Open Gift 🎁",
                                                style: GoogleFonts.poppins(
                                                  fontSize: isDesktop ? 18 : 17,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isDesktop ? 45 : 40,
                                                  vertical: isDesktop ? 20 : 18,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: isDesktop ? 18 : 15),

                                          // Tap hint
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.touch_app,
                                                color: const Color(
                                                  0xFFFF69B4,
                                                ).withOpacity(0.7),
                                                size: isDesktop ? 20 : 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Tap anywhere for magic ✨",
                                                style: GoogleFonts.poppins(
                                                  fontSize: isDesktop ? 14 : 13,
                                                  color: const Color(
                                                    0xFF666666,
                                                  ),
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

                          SizedBox(height: isDesktop ? 60 : 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Confetti Overlay
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

  Widget _buildLetterOverlay() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return AnimatedBuilder(
      animation: _letterController,
      builder: (context, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeLetter,
              child: Container(
                color: Colors.black.withOpacity(
                  (0.7 * (1 - _letterSlideAnimation.value)).clamp(0.0, 0.7),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, size.height * _letterSlideAnimation.value),
                child: Transform.rotate(
                  angle: _letterRotateAnimation.value,
                  child: Transform.scale(
                    scale: _letterScaleAnimation.value,
                    child: Container(
                      width: isDesktop ? 450 : 360,
                      height: isDesktop ? 600 : 520,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 40,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFFC0CB),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Color(0xFFFF69B4),
                                      size: 22,
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.favorite,
                                      color: Color(0xFFFFC0CB),
                                      size: 18,
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.favorite,
                                      color: Color(0xFFFF69B4),
                                      size: 22,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  "Dear ${widget.name},",
                                  style: GoogleFonts.dancingScript(
                                    fontSize: isDesktop ? 34 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD14D72),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      "On this special day, I want you to know how incredibly amazing you are. Your smile lights up every room, your kindness touches every heart, and your presence makes the world a better place.\n\n"
                                      "May this year bring you countless reasons to smile, endless opportunities to grow, and beautiful moments that take your breath away.\n\n"
                                      "You deserve all the happiness in the universe and more. Keep shining, keep smiling, and never forget how truly special you are!\n\n"
                                      "With all my love and warm wishes,\nHappy Birthday! 🎂✨💝",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: isDesktop ? 16 : 15,
                                        color: const Color(0xFF654321),
                                        height: 1.8,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: _closeLetter,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF69B4),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 55 : 50,
                                      vertical: isDesktop ? 16 : 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: Text(
                                    "Close Letter 💌",
                                    style: GoogleFonts.poppins(
                                      fontSize: isDesktop ? 17 : 16,
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

  Widget _floatingParticles(int i) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('heart_$i'),
      tween: Tween(begin: 1, end: 0),
      duration: Duration(seconds: 5 + (i % 4)),
      onEnd: () {
        if (mounted) setState(() {});
      },
      builder: (context, value, child) {
        return Positioned(
          left: (i * 60) % MediaQuery.of(context).size.width,
          bottom: -30 + (MediaQuery.of(context).size.height * (1 - value)),
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
                size: 15 + (i % 10).toDouble(),
              ),
            ),
          ),
        );
      },
    );
  }
}
