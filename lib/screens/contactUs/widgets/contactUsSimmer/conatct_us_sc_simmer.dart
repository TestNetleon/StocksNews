import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ContactUsScreenSimmer extends StatelessWidget {
  const ContactUsScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GradientContainerWidget(
                      height: 6.sp,
                      borderRadius: 3.sp,
                      width: 6.sp,
                    ),
                    const SpacerHorizontal(width: 5),
                    const Expanded(
                      child: GradientContainerWidget(
                        height: 14,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerVertical(height: 5);
              },
              itemCount: 5),
          const SpacerVertical(height: 30),
          GradientContainerWidget(
            height: 400,
            borderRadius: 10.sp,
          ),
        ],
      ),
    );
  }
}
