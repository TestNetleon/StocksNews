import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/TradingWithTypes/widgets/buy_order_item.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trading_search_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/searchTradingTicker/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class OpenOrderScreen extends StatefulWidget {
  final String? symbol;
  final dynamic qty;
  final TradingSearchTickerRes? data;
  final int? tickerID;
  final num? portfolioTradeType;
  const OpenOrderScreen({
    super.key,
    this.symbol,
    this.data,
    this.qty,
    this.tickerID,
    this.portfolioTradeType,
  });

  @override
  State<OpenOrderScreen> createState() => _OpenOrderScreenState();
}

class _OpenOrderScreenState extends State<OpenOrderScreen> {
  bool disposeSheet = true;

  @override
  void initState() {
    super.initState();
  }

  Future _onTap({String? symbol, StockType? selectedStock}) async {
    disposeSheet = false;
    setState(() {});
    try {
      TradingSearchProvider provider = navigatorKey.currentContext!.read<TradingSearchProvider>();
      if (symbol != null && symbol != '') {
        provider.stockHolding(symbol, selectedStock: selectedStock);
      }
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    if (disposeSheet) {
      Utils().showLog('Disposing tradeSheet');
      SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    }
    super.dispose();
  }

  String? subtitleWithSymbol(String? text, String? symbol) {
    if (text == null && text == "") return "";
    return text?.replaceFirst("<symbol>", "$symbol");
  }

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    TsPortfolioProvider tsProvider = context.watch<TsPortfolioProvider>();
    StockDataManagerRes? stock = provider.tappedStock;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeColors.greyBorder,
                    shape: BoxShape.circle,
                  ),
                  width: 50,
                  height: 50,
                  child: CachedNetworkImagesWidget(widget.data?.image ?? ""),
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
                          color: ThemeColors.blackShade, fontSize: 18),
                    ),
                    Text(
                      '${widget.data?.name}',
                      style: styleGeorgiaRegular(
                          color: ThemeColors.blackShade, fontSize: 16),
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
          SpacerVertical(height: 10),
          Divider(
            color: ThemeColors.greyBorder,
            height: 20,
          ),
          Visibility(
            visible:widget.portfolioTradeType!=3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacerVertical(height: 5),
                Text(
                  "Actions",
                  style: stylePTSansBold(
                    fontSize: 18,
                    color: ThemeColors.blackShade,
                  ),
                ),
                SpacerVertical(height: 5),
                Visibility(
                  visible: widget.portfolioTradeType==1,
                  child: BuyOrderItem(
                    title: "Buy more Stocks",
                    subtitle: subtitleWithSymbol(
                      tsProvider.userData?.ordersSubTitle?.buyOrder,
                      widget.symbol,
                    ),
                    onTap: () {
                      var selectedStock = StockType.buy;
                      if (widget.symbol != null) {
                        _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                      } else {
                        Navigator.push(
                          context,
                          createRoute(
                              SearchTradingTicker(selectedStock: selectedStock)),
                        );
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: widget.portfolioTradeType==1,
                  child: BuyOrderItem(
                    title: "Sell Stocks",
                    subtitle: subtitleWithSymbol(
                      tsProvider.userData?.ordersSubTitle?.sellOrder,
                      widget.symbol,
                    ),
                    onTap: () {
                      var selectedStock = StockType.sell;
                      if (widget.symbol != null) {
                        _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                      } else {
                        Navigator.push(
                          context,
                          createRoute(
                              SearchTradingTicker(selectedStock: selectedStock)),
                        );
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: widget.portfolioTradeType==2,
                  child: BuyOrderItem(
                    title: "Increase Short Order",
                    subtitle: subtitleWithSymbol(
                      tsProvider.userData?.ordersSubTitle?.shortOrder,
                      widget.symbol,
                    ),
                    onTap: () {
                      var selectedStock = StockType.short;
                      if (widget.symbol != null) {
                        navigatorKey.currentContext!
                            .read<TradingSearchProvider>()
                            .shortRedirection(widget.symbol ?? "");
                      } else {
                        Navigator.push(
                          context,
                          createRoute(
                              SearchTradingTicker(selectedStock: selectedStock)),
                        );
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: widget.portfolioTradeType==2,
                  child: BuyOrderItem(
                    title: "Buy to Cover Order",
                    subtitle: subtitleWithSymbol(
                      tsProvider.userData?.ordersSubTitle?.buyToCoverOrder,
                      widget.symbol,
                    ),
                    onTap: () {
                      var selectedStock = StockType.btc;
                      if (widget.symbol != null) {
                        _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                      } else {
                        Navigator.push(
                          context,
                          createRoute(
                            SearchTradingTicker(selectedStock: selectedStock),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.portfolioTradeType!=3)
              Visibility(
                visible: tsProvider.userData?.userConditionalOrderPermission?.bracketOrder == true || kDebugMode,
                child: BuyOrderItem(
                  title: "Stop Loss and Target",
                  subtitle: subtitleWithSymbol(
                    tsProvider.userData?.ordersSubTitle?.bracketOrder,
                    widget.symbol,
                  ),
                  onTap: () {
                    var conditionalType = ConditionType.bracketOrder;
                    if (widget.symbol != null) {
                      navigatorKey.currentContext!
                          .read<TradingSearchProvider>()
                          .conditionalRedirection(widget.symbol ?? "",
                          tickerID: widget.tickerID, qty: widget.qty,conditionalType: conditionalType);
                    } else {
                      Navigator.push(
                        context,
                        createRoute(SearchTradingTicker()),
                      );
                    }
                  },
                ),
              ),
              Visibility(
                visible:widget.portfolioTradeType==3,
                child: ThemeButton(
                  text: "SQUARE OFF",
                  color: ThemeColors.sos,
                  onPressed: () {
                    popUpAlert(
                      cancel: true,
                      title: "Square Off Order",
                      message: "Are you sure you want to square off this order?",
                      okText: "Square Off",
                      icon: Images.alertPopGIF,
                      onTap: () async {
                        Navigator.pop(navigatorKey.currentContext!);
                        Navigator.pop(navigatorKey.currentContext!);
                        final result = await context
                            .read<TsOpenListProvider>()
                            .squareOffRequest(widget.tickerID?.toString());
                        if (result == true) {
                          Navigator.pushReplacement(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) => const TsDashboard(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}
