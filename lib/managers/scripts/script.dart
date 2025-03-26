import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class ScriptsManager extends ChangeNotifier {
  final Map<String, BaseTickerRes> _stockDataMap = {};

  /// MARK: Stream Scripts
  void runSymbolScripts({
    List<String>? symbols,
    bool reset = false,
    bool separateStream = false,
  }) {
    if (reset) clearAllStockData();
    if (symbols == null || symbols.isEmpty) return;

    MyHomeManager manager = navigatorKey.currentContext!.read<MyHomeManager>();
    if (!manager.isElitePlan || !manager.shouldStream) return;

    List<String> newSymbols =
        symbols.where((symbol) => !_stockDataMap.containsKey(symbol)).toList();

    if (newSymbols.isEmpty) {
      if (kDebugMode) {
        print('No new symbols to add. All are already streaming.');
      }
      return;
    }

    SSEManager.instance.connectMultipleStocks(
      symbols: newSymbols,
      screen: SimulatorEnum.script,
      sendPort: manager.data?.scannerPort?.port?.other?.simulator,
    );

    for (var symbol in newSymbols) {
      SSEManager.instance.addListener(
        symbol,
        (StockDataManagerRes stockData) {
          Utils().showLog(stockData.toMap());
          _updateStockData(
            symbol: symbol,
            stockData: stockData,
            separateStream: separateStream,
          );
        },
        SimulatorEnum.script,
      );
    }
  }

  void _updateStockData({
    required String symbol,
    required StockDataManagerRes stockData,
    bool separateStream = false,
  }) {
    // Ensure symbol entry exists in the map
    _stockDataMap.putIfAbsent(symbol, () => BaseTickerRes());

    _stockDataMap[symbol]?.streamType = stockData.type;

    if (separateStream) {
      if (stockData.type == 'PreMarket' || stockData.type == 'PostMarket') {
        _stockDataMap[symbol]?.priceEXT = stockData.price;
        _stockDataMap[symbol]?.changeEXT = stockData.change;
        _stockDataMap[symbol]?.changesPercentageEXT =
            stockData.changePercentage;
      } else {
        _stockDataMap[symbol]?.price = stockData.price;
        _stockDataMap[symbol]?.change = stockData.change;
        _stockDataMap[symbol]?.changesPercentage = stockData.changePercentage;
      }
    } else {
      _stockDataMap[symbol]?.price = stockData.price;
      _stockDataMap[symbol]?.change = stockData.change;
      _stockDataMap[symbol]?.changesPercentage = stockData.changePercentage;
    }

    // Debug print to verify values

    notifyListeners();
  }

  /// Retrieve stock data by symbol
  BaseTickerRes? getStockData(String symbol) {
    return _stockDataMap[symbol];
  }

  /// MARK: Clear all stocks
  void clearAllStockData() {
    _stockDataMap.clear();
    notifyListeners();
    SSEManager.instance.disconnectScreen(SimulatorEnum.script);
    if (kDebugMode) {
      print('Cleared all stock data');
    }
  }

  // @override
  // void dispose() {
  //   _stockDataMap.clear();
  //   super.dispose();
  // }
}
