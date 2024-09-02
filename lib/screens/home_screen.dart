import 'dart:async';
import 'dart:typed_data';

import 'package:_nehadam/states/image_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Uint8List? _selectedImage;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 생명주기 관찰 시작
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 생명주기 관찰 해제
    _stopwatch.stop();
    _timer?.cancel(); // 타이머가 있을 경우 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterImageState = Provider.of<Image_State>(context);
    final selectedTheme = filterImageState.selectedTheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectImageFromGallery,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black54, width: 2),
                          ),
                          child: _selectedImage == null
                              ? const Text(
                                  "여기에서\n이미지 선택하기",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'NanumPenScript',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                )
                              : Image.memory(_selectedImage!),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      _uploadImages(context, selectedTheme, _selectedImage),
                  child: const Text(
                    "변환하기",
                    style: TextStyle(
                      fontFamily: 'NanumPenScript',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Future<void> _uploadImages(BuildContext context, String? selectedTheme,
      Uint8List? selectedImage) async {
    final filterImageState = Provider.of<Image_State>(context, listen: false);

    if (selectedImage == null) {
      _showErrorDialog(context, "이미지를 먼저 선택하세요.");
      return;
    }

    // GIF 파일 여부 확인
    bool isGif = _selectedImage != null && _isGifFile(_selectedImage!);

    _stopwatch.reset();
    _stopwatch.start();

    _timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              _timer =
                  Timer.periodic(const Duration(seconds: 1), (Timer timer) {
                setState(() {});
              });

              return Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 20),
                    Text(
                        "사진을 변환 중! \n\n(경과 시간: ${_stopwatch.elapsed.inSeconds} 초)"),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    try {
      Uri uri;
      var request = http.MultipartRequest('POST', Uri.parse(''));

      if (selectedTheme == 'Cartoon') {
        uri = Uri.parse("http://52.78.251.254:5000/convert");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes('image', selectedImage,
            filename: 'selected_image.jpg'); // 확장자를 명시적으로 jpg로 설정
        request.files.add(contentImage);
      } else if (selectedTheme == 'AI') {
        uri = Uri.parse("https://ai-server-address.com/convert");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes(
            'content', selectedImage,
            filename: isGif ? 'selected_image.gif' : 'selected_image.jpg');

        ByteData styleImageData =
            await rootBundle.load(filterImageState.image_FilterPath);
        List<int> styleImageDataBytes = styleImageData.buffer.asUint8List();
        var styleImage = http.MultipartFile.fromBytes(
            'style', styleImageDataBytes,
            filename: 'style_image.jpg');

        request.files.add(contentImage);
        request.files.add(styleImage);
      } else if (selectedTheme == 'life') {
        uri = Uri.parse("http://13.209.72.201/upload");
        request = http.MultipartRequest('POST', uri);

        // GIF 파일인지 확인하고 파일 확장자를 명시적으로 지정
        var contentImage = http.MultipartFile.fromBytes('file', selectedImage,
            filename: 'selected_image.gif');
        request.files.add(contentImage);
      }

      var response = await request.send();

      Navigator.pop(context);

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        Uint8List imageBytes = Uint8List.fromList(responseData);

        // null 검사
        if (selectedTheme != null) {
          _showSaveImageDialog(context, imageBytes, selectedTheme);
        } else {
          _showErrorDialog(context, "테마가 선택되지 않았습니다.");
        }
      } else {
        throw Exception(
            'Failed to upload images. Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  bool _isGifFile(Uint8List bytes) {
    // GIF 파일 시그니처 확인 (GIF87a 또는 GIF89a)
    return bytes.length > 3 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46;
  }

  Future<void> _showSaveImageDialog(
      BuildContext context, Uint8List imageBytes, String selectedTheme) async {
    String imageName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.memory(
                      imageBytes,
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  imageName = value;
                },
                decoration: const InputDecoration(
                  labelText: '이미지 이름 입력',
                  labelStyle: TextStyle(
                    fontFamily: 'NanumPenScript',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "취소",
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (imageName.isEmpty) {
                  imageName = 'nehadam'; // Default name if none entered
                }
                await _saveImage(imageBytes, imageName, selectedTheme);
                Navigator.pop(context);
                _showSuccessDialog(context);
              },
              child: const Text(
                "저장",
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveImage(
      Uint8List imageBytes, String imageName, String selectedTheme) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated.');
      return;
    }

    String email = user.email ?? '';
    final uri = Uri.parse(
        'http://4hadam.ddns.net:8080/api/${Uri.encodeComponent(email)}/images/upload');

    // 변환 유형에 따른 확장자 설정
    String fileExtension = (selectedTheme == 'life') ? 'gif' : 'jpg';

    // 서버에 파일 전송
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = imageName
      ..files.add(http.MultipartFile.fromBytes('file', imageBytes,
          filename: '$imageName.$fileExtension'));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image saved successfully!');
    } else {
      print('Failed to save image.');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "이미지 저장 완료!",
            style: TextStyle(
              fontFamily: 'NanumPenScript',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "확인",
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(BuildContext context, String errorMessage) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            errorMessage,
            style: const TextStyle(
              fontFamily: 'NanumPenScript',
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                "확인",
                style: TextStyle(
                  fontFamily: 'NanumPenScript',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
