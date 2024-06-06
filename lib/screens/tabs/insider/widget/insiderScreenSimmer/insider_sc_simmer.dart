import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class InsiderScreenSimmer extends StatelessWidget {
  const InsiderScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      // physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: isPhone ? 12.sp : 5.sp),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientContainerWidget(
              height: 40,
              borderRadius: 5.sp,
            ),
            const SpacerVertical(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientContainerWidget(
                        height: 20,
                        borderRadius: 2.sp,
                        width: 50.sp,
                      ),
                      const SpacerVertical(height: 5),
                      GradientContainerWidget(
                        height: 20,
                        borderRadius: 2.sp,
                        width: 50.sp,
                      ),
                      const SpacerVertical(height: 15),
                      GradientContainerWidget(
                        height: 20,
                        borderRadius: 2.sp,
                        width: 100.sp,
                      ),
                      const SpacerVertical(height: 5),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 25.sp,
                    ),
                    const SpacerVertical(height: 5),
                    GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 25.sp,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GradientContainerWidget(
                  height: 20,
                  borderRadius: 2.sp,
                  width: 50.sp,
                ),
                GradientContainerWidget(
                  height: 20,
                  borderRadius: 2.sp,
                  width: 100.sp,
                ),
              ],
            )
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
    );
  }
}
