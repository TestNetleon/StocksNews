import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/marketData/drawerMarketDataScSimmer/tab_bar_sc_simmer.dart';
import 'package:stocks_news_new/widgets/screen_title_simmer.dart';

class WhatWeDoTabScreenSimmer extends StatelessWidget {
  const WhatWeDoTabScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScreenTitleSimmer(
          titleVisible: false,
        ),
        SizedBox(height: 60.sp, child: const TabViewScreenSimmer())
      ],
    );
  }
}
