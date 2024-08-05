import 'package:_nehadam/screens/camera_screen.dart';
import 'package:_nehadam/screens/filterView_screeen.dart';
import 'package:_nehadam/screens/frameChoice_screen.dart';
import 'package:_nehadam/screens/home_screen.dart';
import 'package:_nehadam/screens/myPage_screen.dart';
import 'package:flutter/material.dart';

class MainFrameScreen extends StatefulWidget {
  const MainFrameScreen({super.key});

  @override
  State<MainFrameScreen> createState() => _MainFrameScreenState();
}

class _MainFrameScreenState extends State<MainFrameScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const FrameChoiceScreen(),
    const CameraScreen(),
    const ThemeSelectionScreen(),
    const MyPageScreen(),
  ];

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
            icon: Icon(Icons.filter_none_sharp),
            label: 'Frames',
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
