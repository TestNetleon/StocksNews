import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../widgets/container.dart';
import '../widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/today.dart';
import 'widgets/year.dart';

double msWidthPadding = ScreenUtil().screenWidth - 40;

class MsPerformance extends StatelessWidget {
  const MsPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    return MsOverviewContainer(
      open: provider.openPerformance,
      baseChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: MsOverviewHeader(
          leadingIcon: Icons.electric_bolt,
          trailingIcon: Icons.ac_unit_outlined,
          label: 'Performance',
          onTap: provider.openPerformanceStatus,
        ),
      ),
      animatedChild: const Column(
        children: [
          SpacerVertical(height: 10),
          MsPerformanceYear(),
          SpacerVertical(height: 10),
          MsPerformanceToday(),
          MsPerformanceFooter(),
        ],
      ),
    );
  }
}
