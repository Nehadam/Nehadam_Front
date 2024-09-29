import 'package:_nehadam/screens/login_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variable to control the opacity of the text
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Delay for 1 second, then start the fade-in animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _textOpacity = 1.0; // Make the text fully visible
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
    return Scaffold(
      backgroundColor: const Color(0XFF9CB5DE),
      body: Center(
        child: AnimatedOpacity(
          opacity: _textOpacity,
          duration: const Duration(seconds: 1), // Fade-in duration
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '네하담',
                style: TextStyle(
                  fontSize: 40, // 네하담 글씨 크기
                  fontWeight: FontWeight.bold, // 글씨 두께
                  color: Colors.white, // 글씨 색깔
                ),
              ),
              SizedBox(height: 10), // 네하담과 내일의 하루를 담다 사이의 간격
              Text(
                '네컷에 하루를 담아요',
                style: TextStyle(
                  fontSize: 14, // 내일의 하루를 담다 글씨 크기
                  fontWeight: FontWeight.normal, // 글씨 두께
                  color: Colors.white, // 글씨 색깔
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
