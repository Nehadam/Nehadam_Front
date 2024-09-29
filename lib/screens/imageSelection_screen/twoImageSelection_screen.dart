import 'dart:typed_data';

import 'package:_nehadam/screens/imageResult_screen.dart'; // Update the import path according to your project structure
import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TwoImageSelectionScreen extends StatefulWidget {
  const TwoImageSelectionScreen({super.key});

  @override
  _TwoImageSelectionScreenState createState() =>
      _TwoImageSelectionScreenState();
}

class _TwoImageSelectionScreenState extends State<TwoImageSelectionScreen> {
  Uint8List? _selectedImage1;
  Uint8List? _selectedImage2;
  Uint8List? _imageResult;

  Future<void> _selectImageFromGallery(int imageNumber) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (imageNumber == 1) {
          _selectedImage1 = bytes;
        } else if (imageNumber == 2) {
          _selectedImage2 = bytes;
        }
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImage1 == null || _selectedImage2 == null) {
      _showErrorDialog("모든 이미지를 선택해야 합니다.");
      return;
    }

    final uri = Uri.parse("http://4hadam.ddns.net:5000/hadam2");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(http.MultipartFile.fromBytes('image1', _selectedImage1!,
        filename: 'image1.jpg'));
    request.files.add(http.MultipartFile.fromBytes('image2', _selectedImage2!,
        filename: 'image2.jpg'));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        Uint8List imageBytes = Uint8List.fromList(responseData);
        setState(() {
          _imageResult = imageBytes;
        });
      } else {
        _showErrorDialog('에러가 발생했습니다. 재시도해주세요.');
      }
    } catch (e) {
      _showErrorDialog('에러가 발생했습니다. 재시도해주세요.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageResult != null) {
      return ImageResultScreen(imageBytes: _imageResult!);
    }

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
                  '2개의 사진 선택',
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
          const SizedBox(
            height: 80,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("1:1비율로 촬영된 사진을 선택하세요.",
                  style: TextStyle(
                    fontFamily: 'NanumPenScript',
                    color: Color(0XFF334F78),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: ImageSelectionWidget(
                      image: _selectedImage1,
                      placeholder: "첫 번째\n이미지 선택",
                      onTap: () => _selectImageFromGallery(1),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ImageSelectionWidget(
                      image: _selectedImage2,
                      placeholder: "두 번째\n이미지 선택",
                      onTap: () => _selectImageFromGallery(2),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImages,
                child: const Text("이미지 업로드",
                    style: TextStyle(
                      fontFamily: 'NanumPenScript',
                      color: Color(0XFF334F78),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageSelectionWidget extends StatelessWidget {
  final Uint8List? image;
  final String placeholder;
  final VoidCallback onTap;

  const ImageSelectionWidget({
    super.key,
    required this.image,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5, // 1:1 비율 설정
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54, width: 2),
        ),
        child: image == null
            ? Text(
                placeholder,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'NanumPenScript',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0XFF334F78),
                ),
              )
            : Image.memory(
                image!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
