import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'container.dart';

class BlogDetail extends StatefulWidget {
  static const path = "BlogDetail";
  final String id;
  const BlogDetail({super.key, required this.id});

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

//
class _BlogDetailState extends State<BlogDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BlogProvider>().getBlogDetailData(blogId: widget.id);

      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': 'My Account'},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: false,
      ),
      body: BlogDetailContainer(id: widget.id),
    );
  }
}
