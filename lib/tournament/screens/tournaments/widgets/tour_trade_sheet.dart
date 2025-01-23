
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tournament/provider/search.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tournament/screens/myTrades/all_index.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

tournamentSheet({
  String? symbol,
  bool doPop = true,
  TradingSearchTickerRes? data,
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
      return TournamentTicker(
        symbol: symbol,
        doPop: doPop,
        data: data,
      );
    },
  );
}

class TournamentTicker extends StatefulWidget {
  final String? symbol;
  final bool doPop;
  final TradingSearchTickerRes? data;
  const TournamentTicker(
      {super.key, this.symbol, this.doPop = true,this.data});

  @override
  State<TournamentTicker> createState() => _TournamentTickerState();
}

class _TournamentTickerState extends State<TournamentTicker> {
  bool disposeSheet = true;

  @override
  void dispose() {
    if (disposeSheet) {
      Utils().showLog('Disposing tradeSheet');
      SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    }
    super.dispose();
  }

  _trade({StockType type = StockType.buy,String? symbol}) async {
    TournamentTradesProvider provider =
    context.read<TournamentTradesProvider>();
    ApiResponse res = await provider.tradeBuySell(type: type,symbol: symbol);
    if (res.status) {
      // Handle successful trade response
      SSEManager.instance.disconnectAllScreens();
      //navigatorKey.currentContext!.read<TournamentSearchProvider>().getSearchDefaults();
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
      await Navigator.push(
        navigatorKey.currentContext!,
        createRoute(AllTradesOrdersIndex()),
      );
      TournamentTradesProvider provider =
      context.read<TournamentTradesProvider>();
      provider.setSelectedStock(
        stock: provider.selectedStock,
        clearEverything: true,
      );

      /// open sheet after api call with updated response
    }
  }
  _close({
    int? id,
    String? ticker
  }) async {
    TournamentTradesProvider provider =
    navigatorKey.currentContext!.read<TournamentTradesProvider>();

    ApiResponse res = await provider.tradeCancle();
    if (res.status) {
     // navigatorKey.currentContext!.read<TournamentSearchProvider>().getSearchDefaults();
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

    @override
  Widget build(BuildContext context) {
    TournamentSearchProvider provider = context.watch<TournamentSearchProvider>();
    StockDataManagerRes? stock = provider.tappedStock;
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      // padding: const EdgeInsets.all(30),
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
                            style: styleGeorgiaBold(
                                color: ThemeColors.blackShade, fontSize: 22),
                          ),
                          Text(
                            '${widget.data?.name}',
                            style: styleGeorgiaRegular(
                                color: ThemeColors.blackShade, fontSize: 18),
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
                            //'${stock?.price?.toFormattedPrice()}',
                            style: styleGeorgiaBold(
                                color: ThemeColors.blackShade, fontSize: 22),
                          ),
                        ),
                        Visibility(
                          visible: stock?.change != null &&
                              stock?.changePercentage != null,
                          child: Text(
                            '${stock?.change?.toFormattedPrice()} (${stock?.changePercentage?.toCurrency()}%)',
                            style: styleGeorgiaRegular(
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
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Kindly select ',
                      style: styleGeorgiaBold(
                        color: ThemeColors.blackShade,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: '"Buy"',
                          style: styleGeorgiaBold(
                            color: ThemeColors.accent,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: ' or ',
                          style: styleGeorgiaBold(
                            color: ThemeColors.blackShade,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: '"Sell"',
                          style: styleGeorgiaBold(
                            color: ThemeColors.sos,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: ' to place your desired order.',
                          style: styleGeorgiaBold(
                            color: ThemeColors.blackShade,
                            fontSize: 16,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Divider(
            color: ThemeColors.greyBorder,
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
                        _trade(type: StockType.sell,symbol: widget.data?.symbol);
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
          if (widget.data?.showButton?.alreadyTraded ==
              true)
            ThemeButton(
              radius: 10,
              text: 'Close',
              margin: const EdgeInsets.fromLTRB(10, 10, 10,10),
              onPressed: (){
                _close(
                  //id: provider.myTrades?.data?[index].id,
                  ticker: widget.data?.symbol,
                );
              },
              color: ThemeColors.primary,
              textColor: ThemeColors.white,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    'Close',
                    style: styleGeorgiaBold(
                        color: ThemeColors.white),
                  ),
                  SpacerHorizontal(width: 10),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(20),
                        color: (widget
                            .data
                            ?.showButton
                            ?.orderChange ??
                            0) >=
                            0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                      ),
                      child: Text(
                        '${widget.data?.showButton?.orderChange?.toCurrency()}%',
                        style: styleGeorgiaBold(
                            color: ThemeColors.white),
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
        Color? textColor = ThemeColors.white,
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
          /// changed the hor pad 50 to 40
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
          style: stylePTSansBold(color: textColor, fontSize: 18),
        ),
      ),
    );
  }
}