// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:confetti/confetti.dart';

// class WishScreen extends StatefulWidget {
//   const WishScreen({super.key});

//   @override
//   State<WishScreen> createState() => _WishScreenState();
// }

// class _WishScreenState extends State<WishScreen> with TickerProviderStateMixin {
//   late ConfettiController _confettiController;
//   late AnimationController _cardController;
//   late Animation<double> _cardAnimation;
//   bool _showConfetti = false;

//   @override
//   void initState() {
//     super.initState();
//     _confettiController = ConfettiController(
//       duration: const Duration(seconds: 5),
//     );

//     _cardController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _cardAnimation = CurvedAnimation(
//       parent: _cardController,
//       curve: Curves.elasticOut,
//     );

//     _cardController.forward();
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     _cardController.dispose();
//     super.dispose();
//   }

//   void _celebrate() {
//     setState(() {
//       _showConfetti = true;
//     });
//     _confettiController.play();

//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) {
//         setState(() {
//           _showConfetti = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFFFD3A5), Color(0xFFFD6585), Color(0xFFC44569)],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Animated background
//             ...List.generate(15, (index) => _buildFloatingParticle(index)),

//             // Main content
//             SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 60),

//                     // Cake Lottie animation
//                     SizedBox(
//                       width: 250,
//                       height: 250,
//                       child: Lottie.network(
//                         'https://assets9.lottiefiles.com/packages/lf20_u4yrau.json',
//                         fit: BoxFit.contain,
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     // Birthday card
//                     ScaleTransition(
//                       scale: _cardAnimation,
//                       child: Container(
//                         padding: const EdgeInsets.all(30),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 30,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Happy Birthday!',
//                               style: GoogleFonts.greatVibes(
//                                 fontSize: 48,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFFFF6B9D),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Text(
//                               'Wishing you a day filled with love, laughter, and endless joy! May all your dreams come true and may this year bring you countless blessings. You deserve all the happiness in the world!',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 color: Colors.grey[700],
//                                 height: 1.6,
//                               ),
//                             ),
//                             const SizedBox(height: 30),

