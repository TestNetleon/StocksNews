import 'package:flutter/foundation.dart';

import '../screens/drawer/settings/index.dart';

class NotificationsSettingProvider extends ChangeNotifier {
  bool allOn = true;

  final List<NotificationTurn> data = [
    NotificationTurn(
      label: "Alerts",
      isOn: true,
    ),
    NotificationTurn(
      label: "Watchlist",
      isOn: true,
    ),
    NotificationTurn(
      label: "Spike",
      isOn: true,
    ),
    NotificationTurn(
      label: "Blog",
      isOn: true,
    ),
    NotificationTurn(
      label: "News",
      isOn: true,
    ),
    NotificationTurn(
      label: "General Notification",
      isOn: true,
    ),
  ];

  void open(int index) {
    data[index].isOn = !data[index].isOn;
    notifyListeners();
    _updateAllOnStatus();
  }

  void changeAll() {
    allOn = !allOn;
    for (var notification in data) {
      notification.isOn = allOn;
    }
    notifyListeners();
  }

  void _updateAllOnStatus() {
    allOn = data.every((notification) => notification.isOn);
    notifyListeners();
  }
}
