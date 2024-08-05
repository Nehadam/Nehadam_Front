import 'dart:async';
import 'dart:typed_data'; // ByteData를 사용하기 위해 필요

import 'package:_nehadam/states/image_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final frameImageState = Provider.of<Image_State>(context);
    final filterImageState = Provider.of<Image_State>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 15,
                                  offset: const Offset(10, 10),
                                  color: Colors.black.withOpacity(0.15),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black54, width: 2),
                            ),
                            child: _selectedImage == null
                                ? const Text(
                                    "갤러리에서\n이미지 선택하기",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'NanumPenScript',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Image.memory(_selectedImage!),
                          ),
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              final bytes = await pickedFile.readAsBytes();
                              setState(() {
                                _selectedImage = bytes;
                              });
                              // 이미지가 성공적으로 선택되면 다이얼로그를 표시
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "이미지 선택 완료",
                                      style: TextStyle(
                                        fontFamily: 'NanumPenScript',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // 다이얼로그 닫기
                                          },
                                          child: const Text(
                                            "확인",
                                            style: TextStyle(
                                              fontFamily: 'NanumPenScript',
                                            ),
                                          )),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          filterImageState.image_FilterPath,
                          width: 200,
                          height: 200,
                        ),
                        const Text(
                          "필터",
                          style: TextStyle(
                            fontFamily: 'NanumPenScript',
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(
                height: 30,
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => uploadImages(context, _selectedImage),
                  child: const Text(
                    "변환하기",
                    style: TextStyle(
                      fontFamily: 'NanumPenScript',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> uploadImages(
    BuildContext context, Uint8List? selectedImage) async {
  if (selectedImage == null) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Error"),
        content: const Text("이미지를 먼저 선택하세요."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
    return;
  }

  // 로딩 다이얼로그 표시
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            int secondsPassed = 0;
            Timer.periodic(const Duration(seconds: 1), (Timer timer) {
              setState(() {
                secondsPassed++;
              });
            });

            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text("Uploading...\n\n(예상 시간: 100초)"),
                  ],
                ),
              ),
            );
          },
        );
      });
  try {
    var uri = Uri.parse("http://3.21.145.227:5000/convert");
    var request = http.MultipartRequest('POST', uri);

    // Add the selected image as content
    var contentImage = http.MultipartFile.fromBytes('image', selectedImage,
        filename: 'selected_image.jpg');

    request.files.add(contentImage);

    var response = await request.send();

    // 로딩 다이얼로그 닫기
    Navigator.pop(context);

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      Uint8List imageBytes = Uint8List.fromList(responseData);
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: ClipRect(
            child: Stack(alignment: Alignment.center, children: [
              Image.memory(
                width: 160,
                height: 160,
                imageBytes,
              ),
            ]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      throw Exception(
          'Failed to upload images. Server responded with status code ${response.statusCode}');
    }
  } catch (e) {
    // 로딩 다이얼로그 닫기
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Error"),
        content: Text("An error occurred: $e"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
