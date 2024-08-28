import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/overview/stock_score.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/analyst_data.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../widgets/disclaimer_widget.dart';
// import '../../../../widgets/theme_button_small.dart';
// import '../../../MsAnalysis/ms_analysis.dart';
// import '../../../prediction/radar.dart';
import '../../../../widgets/theme_button_small.dart';
import '../../../MsAnalysis/ms_analysis.dart';
import 'chart.dart';
import 'company_brief.dart';
import 'desclaimer.dart';
import 'price_tag.dart';
import 'range.dart';
import 'top_widget.dart';

class SdOverview extends StatefulWidget {
  static const String path = "OverviewDetails";
  final String? symbol;
  const SdOverview({super.key, this.symbol});

  @override
  State<SdOverview> createState() => _SdOverviewState();
}

class _SdOverviewState extends State<SdOverview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.overviewRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getOverviewGraphData(symbol: widget.symbol);
    context
        .read<StockDetailProviderNew>()
        .getOverviewData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingOverview && provider.overviewRes != null,
      isLoading: provider.isLoadingOverview,
      showPreparingText: true,
      error: provider.errorOverview,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          _callApi();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimen.padding,
              Dimen.padding,
              Dimen.padding,
              0,
            ),
            child: Column(
              children: [
                const SdTopWidgetDetail(),
                const SpacerVertical(height: 4),
                const SdTopDisclaimer(),
                ThemeButtonSmall(
                  text: "Prediction",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MsAnalysis(),
                      ),
                    );
                  },
                ),
                // ThemeButtonSmall(
                //   text: "RADAR",
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => RadarIndex(),
                //       ),
                //     );
                //   },
                // ),
                const SpacerVertical(height: 4),
                const SdTopWidgetRange(),
                const SpacerVertical(height: 12),
                Visibility(
                  visible: provider.overviewRes?.morningStart != null &&
                      homeProvider.extra?.showMorningstar == true,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Dimen.padding),
                    child: StockDetailAnalystData(symbol: widget.symbol ?? ""),
                  ),
                ),
                SdOverviewChart(symbol: widget.symbol ?? ""),
                const SpacerVertical(height: 4),
                const SdCompanyBrief(),
                const SpacerVertical(height: 4),
                const SdStockScore(),
                SdOverviewLists(
                  dataOver: provider.overviewRes?.calendar,
                  title: "Company Calendar",
                ),
                SdOverviewLists(
                  dataOver: provider.overviewRes?.priceTarget,
                  title: "Price Target and Rating",
                ),
                SdOverviewLists(
                  dataOver: provider.overviewRes?.profit,
                  title: "Profitability",
                ),
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
