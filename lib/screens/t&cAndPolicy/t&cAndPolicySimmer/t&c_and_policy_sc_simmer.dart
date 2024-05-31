// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TermsAndConditionsScreenSimmer extends StatelessWidget {
  const TermsAndConditionsScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpacerVertical(),
          GradientContainerWidget(
            height: 1000.sp,
            borderRadius: 2.sp,
          ),
        ],
      ),
    );
  }
}
