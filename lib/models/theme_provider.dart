import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.blue; // Màu chủ đề mặc định
  String _fontFamily = 'Roboto'; // Font chữ mặc định

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  String get fontFamily => _fontFamily;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void setFontFamily(String font) {
    _fontFamily = font;
    notifyListeners();
  }
}
