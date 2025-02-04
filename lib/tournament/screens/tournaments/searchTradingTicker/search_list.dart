import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/search.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'item.dart';

class TournamentDefaultSearch extends StatelessWidget {
  const TournamentDefaultSearch({super.key});

  @override
  Widget build(BuildContext context) {
    TournamentSearchProvider provider =
        context.watch<TournamentSearchProvider>();

    return CommonRefreshIndicator(
      onRefresh: () =>
          context.read<TournamentSearchProvider>().getSearchDefaults(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SpacerVertical(),
            ListView.separated(
              itemCount: provider.topSearch?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                TradingSearchTickerRes data = provider.topSearch![index];
                return TournamentDefaultItem(data: data);
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
