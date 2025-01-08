import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import 'trade_item.dart';

class TournamentAllTradeIndex extends StatefulWidget {
  const TournamentAllTradeIndex({super.key});

  @override
  State<TournamentAllTradeIndex> createState() =>
      _TournamentAllTradeIndexState();
}

class _TournamentAllTradeIndexState extends State<TournamentAllTradeIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TournamentTradesProvider>()
          .getTradesOverview(resetIndex: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    TournamentTradesProvider provider =
        context.watch<TournamentTradesProvider>();
    TournamentMyTradesHolder? holder =
        provider.myTrades?[provider.selectedOverview?.key];

    return BaseUiContainer(
      hasData: provider.tradesOverview != null &&
          provider.tradesOverview?.isNotEmpty == true &&
          !provider.isLoadingOverview,
      isLoading: provider.isLoadingOverview,
      error: provider.errorOverview,
      showPreparingText: true,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10.0,
              runSpacing: 10.0,
              children: List.generate(
                provider.tradesOverview?.length ?? 0,
                (index) {
                  return GestureDetector(
                    onTap: () => provider
                        .setSelectedOverview(provider.tradesOverview?[index]),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ThemeColors.greyBorder.withOpacity(0.5),
                          border: provider.selectedOverview ==
                                  provider.tradesOverview?[index]
                              ? Border.all(color: ThemeColors.white)
                              : null),
                      child: Text(
                        '${provider.tradesOverview?[index].key} ${provider.tradesOverview?[index].value}',
                        style: styleGeorgiaBold(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: CommonRefreshIndicator(
              onRefresh: () async {
                provider.getTradesList();
              },
              child: BaseUiContainer(
                hasData:
                    holder?.data != null && holder?.data?.isNotEmpty == true,
                isLoading: holder?.loading == true,
                error: holder?.error,
                showPreparingText: true,
                onRefresh: provider.getTradesList,
                child: ListView.separated(
                  padding: EdgeInsets.only(top: 10),
                  itemBuilder: (context, index) {
                    return TournamentTradeItem(
                      data: holder?.data?[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SpacerVertical(height: 10);
                  },
                  itemCount: holder?.data?.length ?? 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
