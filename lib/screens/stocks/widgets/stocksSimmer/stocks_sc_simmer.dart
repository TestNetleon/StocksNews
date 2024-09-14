import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StocksScreenSimmer extends StatelessWidget {
  const StocksScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      separatorBuilder: (context, index) {
        // return const SpacerVertical(height: 10);
        if (index == 0) {
          return const SizedBox();
        }
        return Divider(
          color: ThemeColors.greyBorder,
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Divider(
                color: ThemeColors.greyBorder,
                height: 15,
                thickness: 1,
              ),
              Row(
                children: [
                  const SpacerHorizontal(width: 5),
                  Expanded(
                    child: GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 10.sp,
                    ),
                  ),
                  const SpacerHorizontal(width: 24),
                  Expanded(
                    child: GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 10.sp,
                    ),
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.sp),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 43,
                      height: 43,
                      child: GradientContainerWidget(
                        height: 43,
                        borderRadius: 2.sp,
                        width: 43,
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 3),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientContainerWidget(
                          height: 20,
                          borderRadius: 2.sp,
                          width: 50.sp,
                        ),
                        const SpacerVertical(height: 2),
                        GradientContainerWidget(
                          height: 20,
                          borderRadius: 2.sp,
                          width: 70.sp,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientContainerWidget(
                    height: 20,
                    borderRadius: 2.sp,
                    width: 50.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientContainerWidget(
                              height: 20,
                              borderRadius: 2.sp,
                              width: 70.sp,
                            )
                          ],
                        ),
                      ),
                      GradientContainerWidget(
                        height: 25,
                        borderRadius: 2.sp,
                        width: 25,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
