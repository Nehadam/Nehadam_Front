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
      child: Card(
        child: Column(
          children: [
            Image.asset(imagePath, height: 200, width: 200, fit: BoxFit.cover),
            const SizedBox(height: 30),
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumPenScript')),
          ],
        ),
      ),
    );
  }
}
