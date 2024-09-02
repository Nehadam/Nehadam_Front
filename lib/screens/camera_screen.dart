import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart'; // 갤러리 저장을 위한 패키지
import 'package:permission_handler/permission_handler.dart'; // 권한 처리

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isTakingPicture = false; // State variable to track capture progress
  double _currentZoomLevel = 1.0; // Current zoom level
  double _minAvailableZoom = 1.0; // Minimum zoom level
  double _maxAvailableZoom = 1.0; // Maximum zoom level

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (await Permission.camera.request().isGranted) {
      try {
        final cameras = await availableCameras();
        final firstCamera = cameras.first;

        _controller = CameraController(
          firstCamera,
          ResolutionPreset.high,
        );

        _initializeControllerFuture = _controller.initialize();

        // Ensure that the future is completed
        await _initializeControllerFuture;

        // Fetch zoom limits
        _minAvailableZoom = await _controller.getMinZoomLevel();
        _maxAvailableZoom = await _controller.getMaxZoomLevel();

        if (!mounted) return;

        setState(() {});
      } catch (e) {
        print('Error initializing camera: $e');
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
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                onScaleUpdate: (details) async {
                  // Calculate the zoom level based on scale and limits
                  double newZoomLevel = _currentZoomLevel * details.scale;
                  newZoomLevel =
                      newZoomLevel.clamp(_minAvailableZoom, _maxAvailableZoom);

                  setState(() {
                    _currentZoomLevel = newZoomLevel;
                  });

                  // Apply the zoom level
                  await _controller.setZoomLevel(_currentZoomLevel);
                },
                child: CameraPreview(_controller),
              );
            } else if (snapshot.hasError) {
              return Text('Camera error: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isTakingPicture
            ? null
            : () async {
                try {
                  setState(() {
                    _isTakingPicture = true; // Disable button during capture
                  });
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  await saveImage(image);
                } catch (e) {
                  print('Error taking picture: $e');
                  _showErrorDialog('Error',
                      'An error occurred while taking the picture: $e');
                } finally {
                  setState(() {
                    _isTakingPicture = false; // Re-enable button after capture
                  });
                }
              },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> saveImage(XFile file) async {
    try {
      final bytes = await file.readAsBytes(); // Get image bytes

      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(bytes),
          name: DateTime.now().toIso8601String()); // Save to gallery

      if (result != null && result['isSuccess']) {
        print('Image saved to gallery successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지가 갤러리에 저장되었습니다.')),
        );
      } else {
        print('Failed to save image to gallery');
        _showErrorDialog('Save Error', 'Failed to save image to gallery.');
      }
    } catch (e) {
      print('Error saving image: $e');
      _showErrorDialog('Error', 'An error occurred while saving the image: $e');
    }
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
