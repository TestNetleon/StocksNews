import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/technicalAnalysis/item.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../widget/title_tag.dart';

class MsTechnicalAnalysis extends StatelessWidget {
  const MsTechnicalAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(title: "Technical Analysis Metrics"),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TechAnalysisMetricsRes? metrics = provider.metrics?[index];
            return MsTechnicalAnalysisItem(
              metrics: metrics,
            );
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 12);
          },
          itemCount: 4,
        ),
      ],
    );
  }
}
