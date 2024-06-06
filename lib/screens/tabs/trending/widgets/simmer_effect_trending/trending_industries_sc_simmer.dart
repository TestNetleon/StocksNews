import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/simmer_effect_trending/tr_indus_sc_simmer_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingIndustriesSimmer extends StatelessWidget {
  const TrendingIndustriesSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      padding: EdgeInsets.symmetric(horizontal: Dimen.padding.sp),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.sp),
                child: GradientContainerWidget(height: 40, borderRadius: 2.sp),
              ),
              const GradientContainerWidget(height: 200),
              const SpacerVertical(height: 20)
            ],
          );
        }

        return const TrendingIndustriesScreenSimmerItem();
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index == 0) return const SizedBox();

        return const Divider(
          color: ThemeColors.greyBorder,
          height: 12,
        );
      },
    );
  }
}
