import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewsScreenSimmer extends StatelessWidget {
  const NewsScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      padding: EdgeInsets.only(
        bottom: 12.sp,
        top: 12.sp,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientContainerWidget(height: ScreenUtil().screenWidth / 2),
              const SpacerVertical(),
              GradientContainerWidget(height: 20, borderRadius: 2.sp),
              const SpacerVertical(height: 5),
              GradientContainerWidget(height: 20, borderRadius: 2.sp),
              const SpacerVertical(height: 5),
              GradientContainerWidget(
                height: 10,
                borderRadius: 2.sp,
                width: ScreenUtil().screenWidth * .5,
              ),
              const SpacerVertical(height: 10),
              const SpacerVertical(height: 10),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientContainerWidget(height: 20, borderRadius: 2.sp),
                  const SpacerVertical(height: 5),
                  GradientContainerWidget(height: 20, borderRadius: 2.sp),
                  const SpacerVertical(height: 5),
                  GradientContainerWidget(
                    height: 10,
                    borderRadius: 2.sp,
                    width: ScreenUtil().screenWidth * .4,
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 10),
            const GradientContainerWidget(
              height: 100,
              width: 100,
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: ThemeColors.greyBorder,
          height: 20,
        );
      },
    );
  }
}
