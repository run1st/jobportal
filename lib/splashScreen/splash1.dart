// import 'package:flutter/material.dart';
// import 'package:flutter/animation.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   AnimationController _controller;
//   Animation _revealAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 2));
//     _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue, // Replace with your desired color
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _revealAnimation,
//           builder: (context, child) => Stack(
//             children: [
//               // Form with opacity based on animation progress
//               Opacity(
//                 opacity: _revealAnimation.value,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   height: MediaQuery.of(context).size.height * 0.6,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Icon(Icons.description,
//                       size: 50.0), // Placeholder for form icon
//                 ),
//               ),
//               // Handshake image revealed after animation completes
//               Transform(
//                 opacity: 1.0 - _revealAnimation.value,
//                 child: Image.asset(
//                   'assets/images/handshake.png', // Replace with handshake image path
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
