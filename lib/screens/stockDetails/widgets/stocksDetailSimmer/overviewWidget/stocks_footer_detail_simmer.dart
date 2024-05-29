import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/screen_title_simmer.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StocksFooterDetailSimmer extends StatelessWidget {
  const StocksFooterDetailSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SpacerVertical(height: 20),
        GradientContainerWidget(
          height: 280.sp,
        ),
        SizedBox(
          height: 50.sp,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientContainerWidget(
                height: 28.sp,
                width: 40.sp,
              ),
              const SpacerHorizontal(width: 15),
              GradientContainerWidget(
                height: 28.sp,
                width: 40.sp,
              ),
              const SpacerHorizontal(width: 15),
              GradientContainerWidget(
                height: 28.sp,
                width: 40.sp,
              ),
              const SpacerHorizontal(width: 15),
              GradientContainerWidget(
                height: 28.sp,
                width: 40.sp,
              ),
              const SpacerHorizontal(width: 15),
              GradientContainerWidget(
                height: 28.sp,
                width: 40.sp,
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 30),
        const ScreenTitleSimmer(
          titleVisible: false,
        ),
        ListView.separated(
          itemCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GradientContainerWidget(
                  height: 20,
                  width: 70,
                ),
                GradientContainerWidget(
                  height: 20,
                  width: 70,
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            // return const SpacerVertical(height: 12);
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
        ),
        const SpacerVertical(height: 5),
        GradientContainerWidget(
          height: 400.sp,
          borderRadius: 2.sp,
        )
      ],
    );
  }
}
