import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../../models/stockDetail/technical_analysis.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/spacer_vertical.dart';
import 'container.dart';
import 'extra/range.dart';

class SDTechnicalAnalysis extends StatelessWidget {
  const SDTechnicalAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    TechnicalAnalysisDataRes? summary = manager.dataTechnicalAnalysis?.summary;
    TechnicalAnalysisDataRes? technicalIndicator =
        manager.dataTechnicalAnalysis?.technicalIndicator;
    TechnicalAnalysisDataRes? movingAverage =
        manager.dataTechnicalAnalysis?.movingAverage;

    List<BaseKeyValueRes>? indicatorsData = technicalIndicator?.data;
    List<BaseKeyValueRes>? averageData = movingAverage?.data;

    return BaseLoaderContainer(
      hasData: manager.dataTechnicalAnalysis != null,
      isLoading: manager.isLoadingTechnicalAnalysis &&
          manager.dataTechnicalAnalysis == null,
      error: manager.errorTechnicalAnalysis,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: Column(
        children: [
          SpacerVertical(height: Pad.pad16),
          TechnicalAnaRange(
            onTap: (range) {
              manager.getSDTechnicalAnalysis(
                interval: range,
                showProgress: true,
              );
            },
          ),
          Divider(
            color: ThemeColors.neutral5,
            height: 10,
          ),
          Expanded(
            child: BaseScroll(
              onRefresh: manager.onSelectedTabRefresh,
              margin: EdgeInsets.zero,
              children: [
                if (summary?.overview != null)
                  TechnicalAnaContainer(
                    title: summary?.title,
                    overview: summary!.overview!,
                  ),
                if (technicalIndicator?.overview != null)
                  TechnicalAnaContainer(
                    title: technicalIndicator?.title,
                    overview: technicalIndicator!.overview!,
                    data: indicatorsData,
                    listTitles: ['Name', 'Value', 'Action'],
                  ),
                if (movingAverage?.overview != null)
                  TechnicalAnaContainer(
                    title: movingAverage?.title,
                    overview: movingAverage!.overview!,
                    data: averageData,
                    onAverage: true,
                    listTitles: ['Name', 'Value', 'Action', 'Weighted'],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
