import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tradingSimulator/screens/searchTradingTicker/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../utils/theme.dart';
import '../../modals/trading_search_res.dart';
import '../../providers/trading_search_provider.dart';

tradeSheet({
  String? symbol,
  bool doPop = true,
  qty,
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
      return SearchTicker(
        symbol: symbol,
        doPop: doPop,
        qty: qty,
        data: data,
      );
    },
  );
}

class SearchTicker extends StatelessWidget {
  final String? symbol;
  final bool doPop;
  final dynamic qty;
  final TradingSearchTickerRes? data;
  const SearchTicker(
      {super.key, this.symbol, this.doPop = true, this.qty, this.data});

  Future _onTap({String? symbol, bool buy = true}) async {
    try {
      TradingSearchProvider provider =
          navigatorKey.currentContext!.read<TradingSearchProvider>();
      if (symbol != null && symbol != '') {
        provider.stockHolding(symbol, buy: buy);
      }
    } catch (e) {
      //
    }

    // try {
    //   StockDetailProviderNew provider =
    //       navigatorKey.currentContext!.read<StockDetailProviderNew>();

    //   ApiResponse response = await provider.getTabData(
    //     symbol: symbol,
    //     showProgress: true,
    //     startSSE: true,
    //   );
    //   if (response.status) {
    //     // SummaryOrderNew order =
    //     // await
    //     Navigator.pushReplacement(
    //       navigatorKey.currentContext!,
    //       MaterialPageRoute(
    //         builder: (context) => TradeBuySellIndex(
    //           buy: buy,
    //           doPop: doPop,
    //           qty: qty,
    //         ),
    //       ),
    //     );
    //     // TradeProviderNew provider =
    //     //     navigatorKey.currentContext!.read<TradeProviderNew>();
    //     // buy ? provider.addOrderData(order) : provider.sellOrderData(order);
    //     // await showTsOrderSuccessSheet(order, buy);
    //   } else {}
    // } catch (e) {
    //   //
    // }
  }

  // Future _showSheet(SummaryOrderNew? order, bool buy) async {
  //   await showModalBottomSheet(
  //     useSafeArea: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(5),
  //         topRight: Radius.circular(5),
  //       ),
  //     ),
  //     backgroundColor: ThemeColors.transparent,
  //     isScrollControlled: false,
  //     context: navigatorKey.currentContext!,
  //     builder: (context) {
  //       return SuccessTradeSheet(
  //         order: order,
  //         buy: buy,
  //         close: true,
  //       );
  //     },
  //   );
  // }

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
                        child: CachedNetworkImagesWidget(data?.image ?? ""),
                      ),
                    ),
                    const SpacerHorizontal(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data?.symbol}',
                            style: styleGeorgiaBold(
                                color: ThemeColors.blackShade, fontSize: 22),
                          ),
                          Text(
                            '${data?.name}',
                            style: styleGeorgiaRegular(
                                color: ThemeColors.blackShade, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: 12),
                    Visibility(
                      visible: data?.currentPrice != null,
                      child: Text(
                        '\$${data?.currentPrice}',
                        style: styleGeorgiaBold(
                            color: ThemeColors.blackShade, fontSize: 22),
                      ),
                    ),
                  ],
                ),
                SpacerVertical(height: 20),
                // Text(
                //   'Kindly select "Buy" or "Sell" to place your desired order.',
                //   style: styleGeorgiaBold(
                //       color: ThemeColors.blackShade, fontSize: 16),
                // ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,
                    curve: Curves.easeIn,
                    child: _card(
                      symbol: symbol,
                      color: ThemeColors.accent,
                      "Buy Order",
                      onTap: () {
                        if (symbol != null) {
                          _onTap(symbol: symbol);
                        } else {
                          Navigator.push(
                            context,
                            createRoute(const SearchTradingTicker()),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SpacerHorizontal(
                  width: 10,
                ),
                Expanded(
                  child: AnimatedContainer(
                    width: double.infinity,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    child: _card(
                      symbol: symbol,
                      color: ThemeColors.sos,
                      "Sell Order",
                      onTap: () {
                        if (symbol != null) {
                          _onTap(symbol: symbol, buy: false);
                        } else {
                          Navigator.push(
                            context,
                            createRoute(const SearchTradingTicker(buy: false)),
                          );
                        }
                      },
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
          horizontal: 50,
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Container(
        //       margin: const EdgeInsets.only(right: 8),
        //       child: Icon(
        //         icon ?? Icons.travel_explore_rounded,
        //         size: 20,
        //         color: textColor,
        //       ),
        //     ),
        //     Flexible(
        //       child: Text(
        //         "$text",
        //         style: stylePTSansBold(color: textColor, fontSize: 18),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
