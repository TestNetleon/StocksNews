import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/msAnalysis/radar_chart.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import '../../../modals/msAnalysis/complete.dart';
import '../../../utils/constants.dart';
import '../widget/title_tag.dart';
import 'item.dart';

class MsOurHighlights extends StatelessWidget {
  const MsOurHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsTextRes? text = provider.completeData?.text;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimen.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MsTitle(
            title: text?.highlights?.title,
            subtitle: text?.highlights?.subTitle,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.completeData?.stockHighLights?.length ?? 0,
                  (index) {
                    MsRadarChartRes? data =
                        provider.completeData?.stockHighLights?[index];
                    return MsOurHighlightsItem(data: data);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
