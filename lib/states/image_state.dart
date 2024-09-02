import 'package:flutter/foundation.dart';

class Image_State with ChangeNotifier {
  String _image_FramePath = 'assets/data/frames/blacksquare.jpg'; // 초기 프레임 경로
  String _image_FilterPath = 'assets/data/filters/cartoon.jpg'; // 초기 필터 경로
  String _selectedImagePath = ''; // 선택된 이미지 경로

  // 현재 프레임 경로를 가져오는 getter
  String get image_FramePath => _image_FramePath;

  // 현재 필터 경로를 가져오는 getter
  String get image_FilterPath => _image_FilterPath;

  // 현재 선택된 이미지 경로를 가져오는 getter
  String get selectedImagePath => _selectedImagePath;
  String _selectedTheme = 'Cartoon'; // 초기 테마

  // 현재 선택된 테마를 가져오는 getter
  String get selectedTheme => _selectedTheme;
  // 프레임 경로를 업데이트하는 메서드
  void updateimage_FramePath(String newPath) {
    _image_FramePath = newPath;
    notifyListeners(); // 변경 사항 알림
  }

  // 필터 경로를 업데이트하는 메서드
  void updateimage_FilterPath(String newPath2) {
    _image_FilterPath = newPath2;
    notifyListeners(); // 변경 사항 알림
  }

  // 테마를 업데이트하는 메서드
  void updateSelectedTheme(String newTheme) {
    _selectedTheme = newTheme;
    notifyListeners(); // 변경 사항 알림
  }

  // 선택된 이미지 경로를 업데이트하는 메서드
  void updateSelectedImagePath(String newPath) {
    _selectedImagePath = newPath;
    notifyListeners(); // 변경 사항 알림
  }
}
