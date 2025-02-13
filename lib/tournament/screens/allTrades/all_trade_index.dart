import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/theme_button.dart';
import 'slidable.dart';
import 'trade_item.dart';

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
    cancleAll = false,
    int? id,
    String? ticker,
    num? tournamentBattleId,
  }) async {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    ApiResponse response = await provider.tradeCancle(
      cancleAll: cancleAll,
      tradeId: id,
      ticker: ticker,
      callTickerDetail: false,
      tournamentBattleId: tournamentBattleId,
    );
    if (response.status) {
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
    return BaseUiContainer(
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
                          color: ThemeColors.greyBorder.withOpacity(0.5),
                          border: provider.selectedOverview?.key ==
                                  provider.myTrades?.overview?[index].key
                              ? Border.all(color: ThemeColors.white)
                              : null),
                      child: Text(
                        '${provider.myTrades?.overview?[index].key} ${provider.myTrades?.overview?[index].value}',
                        style: styleGeorgiaBold(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: BaseUiContainer(
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
                  padding: EdgeInsets.only(top: 10),
                  itemBuilder: (context, index) {
                    return provider.myTrades?.data?[index].status == 0
                        ? TournamentCloseSlidableMenu(
                            close: () => _close(
                              id: provider.myTrades?.data?[index].id,
                              ticker: provider.myTrades?.data?[index].symbol,
                              tournamentBattleId: provider.myTrades?.data?[index].tournamentBattleId,
                            ),
                            index: index,
                            child: TournamentTradeItem(
                              data: provider.myTrades?.data?[index],
                            ),
                          )
                        : TournamentTradeItem(
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
          if(provider.selectedOverview?.value == 0)
          Visibility(
            visible: (provider.myTrades!= null && (provider.myTrades?.data?.isNotEmpty ?? false)),
            child: ThemeButton(
              color: Colors.white,
              radius: 10,
              onPressed: () {
                provider.redirectToTrade();
              },
              textColor: Colors.black,
              text: 'Place New Order',
            ),
          ),

          if(provider.selectedOverview?.key != "All")
          Visibility(
            visible: provider.myTrades?.overview?[1].value != 0,
            child: Row(
              children: [
                Expanded(
                  child: ThemeButton(
                    radius: 10,
                    text: 'Place New Trade',
                    onPressed: () {
                      provider.redirectToTrade();
                    },
                    color: ThemeColors.accent,
                    textColor: Colors.white,
                    textSize: 16,
                  ),
                ),
                Visibility(visible: provider.selectedOverview?.key != "Closed",child: const SpacerHorizontal(width: 10)),
                Visibility(
                  visible: provider.selectedOverview?.key != "Closed",
                  child: Expanded(
                    child: ThemeButton(
                      color: Colors.white,
                      radius: 10,
                      onPressed: () => _close(cancleAll: true),
                      textColor: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Close All',
                            style: styleGeorgiaBold(color: Colors.black),
                          ),
                          const SpacerHorizontal(width: 5),
                          Visibility(
                            visible: sumOfAll != null,
                            child: Flexible(
                              child: Text(
                                '${sumOfAll?.toCurrency()}%',
                                style: styleGeorgiaBold(
                                    color:
                                    (sumOfAll ?? 0) > 0
                                        ? ThemeColors.accent
                                        :
                                    (sumOfAll ?? 0) == 0?
                                    ThemeColors.primary:
                                    ThemeColors.sos
                                ),
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
          ),
          SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
