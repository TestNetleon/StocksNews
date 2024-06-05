import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/notifications/container.dart';

class Notifications extends StatelessWidget {
  static const String path = "Notifications";

  const Notifications({super.key});
//
  @override
  Widget build(BuildContext context) {
    return const NotificationsContainer();
  }
}
