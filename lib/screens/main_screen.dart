import 'package:_nehadam/screens/login_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/smoong_camera.png',
                  width: 160,
                  height: 160,
                ),
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'assets/img/main_nehadam.jpg',
                  width: 160,
                  height: 250,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white70, width: 2),
                ),
                child: const Text(
                  "네컷에 하루\n\n\n담으러 가기",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black38,
                    fontFamily: 'NanumPenScript',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
