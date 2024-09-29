import 'dart:async';

import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 색상
      body: Center(
        child: SizedBox(
          width: double.infinity, // Ensure container takes full width
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensure column takes minimum height
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/img/nehadamlogin.png',
                  scale: 1,
                ),
                const SizedBox(
                  height: 80,
                ),
                InkWell(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white
                          // 투명 배경색 (카드 자체의 배경색을 보이게 함)
                          ),
                      child: Card(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/img/googlelogin.png', // Replace with your desired image
                          fit: BoxFit.contain, // Fit image within the card
                          width: double
                              .infinity, // Make the image expand to full width
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // 로그아웃하여 계정 선택
    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return; // 사용자가 로그인을 취소한 경우 처리
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //로그인 인증
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      if (value.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainFrameScreen()),
        );
      }
    }).onError((error, stackTrace) {
      print("error $error");
    });
  }
}
