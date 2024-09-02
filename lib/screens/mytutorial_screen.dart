import 'package:flutter/material.dart';

class MyTutorialScreen extends StatelessWidget {
  const MyTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: const Color(0xffffffff),
        title: const Text(
          '어플 사용 방법',
          style: TextStyle(
            color: Color(0xff324755),
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumPenScript',
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              '1. 앱에 로그인하기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumPenScript',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '앱에 로그인하고 닉네임을 변경하세요',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'NanumPenScript',
              ),
            ),
            SizedBox(height: 30),
            Text(
              '2. 필터 선택',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumPenScript',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '원하는 필터를 선택하세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'NanumPenScript',
              ),
            ),
            SizedBox(height: 30),
            Text(
              '3. 갤러리 및 드라이브에서 사진을 선택',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumPenScript',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '변환하고 싶은 사진을 선택하세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'NanumPenScript',
              ),
            ),
            SizedBox(height: 30),
            Text(
              '4. 이미지 저장',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumPenScript',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '이미지의 이름을 짓고 이를 저장하여 사용하세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'NanumPenScript',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
