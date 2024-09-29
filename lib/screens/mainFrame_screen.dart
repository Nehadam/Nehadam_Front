import 'dart:async';

import 'package:_nehadam/screens/camera_screen.dart';
import 'package:_nehadam/screens/filterView_screeen.dart';
import 'package:_nehadam/screens/myPage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  final List<Widget> _screens = [
    const ThemeSelectionScreen(),
    const Placeholder(), // CameraScreen's Placeholder
    const MyPageScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _resetTutorialSeenState();
    }
  }

  Future<void> _resetTutorialSeenState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenTutorial', false);
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainFrameScreen(),
          ),
        );
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _screens[0],
          if (_selectedIndex == 1) const CameraScreen() else _screens[1],
          _screens[2],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        backgroundColor: const Color.fromARGB(
            255, 237, 241, 247), // Set the background color here
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF334f78), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/img/Image.svg', // Path to your SVG file
                      height: 24,
                      width: 24,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/img/Image.svg', // Path to your SVG file
                    height: 24,
                    width: 24,
                  ),
            label: '', // Provide an empty label
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF334f78), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/img/Camera.svg', // Path to your SVG file
                      height: 24,
                      width: 24,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/img/Camera.svg', // Path to your SVG file
                    height: 24,
                    width: 24,
                  ),
            label: '', // Provide an empty label
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF334f78), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/img/Profile.svg', // Path to your SVG file
                      height: 24,
                      width: 24,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/img/Profile.svg', // Path to your SVG file
                    height: 24,
                    width: 24,
                  ),
            label: '', // Provide an empty label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            const Color(0xFF334f78), // To change the selected icon color
        unselectedItemColor:
            const Color(0xFF334f78), // To change the unselected icon color
        onTap: _onItemTapped,
        showSelectedLabels: false, // Hide the labels
        showUnselectedLabels: false, // Hide the labels
      ),
    );
  }
}

// Define the custom TextStyle and Colors
const TextStyle _dialogButtonStyle = TextStyle(
  fontFamily: 'NanumPenScript',
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
