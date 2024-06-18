import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SimmerScreenDrawerCommon extends StatelessWidget {
  const SimmerScreenDrawerCommon({this.downIconVisible = false, super.key});
  final bool downIconVisible;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      padding: EdgeInsets.only(top: isPhone ? 12.sp : 5.sp),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientContainerWidget(
                height: 40,
                borderRadius: 5.sp,
              ),
              const SpacerVertical()
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GradientContainerWidget(
                  height: 43,
                  width: 43,
                ),
                const SpacerHorizontal(width: 12),
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
                        width: 100.sp,
                      ),
                      const SpacerVertical(height: 5),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                      width: 40.sp,
                    ),
                  ],
                ),
                Visibility(
                    visible: downIconVisible == false,
                    child: const SpacerHorizontal(width: 10)),
                Visibility(
                  visible: downIconVisible == false,
                  child: const GradientContainerWidget(
                    height: 25,
                    width: 25,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const SizedBox();
        }
        return Divider(
          color: ThemeColors.greyBorder,
          height: 20.sp,
        );
      },
    );
  }
}
