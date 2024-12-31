import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tradingSimulator/screens/searchTradingTicker/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../api/api_response.dart';
import '../../../../../providers/stock_detail_new.dart';
import '../../../../../utils/theme.dart';

tradeSheet({String? symbol, bool doPop = true, qty}) {
  showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return SearchTicker(symbol: symbol, doPop: doPop, qty: qty);
    },
  );
}

class SearchTicker extends StatelessWidget {
  final String? symbol;
  final bool doPop;
  final dynamic qty;

  const SearchTicker({super.key, this.symbol, this.doPop = true, this.qty});

  Future _onTap({String? symbol, bool buy = true}) async {
    try {
      StockDetailProviderNew provider =
          navigatorKey.currentContext!.read<StockDetailProviderNew>();

      ApiResponse response = await provider.getTabData(
        symbol: symbol,
        showProgress: true,
        startSSE: true,
      );
      if (response.status) {
        // SummaryOrderNew order =
        // await
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => TradeBuySellIndex(
              buy: buy,
              doPop: doPop,
              qty: qty,
            ),
          ),
        );
        // TradeProviderNew provider =
        //     navigatorKey.currentContext!.read<TradeProviderNew>();
        // buy ? provider.addOrderData(order) : provider.sellOrderData(order);
        // await showTsOrderSuccessSheet(order, buy);
      } else {}
    } catch (e) {
      //
    }
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
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: double.infinity,
            curve: Curves.easeIn,
            child: _card(
              symbol: symbol,
              color: ThemeColors.accent,
              "Place Buy Trade",
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
          const SpacerVertical(
            height: 10,
          ),
          AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            child: _card(
              symbol: symbol,
              color: ThemeColors.sos,
              "Place Sell Trade",
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
        ],
      ),
    );
  }

  Widget _card(
    text, {
    IconData? icon,
    Color? color = const Color.fromARGB(255, 194, 216, 51),
    Color? textColor = ThemeColors.background,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(
                icon ?? Icons.travel_explore_rounded,
                size: 20,
                color: textColor,
              ),
            ),
            Flexible(
              child: Text(
                "$text",
                style: stylePTSansBold(color: textColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
