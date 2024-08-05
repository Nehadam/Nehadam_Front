import 'package:_nehadam/screens/myPage_detail_screen/mypage_rule.dart'; // Import other screens
import 'package:_nehadam/screens/userName_screen.dart'; // Import UserNameScreen
import 'package:_nehadam/widgets/myPage_widget.dart'; // Import MyPageWidget
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        automaticallyImplyLeading: false, // 뒤로가기 없애기
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'hadam123',
              style: TextStyle(
                color: Color(0xff324755),
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumPenScript',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xffffffff),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/data/frames/polaroid.jpg'),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              const MyPageWidget(
                title: '닉네임 변경',
                iconname: Icons.account_circle,
                screenToMove: UserNameScreen(), // Navigate to UserNameScreen
              ),
              const SizedBox(height: 20),
              const MyPageWidget(
                title: '개인정보 수정',
                iconname: Icons.edit,
                screenToMove: mypagerule(),
              ),
              const SizedBox(height: 20),
              const MyPageWidget(
                title: '이용약관',
                iconname: Icons.description,
                screenToMove: mypagerule(),
              ),
              const SizedBox(height: 20),
              const MyPageWidget(
                title: '개인정보처리방침',
                iconname: Icons.book,
                screenToMove: mypagerule2(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
