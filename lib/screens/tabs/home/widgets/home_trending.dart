import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/stocks_item_trending.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeTrending extends StatelessWidget {
  const HomeTrending({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacerVertical(height: 10.sp),
        CustomReadMoreText(
          text: provider.homeTrendingRes?.text?.trending ?? "",
        ),
        ListView.separated(
          itemCount: provider.homeTrendingRes?.trending.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 12.sp),
          itemBuilder: (context, index) {
            HomeTrendingData trending =
                provider.homeTrendingRes!.trending[index];
            return StocksItemTrending(trending: trending);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SpacerVertical(height: 12);
          },
        ),
        // Divider(
        //   color: ThemeColors.greyBorder,
        //   height: 20.sp,
        // ),
      ],
    );
  }
}
