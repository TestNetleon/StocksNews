import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AllFeatureScreenSimmer extends StatelessWidget {
  const AllFeatureScreenSimmer({this.dataVisibleLastIndex = false, super.key});
  final bool dataVisibleLastIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Row(
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
                  width: 70.sp,
                ),
              ],
            ),
            const Expanded(child: SpacerHorizontal(width: 30)),
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
                      width: 30.sp,
                    ),
                    const SpacerVertical(height: 5),
                    GradientContainerWidget(
                      height: 20,
                      borderRadius: 2.sp,
                      width: 70.sp,
                    ),
                  ],
                ),
                Visibility(
                    visible: dataVisibleLastIndex,
                    child: const SpacerHorizontal(
                      width: 15,
                    )),
                Visibility(
                  visible: dataVisibleLastIndex,
                  child: GradientContainerWidget(
                    height: 25.sp,
                    borderRadius: 2.sp,
                    width: 25.sp,
                  ),
                ),
              ],
            ),
            const SpacerHorizontal(width: 10),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        // return const SpacerVertical(height: 12);
        return Divider(
          color: ThemeColors.greyBorder,
          height: 12,
        );
      },
    );
  }
}
