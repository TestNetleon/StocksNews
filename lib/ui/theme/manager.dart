import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/colors.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _loadTheme(reload: true);
  }

  void toggleTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    ThemeColors.updateTheme(!isDarkMode);
    Preference.setTheme(mode);
  }

  bool get isDarkMode {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return _themeMode == ThemeMode.system
        ? brightness == Brightness.dark
        : _themeMode == ThemeMode.dark;
  }

  // bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme({bool reload = false}) async {
    _themeMode = await Preference.getTheme();
    if (!reload) notifyListeners();
    ThemeColors.updateTheme(!isDarkMode);
  }
}
