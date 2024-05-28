import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class CompareHeaderScreenSimmer extends StatelessWidget {
  const CompareHeaderScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
            height: constraints.maxWidth * .29,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GradientContainerWidget(
                  height: constraints.maxWidth * .29,
                  width: 100,
                  borderRadius: 2.sp,
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerHorizontal(width: 10);
              },
              itemCount: 5,
            ));
      },
    );
  }
}
