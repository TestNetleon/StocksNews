import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trading_search_provider.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'item.dart';

class SdTradeDefaultSearch extends StatelessWidget {
  final bool buy;

  const SdTradeDefaultSearch({super.key, required this.buy});

  @override
  Widget build(BuildContext context) {
    TradingSearchProvider provider = context.watch<TradingSearchProvider>();

    return CommonRefreshIndicator(
      onRefresh: () =>
          context.read<TradingSearchProvider>().getSearchDefaults(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SpacerVertical(),
            ListView.separated(
              itemCount: provider.data?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                TradingSearchTickerRes data = provider.data![index];
                return SdTradeDefaultItem(data: data, buy: buy);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SpacerVertical(height: 12);
              },
            ),
          ],
        ),
      ),
    );
  }
}
