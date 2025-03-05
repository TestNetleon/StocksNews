import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/ai_analysis.dart';
import 'package:stocks_news_new/ui/aiAnalysis/index.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../models/stockDetail/historical_chart.dart';
import '../../../models/stockDetail/overview.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../aiAnalysis/radar.dart';
import '../../base/heading.dart';
import 'chart.dart';
import 'company.dart';
import 'range.dart';
import 'stock_score.dart';

class SDOverview extends StatelessWidget {
  const SDOverview({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    SDCompanyRes? companyInfo = manager.dataOverview?.companyInfo;
    SDStockScoreRes? stockScore = manager.dataOverview?.stockScore;
    AIradarChartRes? aiAnalysis = manager.dataOverview?.aiAnalysis;

    SDHistoricalChartRes? chart = manager.dataHistoricalC;
    bool hasData = manager.dataHistoricalC != null;

    bool hideRange = companyInfo?.dayHigh == null ||
        companyInfo?.dayLow == null ||
        companyInfo?.yearHigh == null ||
        companyInfo?.yearLow == null;

    return BaseLoaderContainer(
      hasData: manager.dataOverview != null,
      isLoading: manager.isLoadingOverview,
      error: manager.errorOverview,
      showPreparingText: true,
      onRefresh: manager.onSelectedTabRefresh,
      child: BaseScroll(
        margin: EdgeInsets.zero,
        onRefresh: manager.onSelectedTabRefresh,
        children: [
          Visibility(
            visible: !hideRange,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: Row(
                children: [
                  Expanded(
                    child: SDRange(
                      title: 'Day’s Range',
                      endString: companyInfo?.dayHigh?.toFormattedPrice() ?? '',
                      endValue: companyInfo?.dayHigh ?? 0,
                      startString:
                          companyInfo?.dayLow?.toFormattedPrice() ?? '',
                      startValue: companyInfo?.dayLow ?? 0,
                      mainValue: companyInfo?.currentPrice ?? 0,
                    ),
                  ),
                  SpacerHorizontal(width: 10),
                  Expanded(
                    child: SDRange(
                      title: '52W Range',
                      endString:
                          companyInfo?.yearHigh?.toFormattedPrice() ?? '',
                      endValue: companyInfo?.yearHigh ?? 0,
                      startString:
                          companyInfo?.yearLow?.toFormattedPrice() ?? '',
                      startValue: companyInfo?.yearLow ?? 0,
                      mainValue: companyInfo?.currentPrice ?? 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Historical Chart
          SDHistoricalChart(
            hasData: hasData,
            chart: chart,
            error: manager.errorHistoricalC,
            onTap: (p0) {
              manager.getSDHistoricalC(range: p0);
            },
          ),
          SDCompanyBrief(companyInfo: companyInfo),
          Column(
            children: [
              SpacerVertical(height: Pad.pad24),
              BaseHeading(
                title: aiAnalysis?.title,
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                viewMore: () {
                  if (manager.selectedStock == null ||
                      manager.selectedStock == '') {
                    return;
                  }
                  Navigator.pushNamed(context, AIindex.path, arguments: {
                    'symbol': manager.selectedStock,
                  });
                },
              ),
              AIChart(aiAnalysis: aiAnalysis),
            ],
          ),
          SDStocksScore(stockScore: stockScore),
        ],
      ),
    );
  }
}
