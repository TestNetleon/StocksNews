// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';

import 'package:stocks_news_new/widgets/base_container.dart';

class AlertPopUpDialog extends StatelessWidget {
  static const String path = "AlertPopUpDialog";

  const AlertPopUpDialog({required this.content, super.key});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appbar: const AppBarHome(isPopback: true, showTrailing: false),
      body: content,
    );
  }
}
