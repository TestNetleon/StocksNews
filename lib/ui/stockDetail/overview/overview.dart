import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../models/stockDetail/overview.dart';
import 'ai_chart.dart';
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
    SDAiAnalysisRes? aiAnalysis = manager.dataOverview?.aiAnalysis;
    ;

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
                      title: '',
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
          SDHistoricalChart(),
          SDCompanyBrief(companyInfo: companyInfo),
          SDAiChart(
            // data: aiAnalysis?.radarChart,
            // title: aiAnalysis?.title,
            aiAnalysis: aiAnalysis,
          ),
          SDStocksScore(stockScore: stockScore),
        ],
      ),
    );
  }
}
