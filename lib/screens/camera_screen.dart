import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isTakingPicture = false;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  bool _isRearCameraSelected = true;
  XFile? _capturedImage;
  double _baseZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera(); // 카메라 초기화
  }

  Future<void> _initializeCamera({int retryCount = 0}) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        final cameras = await availableCameras();
        if (_controller != null) {
          await _controller?.dispose();
        }
        _controller = CameraController(
          cameras[_isRearCameraSelected ? 0 : 1],
          ResolutionPreset.high,
        );

        _initializeControllerFuture = _controller!.initialize();

        await _initializeControllerFuture;

        _minAvailableZoom = await _controller!.getMinZoomLevel();
        _maxAvailableZoom = await _controller!.getMaxZoomLevel();

        if (!mounted) return;

        setState(() {}); // 상태를 업데이트하여 UI에 반영
      } catch (e) {
        _controller?.dispose(); // 오류 발생 시 컨트롤러 해제
        _controller = null;

        if (retryCount < 3) {
          // 3번까지 재시도
          await Future.delayed(const Duration(seconds: 1));
          _initializeCamera(retryCount: retryCount + 1);
        } else {
          _showErrorDialog('Camera Initialization Error', e.toString());
        }
      }
    } else if (status.isPermanentlyDenied) {
      _showErrorDialog('카메라 권한 거부', '카메라 권한을 허용해주세요.');
      openAppSettings(); // 권한이 영구적으로 거부된 경우 설정으로 이동
    } else {
      _showErrorDialog('카메라 권한 에러', '카메라 권한이 제대로 설정되어 있는지 확인해주세요.');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _capturedImage == null
              ? FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        onScaleStart: (details) {
                          _baseZoomLevel = _currentZoomLevel;
                        },
                        onScaleUpdate: (details) {
                          setState(() {
                            _currentZoomLevel = (_baseZoomLevel *
                                    details.scale.clamp(
                                        _minAvailableZoom, _maxAvailableZoom))
                                .clamp(_minAvailableZoom, _maxAvailableZoom);
                            _controller?.setZoomLevel(_currentZoomLevel);
                          });
                        },
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRect(
                              child: Transform.scale(
                                scale: _controller!.value.aspectRatio,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio:
                                        1 / _controller!.value.aspectRatio,
                                    child: CameraPreview(_controller!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Camera error: ${snapshot.error}'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
              : ImagePreviewScreen(
                  capturedImage: _capturedImage!,
                  onSavePressed: () async {
                    await _saveCroppedImage(_capturedImage!);
                    setState(() {
                      _capturedImage = null;
                    });
                  },
                  onRetakePressed: () {
                    setState(() {
                      _capturedImage = null;
                    });
                  },
                ),
          if (_capturedImage == null)
            Positioned(
              top: 40,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0XFF9CB5DE), width: 2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.loop,
                      size: 30, color: Color(0XFF9CB5DE)),
                  onPressed: _toggleCameraLens,
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _capturedImage == null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  heroTag: "takePicture",
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(
                      side: BorderSide(color: Color(0XFF9CB5DE), width: 4)),
                  onPressed: _isTakingPicture
                      ? null
                      : () async {
                          await _takePicture();
                        },
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      side:
                          const BorderSide(color: Color(0XFF9CB5DE), width: 4),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () async {
                      await _saveCroppedImage(_capturedImage!);
                      setState(() {
                        _capturedImage = null;
                      });
                    },
                    child: const Icon(Icons.save_alt, color: Color(0XFF9CB5DE)),
                  ),
                  const SizedBox(width: 60),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      side:
                          const BorderSide(color: Color(0XFF9CB5DE), width: 4),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      setState(() {
                        _capturedImage = null;
                      });
                    },
                    child: const Icon(Icons.replay, color: Color(0XFF9CB5DE)),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _takePicture() async {
    setState(() {
      _isTakingPicture = true;
    });

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      _showErrorDialog(
          'Error', 'An error occurred while taking the picture: $e');
    } finally {
      setState(() {
        _isTakingPicture = false;
      });
    }
  }

  Future<void> _saveCroppedImage(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final originalImage = await decodeImageFromList(bytes);

      final originalWidth = originalImage.width.toDouble();
      final originalHeight = originalImage.height.toDouble();
      double cropSize =
          originalWidth < originalHeight ? originalWidth : originalHeight;

      final left = (originalWidth - cropSize) / 2;
      final top = (originalHeight - cropSize) / 2;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final srcRect = Rect.fromLTWH(left, top, cropSize, cropSize);
      final dstRect = Rect.fromLTWH(0, 0, cropSize, cropSize);
      canvas.drawImageRect(originalImage, srcRect, dstRect, Paint());

      final croppedImage = await recorder
          .endRecording()
          .toImage(cropSize.toInt(), cropSize.toInt());
      final pngBytes =
          await croppedImage.toByteData(format: ui.ImageByteFormat.png);

      final result = await ImageGallerySaver.saveImage(
        Uint8List.view(pngBytes!.buffer),
        name: DateTime.now().toIso8601String(),
      );

      if (result != null && result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지가 갤러리에 저장되었습니다.')),
        );
      } else {
        _showErrorDialog('Save Error', 'Failed to save image to gallery.');
      }
    } catch (e) {
      _showErrorDialog('Error', 'An error occurred while saving the image: $e');
    }
  }

  void _toggleCameraLens() {
    setState(() {
      _isRearCameraSelected = !_isRearCameraSelected;
      _initializeCamera();
    });
  }

  void _showErrorDialog(String title, String content) {
    _initializeCamera(); // 오류 발생 시 카메라 재실행
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final XFile capturedImage;
  final VoidCallback onSavePressed;
  final VoidCallback onRetakePressed;

  const ImagePreviewScreen({
    super.key,
    required this.capturedImage,
    required this.onSavePressed,
    required this.onRetakePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Image.file(
                File(capturedImage.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
