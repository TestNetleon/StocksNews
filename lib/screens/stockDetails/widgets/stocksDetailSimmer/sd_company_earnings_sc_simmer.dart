import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StocksDetailCompanyEarningsSimmer extends StatelessWidget {
  const StocksDetailCompanyEarningsSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerVertical(),
              Row(
                children: [
                  const GradientContainerWidget(
                    height: 43,
                    width: 43,
                  ),
                  const SpacerHorizontal(width: 12),
                  Column(
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
                    ],
                  ),
                ],
              ),
              const SpacerVertical(height: 10),
              GradientContainerWidget(
                height: 40,
                borderRadius: 2.sp,
              ),
              SpacerVertical(height: 20.sp),
              Divider(
                color: ThemeColors.greyBorder,
                height: 15.sp,
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
                    height: 30,
                    borderRadius: 2.sp,
                    width: 70.sp,
                  ),
                  const Expanded(child: SpacerHorizontal(width: 40)),
                  GradientContainerWidget(
                    height: 30,
                    borderRadius: 2.sp,
                    width: 70.sp,
                  ),
                  const SpacerHorizontal(width: 10),
                ],
              ),
              Divider(
                color: ThemeColors.greyBorder,
                height: 15.sp,
                thickness: 1,
              ),
            ],
          );
        }
        return Row(
          children: [
            const SpacerHorizontal(width: 5),
            GradientContainerWidget(
              height: 20,
              borderRadius: 2.sp,
              width: 70.sp,
            ),
            const Expanded(child: SpacerHorizontal(width: 40)),
            GradientContainerWidget(
              height: 30,
              borderRadius: 2.sp,
              width: 70.sp,
            ),
            const Expanded(child: SpacerHorizontal(width: 40)),
            GradientContainerWidget(
              height: 30,
              borderRadius: 2.sp,
              width: 70.sp,
            ),
            const SpacerHorizontal(width: 10),
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
