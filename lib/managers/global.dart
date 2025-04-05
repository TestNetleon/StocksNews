import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/notifications/index.dart';

class GlobalManager extends ChangeNotifier {
  int _openIndex = 0;
  int get openIndex => _openIndex;

  void change(int index) {
    _openIndex = index;
    notifyListeners();
  }

  Future navigateToNotification() async {
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    await manager.askLoginScreen();
    if (manager.user == null) return;
    // await Navigator.pushNamed(
    //   navigatorKey.currentContext!,
    //   NotificationIndex.path,
    // );

    await Navigator.push(navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => NotificationIndex()));
  }
}