//                             // Celebrate button
//                             ElevatedButton(
//                               onPressed: _celebrate,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFFFF6B9D),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 50,
//                                   vertical: 18,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 elevation: 10,
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     'Celebrate',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   const Text(
//                                     '🎉',
//                                     style: TextStyle(fontSize: 24),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 40),

//                     // Balloons animation
//                     if (_showConfetti)
//                       SizedBox(
//                         width: 200,
//                         height: 200,
//                         child: Lottie.network(
//                           'https://assets10.lottiefiles.com/packages/lf20_rovf9gzu.json',
//                         ),
//                       ),

//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),

//             // Confetti overlay
//             Align(
//               alignment: Alignment.topCenter,
//               child: ConfettiWidget(
//                 confettiController: _confettiController,
//                 blastDirection: 3.14 / 2,
//                 emissionFrequency: 0.05,
//                 numberOfParticles: 20,
//                 gravity: 0.1,
//                 blastDirectionality: BlastDirectionality.explosive,
//                 colors: const [
//                   Color(0xFFFF6B9D),
//                   Color(0xFFFFA07A),
//                   Color(0xFFFFD700),
//                   Color(0xFF98D8C8),
//                   Color(0xFF6C5B7B),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFloatingParticle(int index) {
//     final random = index * 47;
//     final left = (random % 100).toDouble();
//     final size = 15 + (random % 25).toDouble();
//     final duration = 4 + (random % 3);

//     return Positioned(
//       left: MediaQuery.of(context).size.width * (left / 100),
//       bottom: -50,
//       child: TweenAnimationBuilder(
//         tween: Tween<double>(begin: 0, end: 1),
//         duration: Duration(seconds: duration),
//         builder: (context, value, child) {
//           return Transform.translate(
//             offset: Offset(
//               20 * (index % 2 == 0 ? 1 : -1) * value,
//               -MediaQuery.of(context).size.height * value,
//             ),
//             child: Opacity(
//               opacity: 1 - (value * 0.5),
//               child: Text(
//                 ['🎈', '🎁', '⭐', '💝', '🎊'][index % 5],
//                 style: TextStyle(fontSize: size),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

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
  late Animation<double> _letterSlideAnimation;
  late Animation<double> _letterRotateAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool showMain = false;
  bool showLetter = false;
  bool isCelebrating = false;
  List<TapPosition> tapPositions = [];

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

    _letterSlideAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(parent: _letterController, curve: Curves.easeOutBack),
    );

    _letterRotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _letterController, curve: Curves.elasticOut),
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => showMain = true);
        confetti.play();
      }
    });
  }

  @override
  void dispose() {
    confetti.dispose();
    _shimmerController.dispose();
    _floatController.dispose();
    _letterController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    final newTap = TapPosition(
      position: details.globalPosition,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      tapPositions.add(newTap);
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          tapPositions.removeWhere((tap) => tap.timestamp == newTap.timestamp);
        });
      }
    });
  }

  Future<void> _celebrate() async {
    if (isCelebrating) return;

    setState(() => isCelebrating = true);

    // Play birthday music
    try {
      await _audioPlayer.play(
        UrlSource(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        ),
      );
    } catch (e) {
      debugPrint('Audio error: $e');
    }

    // Continuous confetti for 6 seconds
    for (int i = 0; i < 6; i++) {
      confetti.play();
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    setState(() => isCelebrating = false);
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
                      colors: [
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

            // Party Poppers from tap positions
            ...tapPositions.map((tap) => _buildPartyPopper(tap.position)),

            // Main Content
            Center(
              child: AnimatedOpacity(
                opacity: showMain ? 1 : 0,
                duration: const Duration(milliseconds: 1500),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),

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
                            return LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.pinkAccent.shade100,
                                Colors.white,
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            "Happy Birthday",
                            style: GoogleFonts.greatVibes(
                              fontSize: 70,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.pink.shade300,
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
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 10),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Premium Glass Card
                      Container(
                        width: 350,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.3),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Lottie Animation
                                  Lottie.network(
                                    "https://lottie.host/9ffdf7d6-f44e-4b9a-b9b3-1401fbf95de1/07HQ2eew9f.json",
                                    width: 180,
                                    height: 180,
                                  ),

                                  const SizedBox(height: 20),

                                  Text(
                                    "I hope your heart smiles today,\nbecause you deserve the world —\nand a little more. ✨💝",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.white,
                                      height: 1.7,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Celebrate Button with Music
                                  ElevatedButton.icon(
                                    onPressed: _celebrate,
                                    icon:
                                        isCelebrating
                                            ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.pinkAccent),
                                              ),
                                            )
                                            : Icon(
                                              Icons.celebration,
                                              color: Colors.pinkAccent,
                                            ),
                                    label: Text(
                                      isCelebrating
                                          ? "Playing 🎵"
                                          : "Celebrate 🎉",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.pinkAccent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 10,
                                      shadowColor: Colors.pink.withOpacity(0.5),
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // Gift Letter Button
                                  OutlinedButton.icon(
                                    onPressed: _openLetter,
                                    icon: Icon(Icons.card_giftcard, size: 24),
                                    label: Text(
                                      "Open Gift 🎁",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.8),
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 35,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Tap anywhere hint
                                  Text(
                                    "💡 Tap anywhere for party poppers!",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.9),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            // Confetti Overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 30,
                gravity: 0.3,
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

  // Animated Letter Overlay
  Widget _buildLetterOverlay() {
    return AnimatedBuilder(
      animation: _letterController,
      builder: (context, child) {
        return Stack(
          children: [
            // Dark backdrop
            GestureDetector(
              onTap: _closeLetter,
              child: AnimatedOpacity(
                opacity: 1 - _letterSlideAnimation.value,
                duration: Duration.zero,
                child: Container(color: Colors.black54),
              ),
            ),

            // Animated Letter
            Center(
              child: Transform.translate(
                offset: Offset(
                  0,
                  MediaQuery.of(context).size.height *
                      _letterSlideAnimation.value,
                ),
                child: Transform.rotate(
                  angle: _letterRotateAnimation.value,
                  child: Container(
                    width: 360,
                    height: 520,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF8E7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 40,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative Border Pattern
                        Positioned.fill(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.pink.shade200,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        // Letter Content
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              // Decorative hearts at top
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.pink,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.pink.shade300,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.pink,
                                    size: 22,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              // Greeting
                              Text(
                                "Dear ${widget.name},",
                                style: GoogleFonts.dancingScript(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink.shade700,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Message content
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    "On this special day, I want you to know how incredibly amazing you are. Your smile lights up every room, your kindness touches every heart, and your presence makes the world a better place.\n\n"
                                    "May this year bring you countless reasons to smile, endless opportunities to grow, and beautiful moments that take your breath away.\n\n"
                                    "You deserve all the happiness in the universe and more. Keep shining, keep smiling, and never forget how truly special you are!\n\n"
                                    "With all my love and warm wishes,\nHappy Birthday! 🎂✨💝",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.brown.shade800,
                                      height: 1.8,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Close Button
                              ElevatedButton(
                                onPressed: _closeLetter,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink.shade400,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 8,
                                ),
                                child: Text(
                                  "Close Letter 💌",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
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
          ],
        );
      },
    );
  }

  // Party Popper Animation
  Widget _buildPartyPopper(Offset position) {
    return Positioned(
      left: position.dx - 60,
      top: position.dy - 60,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 2000),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 1 + (value * 0.5),
            child: Opacity(
              opacity: 1 - value,
              child: Container(
                width: 120,
                height: 120,
                child: Stack(
                  children: List.generate(16, (index) {
                    final angle = (index * 22.5) * math.pi / 180;
                    final distance = 60 * value;
                    return Transform.translate(
                      offset: Offset(
                        math.cos(angle) * distance,
                        math.sin(angle) * distance,
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: value * math.pi * 3,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color:
                                  [
                                    Colors.pink,
                                    Colors.yellow,
                                    Colors.orange,
                                    Colors.purple,
                                    Colors.red,
                                    Colors.blue,
                                  ][index % 6],
                              shape:
                                  index % 3 == 0
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                              borderRadius:
                                  index % 3 != 0
                                      ? BorderRadius.circular(2)
                                      : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Floating Hearts
  Widget _floatingParticles(int i) {
    return TweenAnimationBuilder(
      key: ValueKey('heart_$i'),
      tween: Tween<double>(begin: 1, end: 0),
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
                      Colors.pink.shade300,
                      Colors.red.shade300,
                      Colors.purple.shade300,
                      Colors.orange.shade300,
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

// Helper class for tap positions
class TapPosition {
  final Offset position;
  final int timestamp;

  TapPosition({required this.position, required this.timestamp});
}
