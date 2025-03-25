import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


myTradeSheet({
  String? symbol,
  BaseTickerRes? data,
  int? fromTO,
}) {
  BaseBottomSheet().bottomSheet(
    child: TradeTicker(
        symbol: symbol,
        data: data,
        fromTO:fromTO
    ),
  );
}

class TradeTicker extends StatefulWidget {
  final String? symbol;
  final BaseTickerRes? data;
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
    TradesManger manger = context.read<TradesManger>();
    ApiResponse res = await manger.tradeCancel(ticker: ticker,tradeId: id,tournamentBattleId: tournamentBattleId,callTickerDetail: false);
    if (res.status) {
      if(widget.fromTO==1){
        LeagueManager manager = context.read<LeagueManager>();
        manager.getUserDetail(userID: manager.userData?.userStats?.userId??"");
      }
      else if (widget.fromTO==2){
        context.read<LeagueManager>().tradeWithDateAll(loadMore: false,selectedBattleID: "$tournamentBattleId");
      }
      else{
        SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
        manger.getTradesList(refresh: true);
      }
      Navigator.pop(context);
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
          Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 224, 225, 227),
                        shape: BoxShape.circle,
                      ),
                      width: 50,
                      height: 50,
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
                          style: styleBaseBold( fontSize: 20),
                        ),
                        Text(
                          '${widget.data?.name}',
                          style: styleBaseRegular(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SpacerHorizontal(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: widget.data?.price != null,
                        child: Text(
                          '${widget.data?.price?.toFormattedPrice()}',
                          style: styleBaseBold(
                              fontSize: 14,
                              color: (widget.data?.price ?? 0) > 0
                                  ? ThemeColors.accent
                                  : (widget.data?.price ?? 0) == 0
                                  ? ThemeColors.black
                                  : ThemeColors.sos
                          ),
                        ),
                      ),
                      Visibility(
                        visible:(widget.fromTO!=3 && widget.data?.performance != null),
                        child: Text(
                          '${widget.data?.performance?.toCurrency()}%',
                          style: styleBaseRegular(
                            color:(widget.data?.performance ?? 0) > 0
                                ? ThemeColors.accent:
                            (widget.data?.performance ?? 0) == 0
                                ? ThemeColors.black
                                : ThemeColors.sos,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Visibility(
                        visible:(widget.fromTO==3 && widget.data?.orderChange != null),
                        child: Text(
                          '${widget.data?.orderChange?.toCurrency()}%',
                          style: styleBaseRegular(
                            color:(widget.data?.orderChange ?? 0) > 0
                                ? ThemeColors.accent:
                            (widget.data?.orderChange ?? 0) == 0
                                ? ThemeColors.black
                                : ThemeColors.sos,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SpacerVertical(height: 10),
            ],
          ),
          BaseListDivider(
            height: 20,
          ),
            BaseButton(
              radius: 10,
              text: 'Close',
              margin: const EdgeInsets.fromLTRB(10, 10, 10,10),
              onPressed: (){
                _close(
                  id: int.tryParse(widget.data?.id??""),
                  ticker: widget.data?.symbol,
                  tournamentBattleId:  widget.data?.tournamentBattleId
                );
              },
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    'Close',
                    style: styleBaseBold(),
                  ),
                  SpacerHorizontal(width: 10),
                  Visibility(
                    visible:(widget.fromTO!=3),
                    child: Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (widget.data?.performance ?? 0) > 0
                              ? ThemeColors.accent:
                            (widget.data?.performance ?? 0) == 0
                              ? ThemeColors.white
                              : ThemeColors.sos,
                        ),
                        child: Text(
                          '${widget.data?.performance?.toCurrency()}%',
                          style: styleBaseBold(),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:(widget.fromTO==3),
                    child: Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (widget.data?.orderChange ?? 0) > 0
                              ? ThemeColors.accent:
                          (widget.data?.orderChange ?? 0) == 0
                              ? ThemeColors.white
                              : ThemeColors.sos,
                        ),
                        child: Text(
                          '${widget.data?.orderChange?.toCurrency()}%',
                          style: styleBaseBold(),
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