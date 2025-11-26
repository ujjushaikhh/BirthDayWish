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

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

class WishScreen extends StatefulWidget {
  final String name; // ⭐ Personalized name
  const WishScreen({super.key, this.name = "My Love"});

  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> with TickerProviderStateMixin {
  late ConfettiController confetti;
  bool showMain = false;

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 4));

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() => showMain = true);
      confetti.play();
    });
  }

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// PREMIUM BACKGROUND (soft shimmer + gradient)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFff9a9e),
                  Color(0xFFfad0c4),
                  Color(0xFFfcb69f),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Floating subtle particles (expensive feeling ✨)
          ...List.generate(18, (i) => _floatingParticles(i)),

          /// MAIN CONTENT
          Center(
            child: AnimatedOpacity(
              opacity: showMain ? 1 : 0,
              duration: const Duration(seconds: 2),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Necklace-style glowing text 💖
                  Text(
                    "Happy Birthday",
                    style: GoogleFonts.greatVibes(
                      fontSize: 70,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.pink.shade300, blurRadius: 25),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    widget.name, // <- Name shows beautifully
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      color: Colors.white.withOpacity(.95),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// Glass Card 💎 PREMIUM LOOK
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: 330,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(.35),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          Text(
                            "I hope your heart smiles today,\nbecause you deserve the world —\nand a little more. ✨💝",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Colors.white,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 22),

                          ElevatedButton(
                            onPressed: () {
                              confetti.play();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 45,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                            ),
                            child: Text(
                              "Celebrate 💖",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Lottie balloons (romantic luxury mode)
                  Lottie.network(
                    "https://lottie.host/9ffdf7d6-f44e-4b9a-b9b3-1401fbf95de1/07HQ2eew9f.json",
                    width: 160,
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.pink,
                Colors.white,
                Colors.orange,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Floating Premium Particles ✨ like luxury glitter
  Widget _floatingParticles(int i) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1, end: 0),
      duration: Duration(seconds: 4 + (i % 4)),
      builder: (context, value, child) {
        return Positioned(
          left: (i * 50) % MediaQuery.of(context).size.width,
          top: MediaQuery.of(context).size.height * value,
          child: Opacity(
            opacity: value,
            child: Icon(
              Icons.favorite,
              color: Colors.white.withOpacity(.8),
              size: 10 + (i % 8).toDouble(),
            ),
          ),
        );
      },
    );
  }
}
