import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _loadTheme();
  }

  void toggleTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    ThemeColors.updateTheme(!isDarkMode);
  }

  bool get isDarkMode {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return _themeMode == ThemeMode.system
        ? brightness == Brightness.dark
        : _themeMode == ThemeMode.dark;
  }

  // bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() async {
    _themeMode = ThemeMode.system;
    notifyListeners();
    Utils().showLog('!!----THEME $_themeMode');
    Utils().showLog('!!----THEME DARK? $isDarkMode');

    ThemeColors.updateTheme(!isDarkMode);
  }
}
