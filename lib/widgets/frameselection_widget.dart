import 'package:flutter/material.dart';

class FrameSelectionWidget extends StatelessWidget {
  final Function(String) onFrameSelected;

  const FrameSelectionWidget({required this.onFrameSelected, super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> frames = [
      {
        "title": "1컷 기본 프레임",
        "imagePath": "assets/frame/frame_1cuts_1.png",
      },
      {
        "title": "1컷 사슴 프레임",
        "imagePath": "assets/frame/frame_1cuts_1_smu.png",
      },
      {
        "title": "2컷 기본 프레임",
        "imagePath": "assets/frame/frame_2cuts_1.png",
      },
      {
        "title": "4컷 기본 프레임",
        "imagePath": "assets/frame/frame_4cuts_1.png",
      },
      {
        "title": "4컷 검정 프레임",
        "imagePath": "assets/frame/frame_4cuts_2_black.jpg",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: frames.length,
      itemBuilder: (context, index) {
        final frame = frames[index];
        return GestureDetector(
          onTap: () {
            _showConfirmationDialog(context, frame["title"]!);
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    frame["title"]!,
                    style: const TextStyle(
                        fontFamily: 'NanumPenScript',
                        fontSize: 15,
                        color: Color(0XFF334F78),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    frame["imagePath"]!,
                    fit: BoxFit.contain,
                    height: 200,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String frameTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "프레임을 선택하셨습니다. \n사진 선택 화면으로 넘어갑니다.",
            style: TextStyle(
              fontFamily: 'NanumPenScript',
              fontSize: 18,
              color: Color(0XFF334F78),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                onFrameSelected(frameTitle); // 선택된 프레임에 따라 상태 변경
              },
              child: const Text(
                "확인",
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
