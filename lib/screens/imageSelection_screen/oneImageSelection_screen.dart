import 'dart:typed_data';

import 'package:_nehadam/screens/imageResult_screen.dart';
import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class OneImageSelectionScreen extends StatefulWidget {
  final String frameTitle;

  const OneImageSelectionScreen({required this.frameTitle, super.key});

  @override
  _OneImageSelectionScreenState createState() =>
      _OneImageSelectionScreenState();
}

class _OneImageSelectionScreenState extends State<OneImageSelectionScreen> {
  Uint8List? _selectedImage;
  Uint8List? _imageResult;

  Future<void> _selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showErrorDialog("이미지를 선택해주세요.");
      return;
    }

    // 선택된 프레임에 따라 업로드할 엔드포인트 설정
    String endpoint;

    if (widget.frameTitle.contains("검정 프레임")) {
      endpoint = "http://4hadam.ddns.net:5000/black";
    } else if (widget.frameTitle.contains("기본 프레임")) {
      endpoint = "http://4hadam.ddns.net:5000/hadam1";
    } else {
      endpoint = "http://4hadam.ddns.net:5000/hadam_deer";
    }

    final uri = Uri.parse(endpoint);
    var request = http.MultipartRequest('POST', uri);

    request.files.add(http.MultipartFile.fromBytes(
      'image1',
      _selectedImage!,
      filename: 'image1.jpg',
    ));

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                '1개의 사진 선택',
                style: TextStyle(
                  color: Color(0XFF334F78),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumPenScript',
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
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
            child: Center(
              // 이미지를 중앙에 배치하기 위해 Center 위젯 사용
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ImageSelectionWidget(
                  image: _selectedImage,
                  placeholder: "이미지 선택",
                  onTap: _selectImageFromGallery,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: _uploadImage,
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
        width: 250,
        height: 250,
        alignment: Alignment.center, // 컨테이너 내의 내용을 중앙에 배치
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black54, width: 2),
        ),
        child: AspectRatio(
          aspectRatio: 1, // 이미지가 1:1 비율로 유지되도록 설정
          child: image == null
              ? Center(
                  // 텍스트가 중앙에 배치되도록 Center 위젯 사용
                  child: Text(
                    placeholder,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'NanumPenScript',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0XFF334F78),
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
