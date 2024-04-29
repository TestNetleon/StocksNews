import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/scroll_controller.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/news_details_body.dart';

import 'package:stocks_news_new/widgets/base_container.dart';

class NewsDetails extends StatelessWidget {
  static const String path = "NewsDetails";
  final String? slug;
  const NewsDetails({super.key, this.slug});
//
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ScrollControllerProvider(),
      child: BaseContainer(
        drawer: const BaseDrawer(resetIndex: true),
        appbar: const AppBarHome(isPopback: true, showTrailing: false),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
          child: NewsDetailsBody(slug: slug),
        ),
      ),
    );
  }
}
