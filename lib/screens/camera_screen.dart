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

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isTakingPicture = false;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  bool _isRearCameraSelected = true;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (await Permission.camera.request().isGranted) {
      try {
        final cameras = await availableCameras();
        _controller = CameraController(
          cameras[_isRearCameraSelected ? 0 : 1],
          ResolutionPreset.high,
        );

        _initializeControllerFuture = _controller.initialize();

        await _initializeControllerFuture;

        _minAvailableZoom = await _controller.getMinZoomLevel();
        _maxAvailableZoom = await _controller.getMaxZoomLevel();

        if (!mounted) return;

        setState(() {});
      } catch (e) {
        _showErrorDialog('Camera Initialization Error', e.toString());
      }
    } else {
      _showErrorDialog(
          'Permission Error', 'Camera permission was not granted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _capturedImage == null
              ? Center(
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: AspectRatio(
                            aspectRatio: 1, // 카메라 미리보기 1:1 비율로 설정
                            child: GestureDetector(
                              onScaleUpdate: (details) async {
                                double newZoomLevel =
                                    _currentZoomLevel * details.scale;
                                newZoomLevel = newZoomLevel.clamp(
                                    _minAvailableZoom, _maxAvailableZoom);

                                setState(() {
                                  _currentZoomLevel = newZoomLevel;
                                });

                                await _controller
                                    .setZoomLevel(_currentZoomLevel);
                              },
                              child: CameraPreview(_controller),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Camera error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
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
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.loop, size: 30, color: Colors.black),
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
              child: FloatingActionButton(
                heroTag: "takePicture",
                backgroundColor: Colors.white,
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.black, width: 4)),
                onPressed: _isTakingPicture
                    ? null
                    : () async {
                        await _takePicture();
                      },
                child: const Icon(Icons.camera_alt, color: Colors.black),
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
                      side: const BorderSide(color: Colors.black, width: 4),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () async {
                      await _saveCroppedImage(_capturedImage!);
                      setState(() {
                        _capturedImage = null;
                      });
                    },
                    child: const Icon(Icons.save_alt, color: Colors.black),
                  ),
                  const SizedBox(width: 60),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      side: const BorderSide(color: Colors.black, width: 4),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      setState(() {
                        _capturedImage = null;
                      });
                    },
                    child: const Icon(Icons.replay, color: Colors.black),
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
      final image = await _controller.takePicture();
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
      // Load the image
      final bytes = await file.readAsBytes();
      final originalImage = await decodeImageFromList(bytes);

      // Calculate crop dimensions for 1:1 aspect ratio
      final originalWidth = originalImage.width.toDouble();
      final originalHeight = originalImage.height.toDouble();
      double cropSize =
          originalWidth < originalHeight ? originalWidth : originalHeight;

      final left = (originalWidth - cropSize) / 2;
      final top = (originalHeight - cropSize) / 2;

      // Create a new image with a 1:1 aspect ratio
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

      // Save the cropped image to the gallery
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          // Aspect ratio 1:1 for preview
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Image.file(
                File(capturedImage.path),
                fit: BoxFit.cover, // 이미지가 1:1 화면을 넘지 않도록
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
