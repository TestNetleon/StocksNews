import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/button_outline.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/all_trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/allTrades/trade_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';


class LeagueTrades extends StatefulWidget {
  final String? typeOfTrade;
  const LeagueTrades({super.key, this.typeOfTrade});

  @override
  State<LeagueTrades> createState() =>
      _LeagueTradesState();
}

class _LeagueTradesState extends State<LeagueTrades> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TradesManger>()
          .getTradesList(refresh: true, typeOfTrade: widget.typeOfTrade);
    });
  }
  _close({
    cancelAll = false,
    int? id,
    String? ticker,
    num? tournamentBattleId,
  }) async {
    TradesManger tradesManger = context.read<TradesManger>();

    ApiResponse response = await tradesManger.tradeCancel(
      cancelAll: cancelAll,
      tradeId: id,
      ticker: ticker,
      callTickerDetail: false,
      tournamentBattleId: tournamentBattleId,
    );
    if (response.status) {
      SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
      tradesManger.getTradesList(refresh: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
  }

  @override
  Widget build(BuildContext context) {
    TradesManger tradesManger = context.watch<TradesManger>();
    AllTradesRes? myTrades= tradesManger.myTrades;
    num? sumOfAll = myTrades?.data
        ?.map((trade) => trade.orderChange)
        .fold(0, (prev, change) => (prev ?? 0) + (change ?? 0));
    return BaseLoaderContainer(
      hasData: myTrades != null,
      isLoading: tradesManger.isLoadingTrades && myTrades == null,
      error: tradesManger.errorTrades,
      showPreparingText: true,
      onRefresh: () => tradesManger.getTradesList(refresh: true),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 10.0,
                runSpacing: 10.0,
                children: List.generate(
                  myTrades?.overview?.length ?? 0,
                  (index) {
                    return GestureDetector(
                      onTap: () => tradesManger.setSelectedOverview(
                        myTrades?.overview?[index],
                        showProgress: true,
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: Pad.pad16, vertical:Pad.pad8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: tradesManger.selectedOverview?.key ==
                                myTrades?.overview?[index].key
                                ? ThemeColors.navigationBar:null,
                            border:Border.all(
                                color: tradesManger.selectedOverview?.key ==
                                myTrades?.overview?[index].key? Colors.transparent:ThemeColors.neutral10)
                        ),
                        child: Text(
                          '${myTrades?.overview?[index].key} ${myTrades?.overview?[index].value}',
                          style:styleBaseRegular(color:  tradesManger.selectedOverview?.key ==
                              myTrades?.overview?[index].key
                              ?Colors.white:null,fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BaseLoaderContainer(
              hasData: myTrades != null &&
                  (myTrades.data?.isNotEmpty ?? false),
              isLoading: tradesManger.isLoadingTrades && myTrades == null,
              error: tradesManger.errorTrades,
              onRefresh: () => tradesManger.getTradesList(refresh: true),
              child: CommonRefreshIndicator(
                onRefresh: () async {
                  tradesManger.getTradesList();
                },
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return TournamentTradeItem(
                      data: myTrades?.data?[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return BaseListDivider(height:Pad.pad24);
                  },
                  itemCount: myTrades?.data?.length ?? 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad10),
            child: Row(
              children: [
                Visibility(
                  child: Expanded(
                    child: BaseButton(
                      radius: 8,
                      text: 'Place New Order',
                      onPressed: () {
                        tradesManger.redirectToTrade();
                      },

                      textSize: 16,
                    ),
                  ),
                ),
                if (myTrades?.overview?[1].value != 0)
                  Visibility(
                      visible: tradesManger.selectedOverview?.key != "Closed",
                      child: const SpacerHorizontal(width: 10)),
                if (myTrades?.overview?[1].value != 0)
                  Visibility(
                    visible: tradesManger.selectedOverview?.key != "Closed",
                    child: Expanded(
                      child: BaseButtonOutline(
                        borderColor: ThemeColors.neutral20,
                        radius: 8,
                        onPressed: () => _close(cancelAll: true),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Close All',
                              style: styleBaseBold(color: ThemeColors.neutral40),
                            ),
                            const SpacerHorizontal(width: 5),
                            Visibility(
                              visible: sumOfAll != null,
                              child: Flexible(
                                child: Text(
                                  '${sumOfAll?.toCurrency()}%',
                                  style: styleBaseBold(
                                      color: (sumOfAll ?? 0) > 0
                                          ? ThemeColors.accent
                                          : (sumOfAll ?? 0) == 0
                                              ? ThemeColors.black
                                              : ThemeColors.sos),
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
        ],
      ),
    );
  }
}
