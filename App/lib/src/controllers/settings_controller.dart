import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  var isDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();

    final box = GetStorage();
    bool isDarkThemeStorage = box.read("isDarkTheme") ?? false;

    isDarkTheme.value = isDarkThemeStorage;
    Get.changeTheme(!isDarkThemeStorage ? ThemeData.light() : ThemeData.dark());
  }

  void setDarkTheme(bool isDark) {
    isDarkTheme.value = isDark;

    final box = GetStorage();
    box.write("isDarkTheme", isDarkTheme.value);

    Get.changeTheme(!isDark ? ThemeData.light() : ThemeData.dark());
  }
}
