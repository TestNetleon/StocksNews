import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import 'detail_view.dart';

class NewsDetailsAI extends StatelessWidget {
  final String? slug;

  const NewsDetailsAI({
    super.key,
    this.slug,
  });
//
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(isPopBack: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
        child: NewsDetailsBodyAI(slug: slug),
      ),
    );
  }
}
