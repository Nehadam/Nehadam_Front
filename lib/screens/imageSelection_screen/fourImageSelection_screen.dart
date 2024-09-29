import 'dart:typed_data';

import 'package:_nehadam/screens/imageResult_screen.dart';
import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FourImageSelectionScreen extends StatefulWidget {
  final String frameTitle;

  const FourImageSelectionScreen({required this.frameTitle, super.key});

  @override
  _FourImageSelectionScreenState createState() =>
      _FourImageSelectionScreenState();
}

class _FourImageSelectionScreenState extends State<FourImageSelectionScreen> {
  Uint8List? _selectedImage1;
  Uint8List? _selectedImage2;
  Uint8List? _selectedImage3;
  Uint8List? _selectedImage4;
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
        } else if (imageNumber == 3) {
          _selectedImage3 = bytes;
        } else if (imageNumber == 4) {
          _selectedImage4 = bytes;
        }
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImage1 == null ||
        _selectedImage2 == null ||
        _selectedImage3 == null ||
        _selectedImage4 == null) {
      _showErrorDialog("모든 이미지를 선택해야 합니다.");
      return;
    }

    String endpoint;

    if (widget.frameTitle.contains("검정 프레임")) {
      endpoint = "http://4hadam.ddns.net:5000/black";
    } else if (widget.frameTitle.contains("기본 프레임")) {
      endpoint = "http://4hadam.ddns.net:5000/hadam4";
    } else {
      endpoint = "http://4hadam.ddns.net:5000/hadam4";
    }

    final uri = Uri.parse(endpoint);
    var request = http.MultipartRequest('POST', uri);

    request.files.add(http.MultipartFile.fromBytes('image1', _selectedImage1!,
        filename: 'image1.jpg'));
    request.files.add(http.MultipartFile.fromBytes('image2', _selectedImage2!,
        filename: 'image2.jpg'));
    request.files.add(http.MultipartFile.fromBytes('image3', _selectedImage3!,
        filename: 'image3.jpg'));
    request.files.add(http.MultipartFile.fromBytes('image4', _selectedImage4!,
        filename: 'image4.jpg'));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        Uint8List imageBytes = Uint8List.fromList(responseData);
        setState(() {
          _imageResult = imageBytes;
        });
      } else {
        _showErrorDialog('사진을 다시 선택해주세요.');
      }
    } catch (e) {
      _showErrorDialog('사진을 다시 선택해주세요.');
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
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns everything to the start (left)
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xfff9fbff),
                borderRadius: BorderRadius.all(Radius.circular(45)),
              ),
              child: const Text(
                '4개의 사진 선택',
                style: TextStyle(
                  color: Color(0XFF334F78),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 30), // To match the padding with '필터 선택'
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "1:1비율로 촬영된 사진을 선택하세요.",
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                  color: Color(0XFF334F78),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30), // To align with '필터 선택'
              child: Row(
                children: [
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
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30), // To align with '필터 선택'
              child: Row(
                children: [
                  Expanded(
                    child: ImageSelectionWidget(
                      image: _selectedImage3,
                      placeholder: "세 번째\n이미지 선택",
                      onTap: () => _selectImageFromGallery(3),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ImageSelectionWidget(
                      image: _selectedImage4,
                      placeholder: "네 번째\n이미지 선택",
                      onTap: () => _selectImageFromGallery(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30), // To align with '필터 선택'
              child: ElevatedButton(
                onPressed: _uploadImages,
                child: const Text(
                  "이미지 업로드",
                  style: TextStyle(
                    fontFamily: 'NanumPenScript',
                    color: Color(0XFF334F78),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
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
