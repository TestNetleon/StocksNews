import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';

class InfoBottomSheet extends StatelessWidget {
  const InfoBottomSheet({super.key});

  void _showBottomSheet({String? text}) {
    // showPlatformBottomSheet(
    //     padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
    //     context: navigatorKey.currentContext!,
    //     content: Padding(
    //       padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 10.sp),
    //       child: HtmlWidget(
    //         '''$text''',
    //         textStyle: const TextStyle(color: ThemeColors.white),
    //       ),
    //     ));

    BaseBottomSheets().gradientBottomSheet(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 20.sp),
      child: HtmlWidget(
        '''$text''',
        textStyle: const TextStyle(color: ThemeColors.white),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    String? text = context
        .read<RedditTwitterProvider>()
        .socialSentimentRes
        ?.text
        ?.sentimentText;

    return InkWell(
      onTap: () => _showBottomSheet(text: text),
      child: const Icon(
        Icons.info_rounded,
        size: 25,
      ),
    );
  }
}
