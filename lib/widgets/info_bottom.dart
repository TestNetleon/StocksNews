import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

import '../providers/home_provider.dart';

class InfoBottomSheet extends StatelessWidget {
  const InfoBottomSheet({super.key});

  void _showBottomSheet({String? text}) {
    showPlatformBottomSheet(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
        context: navigatorKey.currentContext!,
        content: Padding(
          padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 10.sp),
          child: HtmlWidget(
            '''$text''',
            textStyle: const TextStyle(color: ThemeColors.white),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String? text = context.read<HomeProvider>().homeSentimentRes?.text;

    return InkWell(
      onTap: () => _showBottomSheet(text: text),
      child: Icon(
        Icons.info_rounded,
        size: 25.sp,
      ),
    );
  }
}
