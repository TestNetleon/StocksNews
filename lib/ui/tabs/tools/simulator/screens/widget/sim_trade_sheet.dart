import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/TradingWithTypes/open_order_screen.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/TradingWithTypes/trad_order_screen.dart';
import 'package:stocks_news_new/utils/colors.dart';


simulatorTrades({
  String? symbol,
  dynamic qty,
  BaseTickerRes? data,
  int? tickerID,
  int? fromTo,
  num? portfolioTradeType,
  Map<String, String>? allTradType,
}) {

  BaseBottomSheet().bottomSheet(
      barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
    child: fromTo==1?OpenOrderScreen(
      symbol: symbol,
      data: data,
      qty: qty,
      tickerID:tickerID,
      portfolioTradeType: portfolioTradeType,
      allTradType: allTradType,
    ):
    TradOrderScreen(
        symbol: symbol,
        data: data,
        qty: qty,
        tickerID:tickerID
    )
  );
  /*showModalBottomSheet(
    enableDrag: true,
    isDismissible: true,
    context: navigatorKey.currentContext!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    isScrollControlled: true,
    builder: (context) {
      if(fromTo==1){
        return OpenOrderScreen(
            symbol: symbol,
            data: data,
            qty: qty,
            tickerID:tickerID,
          portfolioTradeType: portfolioTradeType,
          allTradType: allTradType,
        );
      }
      else{
        return TradOrderScreen(
            symbol: symbol,
            data: data,
            qty: qty,
            tickerID:tickerID
        );
      }

    },
  );*/
}
