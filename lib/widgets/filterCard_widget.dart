import 'package:flutter/material.dart';

class ThemeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const ThemeCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 15,
        // 카드의 너비
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Card(
            color: const Color(0XFFF7F9FC), // 카드의 배경색을 투명하게 설정
            elevation: 0, // 그림자 효과를 없애기 위해 elevation을 0으로 설정
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                ), // 이미지 크기 조정
                // 간격
              ],
            ),
          ),
        ),
      ),
    );
  }
}
