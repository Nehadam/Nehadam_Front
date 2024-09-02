import 'dart:convert';

import 'package:_nehadam/screens/frameChoice_screen.dart';
import 'package:_nehadam/screens/imagegallery_screen.dart'; // 새로 추가된 화면 import
import 'package:_nehadam/screens/myPage_detail_screen/mypage_rule.dart';
import 'package:_nehadam/screens/mytutorial_screen.dart';
import 'package:_nehadam/screens/userName_screen.dart';
import 'package:_nehadam/widgets/myPage_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String? _selectedImageUrl; // 선택된 이미지 URL을 저장하는 변수

  Future<String> _fetchUserName(String email) async {
    try {
      var url = Uri.parse(
          'http://4hadam.ddns.net:8080/api/user/getUserInfo?email=$email');
      var response = await http.get(url);

      // 응답 바이트를 확인하고 UTF-8로 디코딩
      var responseBodyBytes = response.bodyBytes;
      String decodedResponse = utf8.decode(responseBodyBytes);

      print('Decoded response body: $decodedResponse'); // 디코딩된 응답 출력

      if (response.statusCode == 200) {
        var data = json.decode(decodedResponse);
        return data['username'] ?? 'Unknown User';
      } else {
        return 'Error fetching username';
      }
    } catch (e) {
      print('Error: $e');
      return 'Error fetching username';
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffffffff),
        title: FutureBuilder<String>(
          future: _fetchUserName(email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading...',
                style: TextStyle(
                  color: Color(0xff324755),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              );
            } else if (snapshot.hasError) {
              return const Text(
                'Error',
                style: TextStyle(
                  color: Color(0xff324755),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    snapshot.data ?? 'hadam',
                    style: const TextStyle(
                      color: Color(0xff324755),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NanumPenScript',
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () async {
                    final selectedImageUrl = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryScreen(email: email),
                      ),
                    );

                    if (selectedImageUrl != null) {
                      setState(() {
                        _selectedImageUrl = selectedImageUrl;
                      });
                    }
                  },
                  child: _selectedImageUrl != null
                      ? Image.network(
                          _selectedImageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/data/frames/polaroid_click.jpg',
                        ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              const MyPageWidget(
                title: '닉네임 변경',
                iconname: Icons.account_circle,
                screenToMove: UserNameScreen(),
              ),
              const SizedBox(height: 20),
              const MyPageWidget(
                title: '프레임 구경하기',
                iconname: Icons.edit,
                screenToMove: FrameChoiceScreen(),
              ),
              const SizedBox(height: 20),
              const MyPageWidget(
                title: '어플 사용 방법',
                iconname: Icons.info,
                screenToMove: MyTutorialScreen(),
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
