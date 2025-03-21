import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/allTrades/trade_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TournamentAllTradeIndex extends StatefulWidget {
  final String? typeOfTrade;
  const TournamentAllTradeIndex({super.key, this.typeOfTrade});

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
          .getTradesList(refresh: true, typeOfTrade: widget.typeOfTrade);
    });
  }

  _close({
    cancelAll = false,
    int? id,
    String? ticker,
    num? tournamentBattleId,
  }) async {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    ApiResponse response = await provider.tradeCancle(
      cancleAll: cancelAll,
      tradeId: id,
      ticker: ticker,
      callTickerDetail: false,
      tournamentBattleId: tournamentBattleId,
    );
    if (response.status) {
      SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
      context.read<TournamentTradesProvider>().getTradesList(refresh: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
  }

  @override
  Widget build(BuildContext context) {
    TournamentTradesProvider provider =
        context.watch<TournamentTradesProvider>();

    num? sumOfAll = provider.myTrades?.data
        ?.map((trade) => trade.orderChange)
        .fold(0, (prev, change) => (prev ?? 0) + (change ?? 0));
    return BaseLoaderContainer(
      hasData: provider.myTrades != null,
      isLoading: provider.isLoadingTrades && provider.myTrades == null,
      error: provider.errorTrades,
      showPreparingText: true,
      onRefresh: () => provider.getTradesList(refresh: true),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10.0,
              runSpacing: 10.0,
              children: List.generate(
                provider.myTrades?.overview?.length ?? 0,
                (index) {
                  return GestureDetector(
                    onTap: () => provider.setSelectedOverview(
                      provider.myTrades?.overview?[index],
                      showProgress: true,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ThemeColors.greyBorder.withValues(alpha:0.5),
                          border: provider.selectedOverview?.key ==
                                  provider.myTrades?.overview?[index].key
                              ? Border.all(color: ThemeColors.success120)
                              : null),
                      child: Text(
                        '${provider.myTrades?.overview?[index].key} ${provider.myTrades?.overview?[index].value}',
                        style: styleBaseBold(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: BaseLoaderContainer(
              hasData: provider.myTrades != null &&
                  (provider.myTrades?.data?.isNotEmpty ?? false),
              isLoading: provider.isLoadingTrades && provider.myTrades == null,
              error: provider.errorTrades,
              onRefresh: () => provider.getTradesList(refresh: true),
              child: CommonRefreshIndicator(
                onRefresh: () async {
                  provider.getTradesList();
                },
                child: ListView.separated(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    return TournamentTradeItem(
                      data: provider.myTrades?.data?[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SpacerVertical(height: 15);
                  },
                  itemCount: provider.myTrades?.data?.length ?? 0,
                ),
              ),
            ),
          ),

          Row(
            children: [
              Visibility(
                //visible:provider.myTrades?.data?.isEmpty ?? false,
                child: Expanded(
                  child: BaseButton(
                    radius: 10,
                    text: 'Place New Trade',
                    onPressed: () {
                      provider.redirectToTrade();
                    },

                    textSize: 16,
                  ),
                ),
              ),
              if (provider.myTrades?.overview?[1].value != 0)
                Visibility(
                    visible: provider.selectedOverview?.key != "Closed",
                    child: const SpacerHorizontal(width: 10)),
              if (provider.myTrades?.overview?[1].value != 0)
                Visibility(
                  visible: provider.selectedOverview?.key != "Closed",
                  child: Expanded(
                    child: BaseButton(
                     // color: Colors.white,
                      radius: 10,
                      onPressed: () => _close(cancelAll: true),
                     // textColor: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Close All',
                            style: styleBaseBold(),
                          ),
                          const SpacerHorizontal(width: 5),
                          Visibility(
                            visible: sumOfAll != null,
                            child: Flexible(
                              child: Text(
                                '${sumOfAll?.toCurrency()}%',
                                style: styleBaseBold(
                                    color: (sumOfAll ?? 0) > 0
                                        ? ThemeColors.success120
                                        : (sumOfAll ?? 0) == 0
                                            ? ThemeColors.black
                                            : ThemeColors.error120),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
