import 'package:flutter/foundation.dart';

class Image_State with ChangeNotifier {
  String _image_FramePath = 'assets/data/frames/blacksquare.jpg'; // 초기 이미지 경로

  String get image_FramePath => _image_FramePath;

  void updateimage_FramePath(String newPath) {
    _image_FramePath = newPath;
    notifyListeners();
  }

  String _image_FilterPath = 'assets/data/filters/cartoon.jpg'; // 초기 이미지 경로

  String get image_FilterPath => _image_FilterPath;

  void updateimage_FilterPath(String newPath2) {
    _image_FilterPath = newPath2;
    notifyListeners();
  }
}
