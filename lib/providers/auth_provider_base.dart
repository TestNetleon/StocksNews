import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login.dart';
import 'package:stocks_news_new/utils/preference.dart';

mixin AuthProviderBase {
  // void logout() {
  //   // Clear user data and perform any other logout-related tasks
  //   Preference.logout();
  //   Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
  //   Navigator.pushReplacementNamed(navigatorKey.currentContext!, Login.path);
  //   navigatorKey.currentContext!.read<UserProvider>().clearUser();
  // }
//
  void handleSessionOut() {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(navigatorKey.currentContext!, Login.path);

    Preference.logout();
    navigatorKey.currentContext!.read<UserProvider>().clearUser();
    //   Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    //   Navigator.pushReplacementNamed(navigatorKey.currentContext!, Login.path);
  }
}
