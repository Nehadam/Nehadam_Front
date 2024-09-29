import 'package:_nehadam/screens/login_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variable to control the opacity of the image
  double _imageOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Delay for 1 second, then start the fade-in animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _imageOpacity = 1.0; // Make the image fully visible
      });
    });

    // Delay for 2 seconds, then navigate to LoginScreen with a slide transition
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin =
                Offset(1.0, 0.0); // Start the animation from the right
            const end = Offset.zero; // End at the current position
            const curve = Curves.easeInOut; // Smooth easing

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _imageOpacity,
                  duration: const Duration(seconds: 1), // Fade-in duration
                  child: Image.asset(
                    'assets/img/main_nehadam.jpg',
                    width: 160,
                    height: 250,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
