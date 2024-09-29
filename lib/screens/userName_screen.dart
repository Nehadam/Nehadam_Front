import 'dart:convert';

import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 유저가 존재하는지 확인
  Future<bool> _checkUserExists(String email) async {
    var url = Uri.parse(
        'http://4hadam.ddns.net:8080/api/user/getUserInfo?email=$email');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data != null && data['email'] == email;
    } else {
      return false;
    }
  }

  // 유저 정보 저장
  Future<void> _saveUserInfo(String email, String name) async {
    try {
      var url = Uri.parse(
          'http://4hadam.ddns.net:8080/api/user/saveUserInfo?email=$email'); // 이메일을 쿼리 파라미터로 전달
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(
            'Failed to save user information.\nStatus: ${response.statusCode}\nResponse: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
      print("Error: $e");
    }
  }

  // 유저 정보 수정
  Future<void> _updateUserInfo(String email, String name) async {
    try {
      var url =
          Uri.parse('http://4hadam.ddns.net:8080/api/user/updateUserInfo');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'username': name,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(
            'Failed to update user information.\nStatus: ${response.statusCode}\nResponse: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
      print("Error: $e");
    }
  }

  // 성공 다이얼로그
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          '닉네임을 변경하였습니다.\n첫 화면으로 돌아갑니다.',
          style: TextStyle(
            fontFamily: 'NanumPenScript',
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainFrameScreen()),
              );
            },
            child: const Text(
              '확인',
              style: TextStyle(
                fontFamily: 'NanumPenScript',
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 오류 다이얼로그
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // 유저 정보 저장 혹은 수정
  Future<void> _saveUserName() async {
    String name = _nameController.text.trim();
    User? user = _auth.currentUser;

    if (name.isNotEmpty && user != null) {
      String email = user.email ?? '';

      bool userExists = await _checkUserExists(email);

      if (userExists) {
        await _updateUserInfo(email, name); // 유저가 존재하면 업데이트
      } else {
        await _saveUserInfo(email, name); // 유저가 없으면 저장
      }
    } else {
      _showErrorDialog('Please enter a valid username.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF9CB5DE), // 배경 색상
      appBar: AppBar(
        backgroundColor: const Color(0XFF9CB5DE), // 배경 색상
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 원하는 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 기능
          },
        ),
        title: const Text(
          '닉네임 변경',
          style: TextStyle(
            fontFamily: 'NanumPenScript',
            color: Colors.white,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0), // 컨테이너의 내부 여백
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0), // 컨테이너의 외부 여백
                    decoration: BoxDecoration(
                      color: const Color(0XFF9CB5DE), // 배경 색상
                      borderRadius: BorderRadius.circular(15), // 모서리 둥글기
                      border: Border.all(
                        color: Colors.white, width: 5.0, // 테두리 두께
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '네하담',
                          style: TextStyle(
                            fontSize: 40, // 네하담 글씨 크기
                            fontWeight: FontWeight.bold, // 글씨 두께
                            color: Colors.white, // 배경 색상
                          ),
                        ),
                        SizedBox(height: 10), // 네하담과 내일의 하루를 담다 사이의 간격
                        Text(
                          '네컷에 하루를 담아요',
                          style: TextStyle(
                            fontSize: 14, // 내일의 하루를 담다 글씨 크기
                            fontWeight: FontWeight.normal, // 글씨 두께
                            color: Colors.white, // 배경 색상
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '닉네임 입력',
                      labelStyle: TextStyle(
                        fontFamily: 'NanumPenScript',
                        color: Colors.white,
                        fontWeight: FontWeight.bold, // 글씨 두께
                        fontSize: 24,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // 기본 밑줄 색상
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white), // 포커스된 밑줄 색상
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveUserName,
                    child: const Text("저장",
                        style: TextStyle(
                          fontFamily: 'NanumPenScript',
                          color: Color(0XFF334F78),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
