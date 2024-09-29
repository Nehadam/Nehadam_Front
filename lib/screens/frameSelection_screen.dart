import 'package:_nehadam/screens/imageSelection_screen/fourImageSelection_screen.dart';
import 'package:_nehadam/screens/imageSelection_screen/oneImageSelection_screen.dart';
import 'package:_nehadam/screens/imageSelection_screen/twoImageSelection_screen.dart';
import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:_nehadam/widgets/frameselection_widget.dart';
import 'package:flutter/material.dart';

class FrameSelectionScreen extends StatefulWidget {
  const FrameSelectionScreen({super.key});

  @override
  _FrameSelectionScreenState createState() => _FrameSelectionScreenState();
}

class _FrameSelectionScreenState extends State<FrameSelectionScreen> {
  String? selectedFrameTitle;

  void _onFrameSelected(String frameTitle) {
    setState(() {
      selectedFrameTitle = frameTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFrameTitle == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            '네하담',
            style: TextStyle(
              fontFamily: 'NanumPenScript',
              color: Color(0XFF334F78),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.home,
              color: Color(0XFF334F78),
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainFrameScreen(),
                  ),
                );
              }
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xfff9fbff),
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                  ),
                  child: const Text(
                    '프레임 선택',
                    style: TextStyle(
                      color: Color(0XFF334F78),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NanumPenScript',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FrameSelectionWidget(onFrameSelected: _onFrameSelected),
            ),
          ],
        ),
      );
    } else if (selectedFrameTitle!.contains("1컷")) {
      return OneImageSelectionScreen(frameTitle: selectedFrameTitle!);
    } else if (selectedFrameTitle!.contains("2컷")) {
      return const TwoImageSelectionScreen();
    } else if (selectedFrameTitle!.contains("4컷")) {
      return FourImageSelectionScreen(frameTitle: selectedFrameTitle!);
    } else {
      return const Scaffold(
        body: Center(child: Text('Invalid frame selected')),
      );
    }
  }
}
