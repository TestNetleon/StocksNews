import 'package:flutter/material.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/constants.dart';
import 'summary/index.dart';

class MsTechnicalAnalysisItem extends StatelessWidget {
  final TechAnalysisMetricsRes? metrics;
  const MsTechnicalAnalysisItem({super.key, this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  metrics?.title ?? "N/A",
                  style: styleGeorgiaBold(
                      color: ThemeColors.background, fontSize: 18),
                ),
              ),
              const SpacerHorizontal(width: 20),
              Image.asset(
                Images.download,
                height: 20,
              ),
              const SpacerHorizontal(width: 8),
              Image.asset(
                Images.edit,
                height: 20,
              ),
              const SpacerHorizontal(width: 8),
              const Icon(
                Icons.arrow_outward,
                color: Colors.black,
              )
            ],
          ),
          Text(
            metrics?.subTitle ?? "N/A",
            style: stylePTSansRegular(color: ThemeColors.background),
          ),
          SpacerVertical(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metrics?.revenueOf ?? "N/A",
                      style: styleGeorgiaBold(
                          color: ThemeColors.accent, fontSize: 19),
                    ),
                    Text(
                      metrics?.revenue ?? "N/A",
                      style: styleGeorgiaBold(
                        color: ThemeColors.accent,
                        fontSize: 34,
                      ),
                    ),
                  ],
                ),
              ),
              SpacerHorizontal(width: 10),
              Visibility(
                visible: metrics?.image != null && metrics?.image != '',
                child: Image.asset(
                  metrics?.image ?? "",
                  width: 170,
                  fit: BoxFit.cover,
                  color: ThemeColors.accent,
                ),
              ),
            ],
          ),
          SpacerVertical(height: 10),
          Align(
            alignment: Alignment.center,
            child: MsMetricsSummary(),
          ),
        ],
      ),
    );
  }
}
