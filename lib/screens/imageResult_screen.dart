import 'dart:typed_data';

import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageResultScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageResultScreen({super.key, required this.imageBytes});

  Future<void> _saveImage(BuildContext context) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(imageBytes,
          quality: 100, name: "converted_image");
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("이미지가 갤러리에 저장되었습니다.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("이미지 저장에 실패했습니다.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("저장 권한이 필요합니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveImage(context),
              child: const Text("이미지 저장",
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
  }
}
