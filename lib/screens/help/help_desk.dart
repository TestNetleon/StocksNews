import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/help/help_desk_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class HelpDesk extends StatelessWidget {
  static const String path = "HelpDesk";

  final String? slug;
  const HelpDesk({this.slug, super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: HelpDeskList(
          slug: slug,
        ),
      ),
    );
  }
}
