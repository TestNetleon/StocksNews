import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_top.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';

class SdCharts extends StatefulWidget {
  final String? symbol;
  const SdCharts({super.key, this.symbol});

  @override
  State<SdCharts> createState() => _SdChartsState();
}

class _SdChartsState extends State<SdCharts> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.chartRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context.read<StockDetailProviderNew>().getChartData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      hasData: !provider.isLoadingChart && provider.chartRes != null,
      isLoading: provider.isLoadingChart,
      showPreparingText: true,
      error: provider.errorChart,
      isFull: true,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async => _callApi(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              children: [
                const SdCommonHeading(),
                const Divider(
                  color: ThemeColors.white,
                  thickness: 2,
                  height: 20,
                ),
                CustomGridView(
                  length: provider.chartRes?.top?.length ?? 0,
                  paddingVerticle: 8,
                  getChild: (index) {
                    SdTopRes? top = provider.chartRes?.top?[index];
                    return SdTopCard(top: top);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
