import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/simmer_effect_trending/trending_sc_simmer_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingSectorScreenSimmer extends StatelessWidget {
  const TrendingSectorScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 25,
      padding: EdgeInsets.symmetric(horizontal: Dimen.padding),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerVertical(),
              Divider(
                color: ThemeColors.greyBorder,
                height: 15,
                thickness: 1,
              ),
              Row(
                children: [
                  const SpacerHorizontal(width: 5),
                  GradientContainerWidget(
                    height: 20,
                    borderRadius: 2.sp,
                    width: 70.sp,
                  ),
                  const Expanded(child: SpacerHorizontal(width: 40)),
                  GradientContainerWidget(
                    height: 20,
                    borderRadius: 2.sp,
                    width: 70.sp,
                  ),
                  const Expanded(child: SpacerHorizontal(width: 40)),
                  GradientContainerWidget(
                    height: 20,
                    borderRadius: 2.sp,
                    width: 70.sp,
                  ),
                  const SpacerHorizontal(width: 10),
                ],
              ),
              Divider(
                color: ThemeColors.greyBorder,
                height: 15,
                thickness: 1,
              ),
            ],
          );
        }

        return const TrendingScreenSimmerItem(trendingSectorScreen: true);
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
