// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/scroll_controller.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/news_details_body.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../../providers/search_provider.dart';
import '../../tabs.dart';

class NewsDetails extends StatelessWidget {
  static const String path = "NewsDetails";
  final String? slug;
  final String? inAppMsgId;
  final String? notificationId;

  const NewsDetails({
    super.key,
    this.inAppMsgId,
    this.notificationId,
    this.slug,
  });
//
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        try {
          if (popHome) {
            Future.delayed(const Duration(milliseconds: 50), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Tabs.path, (route) => false);
              popHome = false;
            });
          }
        } catch (e) {
          //
        }
      },
      child: BaseContainer(
        drawer: const BaseDrawer(resetIndex: true),
        appBar: const AppBarHome(
          isPopback: true,
          showTrailing: true,
          canSearch: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
          child: NewsDetailsBody(
            slug: slug,
            inAppMsgId: inAppMsgId,
            notificationId: notificationId,
          ),
        ),
      ),
    );
  }
}
