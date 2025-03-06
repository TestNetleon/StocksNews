import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../managers/aiAnalysis/ai.dart';
import 'widgets/footer.dart';
import 'widgets/today.dart';
import 'widgets/year.dart';

double msWidthPadding = ScreenUtil().screenWidth - 30;

class AIPerformance extends StatelessWidget {
  const AIPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: manager.data?.performance?.title,
          margin: EdgeInsets.only(
            right: Pad.pad16,
            left: Pad.pad16,
            top: 48,
            bottom: Pad.pad8,
          ),
        ),
        BaseBorderContainer(
          innerPadding: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: Pad.pad16),
          child: Column(
            children: [
              SpacerVertical(height: 20),
              AIPerformanceYear(),
              AIPerformanceToday(),
              Divider(
                color: ThemeColors.neutral5,
                height: Pad.pad32,
                thickness: 1,
              ),
              AIPerformanceFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
