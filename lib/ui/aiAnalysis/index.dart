import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/ui/aiAnalysis/radar.dart';
import 'package:stocks_news_new/ui/aiAnalysis/swot/index.dart';
import 'package:stocks_news_new/ui/aiAnalysis/volatility/volatility.dart';
import 'package:stocks_news_new/ui/base/base_faq.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../models/ai_analysis.dart';
import '../../models/ticker.dart';
import '../base/lock.dart';
import '../base/stock/stock_detail.dart';
import '../base/ticker_app_bar.dart';
import 'highlights/highlights.dart';
import 'our_take.dart';
import 'peer_comparision.dart';
import 'tabs/index.dart';

class AIindex extends StatefulWidget {
  final String symbol;
  static const path = 'AIindex';
  const AIindex({
    super.key,
    required this.symbol,
  });

  @override
  State<AIindex> createState() => _AIindexState();
}

class _AIindexState extends State<AIindex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    await context.read<AIManager>().getAIData(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();
    BaseTickerRes? tickerDetail = manager.data?.tickerDetail;

    AIradarChartRes? aiAnalysis = manager.data?.radarChart;
    AIourTakeRes? ourTake = manager.data?.ourTake;

    AIswotRes? swot = manager.data?.swot;
    BaseFaqRes? faqs = manager.data?.faqs;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectScreen(SimulatorEnum.aiAnalysis);
      },
      child: BaseScaffold(
        appBar: BaseTickerAppBar(
          data: tickerDetail,
          /* shareURL: () {
            openUrl(tickerDetail?.shareUrl);
          },*/
        ),
        body: Stack(
          children: [
            BaseLoaderContainer(
              hasData: manager.data != null,
              isLoading: manager.isLoading,
              error: manager.error,
              showPreparingText: true,
              onRefresh: _callAPI,
              child: BaseScroll(
                onRefresh: _callAPI,
                margin: EdgeInsets.zero,
                children: [
                  if (tickerDetail != null)
                    BaseStockDetailHeader(
                      data: tickerDetail,
                      type: SimulatorEnum.aiAnalysis,
                    ),
                  AIChart(aiAnalysis: aiAnalysis),
                  AIOurTake(ourTake: ourTake),
                  AIHighlights(),
                  AISwot(swot: swot),
                  PriceVolatility(),
                  AITabs(),
                  AIPeerComparison(),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Pad.pad16,
                      vertical: Pad.pad20,
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                        color: ThemeColors.neutral5,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      manager.data?.lastUpdateDate ?? '',
                      style: styleBaseRegular(fontSize: 12),
                    ),
                  ),
                  BaseFaq(faqs: faqs),
                ],
              ),
            ),
            BaseLockItem(manager: manager, callAPI: _callAPI),
          ],
        ),
      ),
    );
  }
}
