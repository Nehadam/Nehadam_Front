import 'dart:async';
import 'dart:typed_data';

import 'package:_nehadam/screens/frameSelection_screen.dart';
import 'package:_nehadam/screens/mainFrame_screen.dart';
import 'package:_nehadam/states/image_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool _showFrameSelectionScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showFrameSelectionScreen
          ? const FrameSelectionScreen()
          : WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    '네하담',
                    style: TextStyle(
                        color: Color(0XFF334F78),
                        fontFamily: 'NanumPenScript',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xfff9fbff),
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                          ),
                          child: const Text(
                            '이미지 변환',
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
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.black54,
                                                width: 2),
                                          ),
                                          child: _selectedImage == null
                                              ? const Text(
                                                  "원본\n이미지 선택",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'NanumPenScript',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : Image.memory(_selectedImage!),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            Provider.of<Image_State>(context,
                                                    listen: false)
                                                .image_FilterPath,
                                            width: 200,
                                            height: 200,
                                          ),
                                          const Text(
                                            "필터",
                                            style: TextStyle(
                                              fontFamily: 'NanumPenScript',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => _uploadImages(
                                      context,
                                      Provider.of<Image_State>(context,
                                              listen: false)
                                          .selectedTheme,
                                      _selectedImage),
                                  child: const Text("변환",
                                      style: TextStyle(
                                        fontFamily: 'NanumPenScript',
                                        color: Color(0XFF334F78),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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

    bool isGif = _selectedImage != null && _isGifFile(_selectedImage!);

    _stopwatch.reset();
    _stopwatch.start();

    _timer?.cancel();

    bool isCancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              _timer =
                  Timer.periodic(const Duration(seconds: 1), (Timer timer) {
                if (mounted) {
                  // mounted 확인
                  setState(() {});
                }
              });

              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                        "사진을 변환 중! \n\n(경과 시간: ${_stopwatch.elapsed.inSeconds} 초)"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        isCancelled = true;
                        _timer?.cancel();
                        _stopwatch.stop();
                        Navigator.pop(context);
                      },
                      child: const Text("취소"),
                    ),
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
            filename: 'selected_image.jpg');
        request.files.add(contentImage);
      } else if (selectedTheme == 'AI') {
        uri = Uri.parse("http://4hadam.ddns.net:5001/upload");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes(
            'content', selectedImage,
            filename: 'selected_image.jpg');

        ByteData styleImageData =
            await rootBundle.load(filterImageState.image_FilterPath);
        List<int> styleImageDataBytes = styleImageData.buffer.asUint8List();
        var styleImage = http.MultipartFile.fromBytes(
            'style', styleImageDataBytes,
            filename: 'style_image.jpg');

        request.files.add(contentImage);
        request.files.add(styleImage);
      } else if (selectedTheme == 'life_baby' || selectedTheme == 'life_old') {
        uri = Uri.parse(selectedTheme == 'life_baby'
            ? "http://4hadam.ddns.net:5123/upload/age10"
            : "http://4hadam.ddns.net:5123/upload/age80");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes('file', selectedImage,
            filename: 'selected_image.jpg');
        request.files.add(contentImage);

        request.headers['output'] = 'result.jpg';
      } else if (selectedTheme == 'sdwebui') {
        uri = Uri.parse("http://4hadam.ddns.net:5002/generate");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes('image', selectedImage,
            filename: 'selected_image.jpg');
        request.files.add(contentImage);

        request.headers['output'] = 'result.png';
      } else if (selectedTheme == 'anime') {
        uri = Uri.parse("http://4hadam.ddns.net:5003/generate");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes('image', selectedImage,
            filename: 'selected_image.jpg');
        request.files.add(contentImage);

        request.headers['output'] = 'result.png';
      } else if (selectedTheme == 'pixelart') {
        uri = Uri.parse("http://4hadam.ddns.net:5004/generate");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes('image', selectedImage,
            filename: 'selected_image.jpg');
        request.files.add(contentImage);

        request.headers['output'] = 'result.png';
      } else if (selectedTheme == 'ardiffusion') {
        uri = Uri.parse("http://211.222.222.50:5006/upload");
        request = http.MultipartRequest('POST', uri);

        var contentImage = http.MultipartFile.fromBytes('file', selectedImage,
            filename: 'selected_image.jpg');
        request.files.add(contentImage);

        request.headers['output'] = 'result.png';
      }

      var response = await request.send();

      if (isCancelled) {
        return;
      }

      if (mounted) {
        // mounted 확인
        Navigator.pop(context);
      }

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();

        // 유효한 이미지 데이터인지 확인
        if (_isValidImageData(responseData)) {
          Uint8List imageBytes = Uint8List.fromList(responseData);
          if (selectedTheme != null) {
            _showSaveImageDialog(context, imageBytes, selectedTheme);
          } else {
            _showErrorDialog(context, "테마가 선택되지 않았습니다.");
          }
        } else {
          _showErrorDialog(context, "서버에서 유효하지 않은 이미지를 반환했습니다.");
        }
      } else {
        throw Exception(
            'Failed to upload images. Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      if (!isCancelled) {
        print('Error: $e');
        _showErrorDialog(context, "이미지 변환 중 오류가 발생했습니다.");
      }
    } finally {
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  bool _isGifFile(Uint8List bytes) {
    return bytes.length > 3 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46;
  }

  bool _isValidImageData(List<int> bytes) {
    try {
      final image = Image.memory(Uint8List.fromList(bytes));
      return image != null;
    } catch (e) {
      return false;
    }
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
                  imageName = 'nehadam';
                }
                await _saveImage(imageBytes, imageName, selectedTheme);
                if (mounted) {
                  // mounted 확인
                  Navigator.pop(context);
                  setState(() {
                    _showFrameSelectionScreen = true;
                  });
                }
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

    // 이미지 확장자 설정
    String fileExtension = (selectedTheme == 'life') ? 'gif' : 'jpg';

    // 이미지 이름에 확장자 추가
    String fullImageName =
        '${imageName}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

    // 서버에 이미지 저장
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = imageName
      ..files.add(http.MultipartFile.fromBytes('file', imageBytes,
          filename: fullImageName));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image saved successfully to server!');

      // 갤러리에 저장
      await _saveImageToGallery(imageBytes, fullImageName);
    } else {
      print('Failed to save image to server.');
    }
  }

  Future<void> _saveImageToGallery(
      Uint8List imageBytes, String fullImageName) async {
    // 갤러리에 저장하기 위해 권한 요청
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(imageBytes,
          quality: 100, name: fullImageName);
      if (result['isSuccess']) {
        print('Image saved successfully to gallery!');
      } else {
        print('Failed to save image to gallery.');
      }
    } else {
      print('Storage permission not granted.');
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
