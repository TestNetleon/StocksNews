import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'container.dart';

class BlogDetail extends StatefulWidget {
  static const path = "BlogDetail";
  // final String? id;
  final String? slug;
  final String? inAppMsgId;
  final String? notificationId;
  const BlogDetail({
    super.key,
    this.slug,
    this.inAppMsgId,
    this.notificationId,
  });

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BlogProvider>().getBlogDetailData(
            // blogId: widget.id ?? "",
            slug: widget.slug,
            inAppMsgId: widget.inAppMsgId,
            notificationId: widget.notificationId,
          );
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': 'My Account'},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        try {
          if (popHome || deepLinkData != null) {
            Future.delayed(const Duration(milliseconds: 50), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Tabs.path, (route) => false);
              popHome = false;
              deepLinkData = null;
            });
          }
        } catch (e) {
          //
        }
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopback: true,
          canSearch: true,
        ),
        body: BlogDetailContainer(slug: widget.slug ?? ""),
      ),
    );
  }
}
