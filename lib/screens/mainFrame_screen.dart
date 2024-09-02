import 'dart:async';

import 'package:_nehadam/screens/camera_screen.dart';
import 'package:_nehadam/screens/filterView_screeen.dart';
import 'package:_nehadam/screens/home_screen.dart';
import 'package:_nehadam/screens/myPage_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainFrameScreen extends StatefulWidget {
  const MainFrameScreen({super.key});

  @override
  State<MainFrameScreen> createState() => _MainFrameScreenState();
}

class _MainFrameScreenState extends State<MainFrameScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  Timer? _timer;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const CameraScreen(),
    const ThemeSelectionScreen(),
    const MyPageScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 생명주기 관찰 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTimeUser(); // 앱 처음 실행 시 튜토리얼 확인
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 생명주기 관찰 해제
    _timer?.cancel(); // 타이머가 있을 경우 해제
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 갈 때만 튜토리얼 상태를 초기화
      _resetTutorialSeenState();
    }
  }

  Future<void> _resetTutorialSeenState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenTutorial', false); // 초기화
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    bool? hasSeenTutorial = prefs.getBool('hasSeenTutorial');

    if (hasSeenTutorial == null || !hasSeenTutorial) {
      _showTutorialDialog();
      await prefs.setBool('hasSeenTutorial', true);
    }
  }

  void _showTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '어플 사용 방법',
                  style: TextStyle(
                    color: Color(0xff324755),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumPenScript',
                  ),
                ),
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
                  '이미지의 이름을 짓고 이를 저장하여 사용하세요.(프로필 메뉴에서 튜토리얼을 다시 볼 수 있습니다.)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'NanumPenScript',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '닫기',
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white10,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_outlined),
            label: 'camera',
            backgroundColor: Colors.white10,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens_outlined),
            label: 'Search',
            backgroundColor: Colors.white10,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Profile',
            backgroundColor: Colors.white10,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
