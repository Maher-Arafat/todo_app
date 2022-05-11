import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _ky = 'isDarkMode';

  _savehemeTobox(bool isDarkMode) => _box.write(_ky, isDarkMode);

  bool _loadThemeFrombox() => _box.read<bool>(_ky) ?? false;

  ThemeMode get theme => _loadThemeFrombox() ? ThemeMode.dark : ThemeMode.light;
  void swthTheme() {
    Get.changeThemeMode(_loadThemeFrombox() ? ThemeMode.light : ThemeMode.dark);
    _savehemeTobox(!_loadThemeFrombox());
  }
}
