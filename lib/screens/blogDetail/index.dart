import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/database_helper.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../service/amplitude/service.dart';
import '../auth/base/base_auth.dart';
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
      _getInitialData();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': 'Blog Details'},
      );
    });
  }

  void _getInitialData() async {
    BlogProvider blogProvider = context.read<BlogProvider>();
    UserProvider userProvider = context.read<UserProvider>();

    await blogProvider.getBlogDetailData(
      slug: widget.slug,
      inAppMsgId: widget.inAppMsgId,
      notificationId: widget.notificationId,
    );
    AmplitudeService.logUserInteractionEvent(
      type: 'Blog Detail',
      selfText: blogProvider.blogRes?.title ?? "",
    );
    if (blogProvider.blogsDetail?.readingStatus == false ||
        blogProvider.extra?.isOldApp == true) {
      return;
    }

    if (userProvider.user == null) {
      DatabaseHelper helper = DatabaseHelper();
      bool visible = await helper.fetchLoginDialogData(BlogDetail.path);
      if (visible) {
        Timer(const Duration(seconds: 3), () {
          if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
            helper.update(BlogDetail.path);
            // loginSheet();
            loginFirstSheet();
          }
        });
      }
    }
    //BECAUSE OF BOTTOM
    // else if (userProvider.user != null &&
    //     (userProvider.user?.phone == null || userProvider.user?.phone == "")) {
    //   DatabaseHelper helper = DatabaseHelper();
    //   bool visible = await helper.fetchLoginDialogData(BlogDetail.path);
    //   if (visible) {
    //     Timer(const Duration(seconds: 3), () {
    //       if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
    //         helper.update(BlogDetail.path);
    //         verifyIdentitySheet();
    //       }
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      bottomSafeAreaColor:
          context.watch<BlogProvider>().blogsDetail?.readingStatus == false
              ? ThemeColors.tabBack
              : null,
      appBar: const AppBarHome(isPopback: true),
      body: BlogDetailContainer(slug: widget.slug ?? ""),
    );
  }
}
