import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../MsAnalysis/widget/title_tag.dart';
import 'widgets/footer_item.dart';
import 'widgets/gauge.dart';

class MsFundamentalAnalysisMetrics extends StatelessWidget {
  const MsFundamentalAnalysisMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(title: "Fundamental Analysis Metrics"),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.radar,
                          color: Colors.green,
                        ),
                        const SpacerVertical(height: 8),
                        Text(
                          'AI Satisfaction Scan',
                          style: stylePTSansBold(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Images.edit,
                        opacity: const AlwaysStoppedAnimation(.5),
                        height: 20,
                      ),
                      const SpacerVertical(height: 20),
                      Image.asset(
                        Images.report,
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
              Text(
                'Recent Customer Satisfaction Score',
                style: stylePTSansRegular(color: Colors.black),
              ),
              const SpacerVertical(height: 3),
              Text(
                'Within your casual range of 80-90%',
                style: stylePTSansRegular(color: Colors.green),
              ),
              const SpacerVertical(height: 8),
              MsMetricsGauge(),
              const SpacerVertical(height: 8),
              Row(
                children: List.generate(
                  3,
                  (index) {
                    return MsMetricsFooterItem(index: index);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
