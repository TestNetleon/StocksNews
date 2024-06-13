import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/competitors/compititor.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/keystats/key_states.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/overview/sd_overview.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/ownership/ownership.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/secFiling/sd_sec_filing.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import 'widgets/chart/chart.dart';
import 'widgets/dividends/dividends.dart';
import 'widgets/earnings/earnings.dart';
import 'widgets/forecast/forecast.dart';
import 'widgets/stockAnalysis/analysis.dart';
import 'widgets/technicalAnalysis/technical_analysis.dart';

class StockDetail extends StatefulWidget {
  final String symbol;
  final String? inAppMsgId;
  final String? notificationId;
  static const String path = "StockDetail";

  const StockDetail({
    super.key,
    required this.symbol,
    this.inAppMsgId,
    this.notificationId,
  });

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callApi();
    });
  }

  _callApi() {
    context.read<StockDetailProviderNew>().getTabData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      bottomSafeAreaColor: ThemeColors.background.withOpacity(0.8),
      body: BaseUiContainer(
        hasData: !provider.isLoadingTab && provider.tabRes != null,
        isLoading: provider.isLoadingTab,
        error: provider.errorTab,
        showPreparingText: true,
        onRefresh: _callApi,
        child: CustomTabContainerNEW(
          physics: const NeverScrollableScrollPhysics(),
          scrollable: true,
          tabs: List.generate(provider.tabRes?.tabs?.length ?? 0,
              (index) => provider.tabRes?.tabs?[index].name ?? ""),
          widgets: [
            const SdOverview(),
            const SdKeyStats(),
            SdAnalysis(symbol: widget.symbol),
            SdTechnical(symbol: widget.symbol),
            SdForecast(symbol: widget.symbol),
            Container(),
            Container(),
            SdEarnings(symbol: widget.symbol),
            SdDividends(symbol: widget.symbol),
            Container(),
            SdCompetitor(symbol: widget.symbol),
            SdOwnership(symbol: widget.symbol),
            SdCharts(symbol: widget.symbol),
            Container(),
            SdSecFilings(symbol: widget.symbol),
            Container(),
          ],
        ),
      ),
    );
  }
}
