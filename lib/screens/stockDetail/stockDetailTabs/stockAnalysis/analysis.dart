import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/common_heading.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import '../../../../widgets/disclaimer_widget.dart';
import 'item.dart';
import 'peers.dart';

class SdAnalysis extends StatefulWidget {
  final String? symbol;
  const SdAnalysis({super.key, this.symbol});

  @override
  State<SdAnalysis> createState() => _SdAnalysisState();
}

class _SdAnalysisState extends State<SdAnalysis> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();

      if (provider.analysis == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getAnalysisData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingAnalysis && provider.analysis != null,
      isLoading: provider.isLoadingAnalysis,
      showPreparingText: true,
      error: provider.errorAnalysis,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          _callApi();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SdCommonHeading(),
                ScreenTitle(
                  subTitle: provider.analysis?.text,
                ),
                SdAnalysisItem(
                  heading: "Overall",
                  value: provider.analysis?.overallPercent,
                ),
                SdAnalysisItem(
                  heading: "Fundamental",
                  value: provider.analysis?.fundamentalPercent,
                ),
                SdAnalysisItem(
                  heading: "Short-term Technical",
                  value: provider.analysis?.shortTermPercent,
                ),
                SdAnalysisItem(
                  heading: "Long-term Technical",
                  value: provider.analysis?.longTermPercent,
                ),
                SdAnalysisItem(
                  heading: "Analyst Ranking",
                  value: provider.analysis?.analystRankingPercent,
                ),
                SdAnalysisItem(
                  heading: "Valuation",
                  value: provider.analysis?.valuationPercent,
                ),
                const SdStockPeers(),
                if (provider.extra?.disclaimer != null)
                  DisclaimerWidget(
                    data: provider.extra!.disclaimer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
