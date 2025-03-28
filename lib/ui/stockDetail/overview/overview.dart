import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/ai_analysis.dart';
import 'package:stocks_news_new/ui/aiAnalysis/index.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../models/stockDetail/overview.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../aiAnalysis/radar.dart';
import '../../base/heading.dart';
import 'chart.dart';
import 'company.dart';
import 'morningStar/data.dart';
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
    MorningStarRes? morningStar = manager.dataOverview?.morningStar;
    // SDHistoricalChartRes? chart = manager.dataHistoricalC;
    // bool hasData = manager.dataHistoricalC != null;

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
          SDMorningStarView(data: morningStar),
          //Historical Chart
          SDHistoricalChart(),

          SDCompanyBrief(companyInfo: companyInfo),
          Column(
            children: [
              SpacerVertical(height: Pad.pad24),
              BaseHeading(
                title: aiAnalysis?.title,
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                viewMore: () {
                  AIManager aiManager = context.read<AIManager>();
                  aiManager.setFromSD(true);
                  if (manager.selectedStock == null ||
                      manager.selectedStock == '') {
                    return;
                  }
                  Navigator.pushNamed(context, AIindex.path, arguments: {
                    'symbol': manager.selectedStock,
                  });
                },
              ),
              OptionalParent(
                addParent: aiAnalysis?.lockInfo != null,
                parentBuilder: (child) {
                  return Stack(
                    children: [
                      child,
                      Blur(
                        blurColor: ThemeColors.white,
                        child: child,
                      ),
                    ],
                  );
                },
                child: AIChart(aiAnalysis: aiAnalysis),
              ),
              // Stack(
              //   children: [
              //     AIChart(aiAnalysis: aiAnalysis),
              //     if (aiAnalysis?.lockInfo != null)
              //       Positioned(
              //         top: 0,
              //         right: 0,
              //         left: 0,
              //         bottom: 0,
              //         child: Container(
              //           color: Colors.white.withValues(alpha: 0.87),
              //         ),
              //       ),
              //   ],
              // ),
            ],
          ),
          SDStocksScore(stockScore: stockScore),
        ],
      ),
    );
  }
}
