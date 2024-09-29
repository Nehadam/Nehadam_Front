import 'package:flutter/material.dart';

class MyTutorialScreen extends StatelessWidget {
  const MyTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF9FBFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/data/contents/appguide.png'),
              const SizedBox(height: 100),
              const Text(
                '1. 앱에 로그인하기',
                style: TextStyle(
                  color: Color(0XFF334F78),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '앱에 로그인하고 닉네임을 변경하세요',
                style: TextStyle(
                  color: Color(0XFF628E9A),
                  fontSize: 12,
                  fontFamily: 'NanumPenScript',
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '2. 필터 선택',
                style: TextStyle(
                  color: Color(0XFF334F78),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '원하는 필터를 선택하세요.',
                style: TextStyle(
                  color: Color(0XFF628E9A),
                  fontSize: 12,
                  fontFamily: 'NanumPenScript',
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '3. 갤러리 및 드라이브에서 사진을 선택',
                style: TextStyle(
                  color: Color(0XFF334F78),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '변환하고 싶은 사진을 선택하세요.',
                style: TextStyle(
                  color: Color(0XFF628E9A),
                  fontSize: 12,
                  fontFamily: 'NanumPenScript',
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '4. 이미지 저장',
                style: TextStyle(
                  color: Color(0XFF334F78),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '이미지의 이름을 짓고 이를 저장하여 사용하세요.',
                style: TextStyle(
                  color: Color(0XFF628E9A),
                  fontSize: 12,
                  fontFamily: 'NanumPenScript',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
