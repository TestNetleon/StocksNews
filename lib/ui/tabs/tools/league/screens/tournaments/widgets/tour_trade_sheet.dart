import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/myTrades/all_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

tournamentSheet({
  String? symbol,
  bool doPop = true,
  BaseTickerRes? data,
}) {
  BaseBottomSheet().bottomSheet(
    child: TournamentTicker(
      symbol: symbol,
      doPop: doPop,
      data: data,
    ),
  );
}

class TournamentTicker extends StatefulWidget {
  final String? symbol;
  final bool doPop;
  final BaseTickerRes? data;
  const TournamentTicker(
      {super.key, this.symbol, this.doPop = true, this.data});

  @override
  State<TournamentTicker> createState() => _TournamentTickerState();
}

class _TournamentTickerState extends State<TournamentTicker> {
  bool disposeSheet = true;

  @override
  void dispose() {
    if (disposeSheet) {
      Utils().showLog('Disposing tradeSheet');
      SSEManager.instance.disconnectScreen(SimulatorEnum.tradeSheet);
    }
    super.dispose();
  }

  _trade({StockType type = StockType.buy, String? symbol}) async {
    TradesManger manger = context.read<TradesManger>();
    ApiResponse res = await manger.tradeBuySell(type: type, symbol: symbol);
    if (res.status) {
      SSEManager.instance.disconnectScreen(SimulatorEnum.tradeSheet);
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
      // await Navigator.pushNamed(navigatorKey.currentContext!, AllTradesIndex.path);
      await Navigator.push(navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => AllTradesIndex()));
      manger.setSelectedStock(
        stock: manger.selectedStock,
        clearEverything: true,
      );
    }
  }

  _close({int? id, String? ticker}) async {
    TradesManger manger = context.read<TradesManger>();
    ApiResponse res = await manger.tradeCancel(ticker: ticker, tradeId: id);
    if (res.status) {
      SSEManager.instance.disconnectScreen(SimulatorEnum.tradeSheet);
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  @override
  Widget build(BuildContext context) {
    LeagueSearchManager searchManager = context.watch<LeagueSearchManager>();
    StockDataManagerRes? stock = searchManager.tappedStock;
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThemeColors.neutral5,
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
                          style: styleBaseBold(fontSize: 20),
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
                        visible: stock?.price != null,
                        child: Text(
                          '${stock?.price?.toFormattedPrice()}',
                          style: styleBaseBold(
                              fontSize: 16,
                              color: (stock?.price ?? 0) > 0
                                  ? ThemeColors.accent
                                  : (stock?.price ?? 0) == 0
                                      ? ThemeColors.black
                                      : ThemeColors.sos),
                        ),
                      ),
                      Visibility(
                        visible: stock?.change != null &&
                            stock?.changePercentage != null,
                        child: Text(
                          '${stock?.change?.toFormattedPrice()} (${stock?.changePercentage?.toCurrency()}%)',
                          style: styleBaseBold(
                            color: (stock?.change ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SpacerVertical(height: 20),
              Visibility(
                visible: widget.data?.showButton?.alreadyTraded == false,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Kindly select ',
                      style: styleBaseBold(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: '"Buy"',
                          style: styleBaseBold(
                            color: ThemeColors.accent,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: ' or ',
                          style: styleBaseBold(
                            color: ThemeColors.black,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: '"Sell"',
                          style: styleBaseBold(
                            color: ThemeColors.sos,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: ' to place your desired order.',
                          style: styleBaseBold(
                            fontSize: 16,
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          BaseListDivider(
            height: 20,
          ),
          if (widget.data?.showButton?.alreadyTraded == false)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      width: double.infinity,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      child: _card(
                        symbol: widget.symbol,
                        color: ThemeColors.sos,
                        "Sell Order",
                        onTap: () {
                          _trade(
                              type: StockType.sell,
                              symbol: widget.data?.symbol);
                        },
                      ),
                    ),
                  ),
                  const SpacerHorizontal(
                    width: 10,
                  ),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: double.infinity,
                      curve: Curves.easeIn,
                      child: _card(
                        symbol: widget.symbol,
                        color: ThemeColors.accent,
                        "Buy Order",
                        onTap: () {
                          _trade(symbol: widget.data?.symbol);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.data?.showButton?.alreadyTraded == true)
            BaseButton(
              radius: 10,
              text: 'Close',
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              onPressed: () {
                _close(
                  id: widget.data?.showButton?.tradeId?.toInt(),
                  ticker: widget.data?.symbol,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Close',
                    style: styleBaseBold(),
                  ),
                  SpacerHorizontal(width: 10),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (widget.data?.showButton?.orderChange ?? 0) > 0
                            ? ThemeColors.accent
                            : (widget.data?.showButton?.orderChange ?? 0) == 0
                                ? ThemeColors.white
                                : ThemeColors.sos,
                      ),
                      child: Text(
                        '${widget.data?.showButton?.orderChange?.toCurrency()}%',
                        style: styleBaseBold(),
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

  Widget _card(
    text, {
    IconData? icon,
    Color? color = const Color.fromARGB(255, 194, 216, 51),
    Color? textColor,
    EdgeInsetsGeometry? padding,
    required void Function() onTap,
    String? symbol,
  }) {
    return GestureDetector(
      onTap: () {
        if (symbol == null) Navigator.pop(navigatorKey.currentContext!);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Text(
          "$text",
          textAlign: TextAlign.center,
          style: styleBaseBold(
              color: textColor ?? ThemeColors.white, fontSize: 18),
        ),
      ),
    );
  }
}
