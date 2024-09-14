import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class InsiderDetailScreenSimmer extends StatelessWidget {
  const InsiderDetailScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 15,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const GradientContainerWidget(
                height: 200,
              ),
              Divider(
                color: ThemeColors.greyBorder,
                height: 15,
                thickness: 1,
              ),
              Row(
                children: [
                  GradientContainerWidget(
                    height: 20,
                    width: 100.sp,
                  ),
                  const Expanded(child: SizedBox()),
                  GradientContainerWidget(
                    height: 20,
                    width: 100.sp,
                  ),
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 60.sp,
                    ),
                    const SpacerVertical(height: 3),
                    GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 40.sp,
                    ),
                    const SpacerVertical(height: 3),
                    GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 80.sp,
                    ),
                    const SpacerVertical(height: 3),
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
                          width: 60.sp,
                        ),
                        const SpacerVertical(height: 5),
                        GradientContainerWidget(
                          height: 30.sp,
                          borderRadius: 2.sp,
                          width: 30.sp,
                        ),
                        SpacerVertical(height: 3.sp),
                      ],
                    ),
                  ],
                ),
                const SpacerHorizontal(width: 10),
              ],
            ),
            GradientContainerWidget(
              height: 20,
              borderRadius: 2.sp,
              width: 120.sp,
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        // return const SpacerVertical(height: 12);
        if (index == 0) {
          return const SizedBox();
        }
        return Divider(
          color: ThemeColors.greyBorder,
          height: 12,
        );
      },
    );
  }
}
