import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingScreenSimmerItem extends StatelessWidget {
  const TrendingScreenSimmerItem(
      {this.trendingSectorScreen = false, super.key});
  final bool trendingSectorScreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const GradientContainerWidget(
          height: 43,
          width: 43,
        ),
        const SpacerHorizontal(width: 5),
        GradientContainerWidget(
          height: 20,
          borderRadius: 2.sp,
          width: 50.sp,
        ),
        const Expanded(child: SpacerHorizontal(width: 30)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GradientContainerWidget(
              height: 20,
              borderRadius: 2.sp,
              width: 50.sp,
            ),
            Visibility(
                visible: !trendingSectorScreen,
                child: const SpacerVertical(height: 5)),
            Visibility(
              visible: !trendingSectorScreen,
              child: GradientContainerWidget(
                height: 20,
                borderRadius: 2.sp,
                width: 30.sp,
              ),
            ),
          ],
        ),
        const Expanded(child: SpacerHorizontal(width: 40)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GradientContainerWidget(
                  height: 20,
                  borderRadius: 2.sp,
                  width: 50.sp,
                ),
                Visibility(
                    visible: !trendingSectorScreen,
                    child: const SpacerVertical(height: 5)),
                Visibility(
                  visible: !trendingSectorScreen,
                  child: GradientContainerWidget(
                    height: 20,
                    borderRadius: 2.sp,
                    width: 30.sp,
                  ),
                ),
              ],
            ),
            Visibility(
                visible: !trendingSectorScreen,
                child: const SpacerHorizontal(width: 5)),
            Visibility(
              visible: !trendingSectorScreen,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientContainerWidget(
                    height: 5,
                    width: 5,
                    borderRadius: 5,
                  ),
                  SpacerVertical(height: 2),
                  GradientContainerWidget(
                    height: 5,
                    width: 5,
                    borderRadius: 5,
                  ),
                  SpacerVertical(height: 2),
                  GradientContainerWidget(
                    height: 5,
                    width: 5,
                    borderRadius: 5,
                  ),
                ],
              ),
            )
          ],
        ),
        const SpacerHorizontal(width: 10),
      ],
    );
  }
}
