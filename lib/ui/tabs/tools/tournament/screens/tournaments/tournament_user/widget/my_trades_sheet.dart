import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/trades.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


myTradeSheet({
  String? symbol,
  RecentTradeRes? data,
  int? fromTO,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: navigatorKey.currentContext!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return TradeTicker(
        symbol: symbol,
        data: data,
        fromTO:fromTO
      );
    },
  );
}

class TradeTicker extends StatefulWidget {
  final String? symbol;
  final RecentTradeRes? data;
  final int? fromTO;
  const TradeTicker({super.key, this.symbol,this.data,this.fromTO});

  @override
  State<TradeTicker> createState() => _TradeTickerState();
}

class _TradeTickerState extends State<TradeTicker> {

  @override
  void dispose() {
    super.dispose();
  }

  _close({
    int? id,
    String? ticker,
    num? tournamentBattleId,
  }) async {
    TournamentTradesProvider provider = navigatorKey.currentContext!.read<TournamentTradesProvider>();
    ApiResponse res = await provider.tradeCancle(ticker: ticker,tradeId: id,tournamentBattleId: tournamentBattleId,callTickerDetail: false);
    if (res.status) {
      if(widget.fromTO==1){
        TournamentProvider provider = navigatorKey.currentContext!.read<TournamentProvider>();
        provider.getUserDetail(userID: provider.userData?.userStats?.userId??"");
      }
      else if (widget.fromTO==2){
        context.read<TournamentProvider>().tradeWithDateAll(loadMore: false,selectedBattleID: "$tournamentBattleId");
      }
      else{
        SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
        context.read<TournamentTradesProvider>().getTradesList(refresh: true);
      }
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 224, 225, 227),
                          shape: BoxShape.circle,
                        ),
                        width: 60,
                        height: 60,
                        child:
                        CachedNetworkImagesWidget(widget.data?.image ?? ""),
                      ),
                    ),
                    const SpacerHorizontal(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.data?.symbol}',
                            style: styleBaseBold(
                                color: ThemeColors.black, fontSize: 22),
                          ),
                          Text(
                            '${widget.data?.name}',
                            style: styleBaseRegular(
                                color: ThemeColors.black, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: widget.data?.currentPrice != null,
                          child: Text(
                            '${widget.data?.currentPrice?.toFormattedPrice()}',
                            style: styleBaseBold(
                                fontSize: 14,
                                color: (widget.data?.currentPrice ?? 0) > 0
                                    ? ThemeColors.success120
                                    : (widget.data?.currentPrice ?? 0) == 0
                                    ? ThemeColors.white
                                    : ThemeColors.error120
                            ),
                          ),
                        ),
                        Visibility(
                          visible:widget.data?.performance != null,
                          child: Text(
                            '${widget.data?.performance?.toCurrency()}%',
                            style: styleBaseRegular(
                              color:(widget.data?.performance ?? 0) > 0
                                  ? ThemeColors.success120:
                              (widget.data?.performance ?? 0) == 0
                                  ? ThemeColors.black
                                  : ThemeColors.error120,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SpacerVertical(height: 20),
              ],
            ),
          ),
          Divider(
            color: ThemeColors.greyBorder,
            height: 20,
          ),
            BaseButton(
              radius: 10,
              text: 'Close',
              margin: const EdgeInsets.fromLTRB(10, 10, 10,10),
              onPressed: (){
                _close(
                  id:  widget.data?.id?.toInt(),
                  ticker: widget.data?.symbol,
                  tournamentBattleId:  widget.data?.tournamentBattleId
                );
              },
             /// color: ThemeColors.primary,
             // textColor: ThemeColors.white,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    'Close',
                    style: styleBaseBold(color: ThemeColors.white),
                  ),
                  SpacerHorizontal(width: 10),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(20),
                        color: (widget.data?.performance ?? 0) > 0
                            ? ThemeColors.success120:
                          (widget.data?.performance ?? 0) == 0
                            ? ThemeColors.white
                            : ThemeColors.error120,
                      ),
                      child: Text(
                        '${widget.data?.performance?.toCurrency()}%',
                        style: styleBaseBold(color: ThemeColors.black
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

}