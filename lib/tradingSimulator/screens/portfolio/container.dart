import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_portfolio_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/portfolio/item.dart';

import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TsPortfolioContainer extends StatefulWidget {
  const TsPortfolioContainer({super.key});

  @override
  State<TsPortfolioContainer> createState() => _TsPortfolioContainerState();
}

class _TsPortfolioContainerState extends State<TsPortfolioContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  void _getData() {
    // TsPortfolioProvider provider = context.read<TsPortfolioProvider>();
    // provider.getData();
  }

  @override
  Widget build(BuildContext context) {
    TsPortfolioProvider provider = context.watch<TsPortfolioProvider>();
    return BaseUiContainer(
      hasData: provider.data != null && !provider.isLoading,
      isLoading: provider.isLoading,
      error: provider.error,
      errorDispCommon: false,
      onRefresh: _getData,
      showPreparingText: true,
      child:
          // provider.data==null
          //   ? const SummaryErrorWidget(title: "No open orders")
          //   :
          ListView.separated(
        itemBuilder: (context, index) {
          TsPortfolioRes item = provider.data![index];
          return TsPortfolioListItem(
            item: item,
            onTap: () {
              // tradeSheet(symbol: item.symbol, doPop: false);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerVertical(height: 12);
        },
        itemCount: provider.data?.length ?? 0,
      ),
    );
  }
}
