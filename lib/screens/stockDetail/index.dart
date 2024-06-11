import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/keystats/key_states.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/overview/sd_overview.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import 'widgets/dividends/dividends.dart';
import 'widgets/earnings/earnings.dart';

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
      context.read<StockDetailProviderNew>().getTabData(symbol: widget.symbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    return BaseContainer(
      // moreGradient: true,
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      bottomSafeAreaColor: ThemeColors.background.withOpacity(0.8),
      body: BaseUiContainer(
        hasData: !provider.isLoadingTab && provider.tabRes != null,
        isLoading: provider.isLoadingTab,
        error: provider.errorTab,
        showPreparingText: true,
        child: CustomTabContainerNEW(
          physics: const NeverScrollableScrollPhysics(),
          scrollable: true,
          tabs: List.generate(provider.tabRes?.tabs?.length ?? 0,
              (index) => provider.tabRes?.tabs?[index].name ?? ""),
          widgets: [
            const SdOverview(),
            const SdKeyStats(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            SdEarnings(
              symbol: widget.symbol,
            ),
            SdDividends(
              symbol: widget.symbol,
            ),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
