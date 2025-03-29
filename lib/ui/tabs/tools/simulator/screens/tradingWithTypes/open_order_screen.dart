import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_open.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_user_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/TradingWithTypes/widgets/buy_order_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class OpenOrderScreen extends StatefulWidget {
  final String? symbol;
  final dynamic qty;
  final BaseTickerRes? data;
  final int? tickerID;
  final num? portfolioTradeType;
  final Map<String, String>? allTradType;
  const OpenOrderScreen({
    super.key,
    this.symbol,
    this.data,
    this.qty,
    this.tickerID,
    this.portfolioTradeType,
    this.allTradType,
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
      TickerSearchManager manager = context.read<TickerSearchManager>();
      if (symbol != null && symbol != '') {
        manager.stockHolding(symbol, selectedStock: selectedStock);
      }
    } catch (e) {
      //
    }
  }

  Future _onTapCondition(
      {String? symbol,
      String? selectedStock,
      ConditionType? conditionalType}) async {
    disposeSheet = false;
    setState(() {});
    try {
      TickerSearchManager manager = context.read<TickerSearchManager>();
      if (symbol != null && symbol != '') {
        manager.stockHoldingOfCondition(symbol,
            selectedStock: selectedStock, conditionalType: conditionalType);
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
    TradeManager manager = context.watch<TradeManager>();
    PortfolioManager portfolioManager = context.watch<PortfolioManager>();
    StockDataManagerRes? stock = manager.tappedStock;
    TsUserDataRes? userDataRes = portfolioManager.userData?.userDataRes;
    OrderIcons? orderIcons = portfolioManager.userData?.userDataRes?.icons;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Pad.pad5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Pad.pad5),
                child: Container(
                  padding: EdgeInsets.all(3.sp),
                  color: ThemeColors.neutral5,
                  child: CachedNetworkImagesWidget(
                    widget.data?.image ?? "",
                    height: 41,
                    width: 41,
                  ),
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
                          color: ThemeColors.splashBG, fontSize: 16),
                    ),
                    Text(
                      '${widget.data?.name}',
                      style: styleBaseRegular(
                          color: ThemeColors.neutral40, fontSize: 14),
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
                          color: ThemeColors.splashBG, fontSize: 16),
                    ),
                  ),
                  Visibility(
                    visible: stock?.change != null &&
                        stock?.changePercentage != null,
                    child: Text(
                      '${stock?.change?.toFormattedPrice()} (${stock?.changePercentage?.toCurrency()}%)',
                      style: styleBaseRegular(
                        color: (stock?.change ?? 0) >= 0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SpacerVertical(height: 10),
        BaseListDivider(height: 20),
        Visibility(
          visible: widget.portfolioTradeType != 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerVertical(height: Pad.pad5),
              Text(
                "Actions",
                style: styleBaseBold(
                  fontSize: 18,
                  color: ThemeColors.black,
                ),
              ),
              SpacerVertical(height: Pad.pad5),
              Visibility(
                visible: widget.portfolioTradeType == 1,
                child: BuyOrderItem(
                  icon: orderIcons?.buyIcon??"",
                  title: "Buy More Shares",
                  subtitle: subtitleWithSymbol(
                    userDataRes?.ordersSubTitle?.buyOrder,
                    widget.symbol,
                  ),
                  onTap: () {
                    var selectedStock = StockType.buy;
                      _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                  },
                ),
              ),
              Visibility(visible: widget.portfolioTradeType == 1,child: BaseListDivider()),
              Visibility(
                visible: widget.portfolioTradeType == 1,
                child: BuyOrderItem(
                  icon: orderIcons?.sellOrderIcon??"",
                  title: "Sell Shares",
                  subtitle: subtitleWithSymbol(
                    userDataRes?.ordersSubTitle?.sellOrder,
                    widget.symbol,
                  ),
                  onTap: () {
                    var selectedStock = StockType.sell;
                      _onTap(symbol: widget.symbol, selectedStock: selectedStock);

                  },
                ),
              ),
              Visibility(visible: widget.portfolioTradeType == 1,child: BaseListDivider()),
              Visibility(
                visible: widget.portfolioTradeType == 2,
                child: BuyOrderItem(
                  icon: orderIcons?.shortOrderIcon??"",
                  title: "Increase Short Shares",
                  subtitle: subtitleWithSymbol(
                    userDataRes?.ordersSubTitle?.shortOrder,
                    widget.symbol,
                  ),
                  onTap: () {
                      context
                          .read<TickerSearchManager>()
                          .shortRedirection(widget.symbol ?? "");
                  },
                ),
              ),
              Visibility(visible: widget.portfolioTradeType == 2,child: BaseListDivider()),
              Visibility(
                visible: widget.portfolioTradeType == 2,
                child: BuyOrderItem(
                  icon: orderIcons?.buyToCoverIcon??"",
                  title: "Buy to Cover Shares",
                  subtitle: subtitleWithSymbol(
                    userDataRes?.ordersSubTitle?.buyToCoverOrder,
                    widget.symbol,
                  ),
                  onTap: () {
                    var selectedStock = StockType.btc;
                      _onTap(symbol: widget.symbol, selectedStock: selectedStock);

                  },
                ),
              ),
              Visibility(visible: widget.portfolioTradeType == 2,child: BaseListDivider()),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.portfolioTradeType == 1 || widget.portfolioTradeType == 2)
              Visibility(
                visible: userDataRes?.userConditionalOrderPermission?.bracketOrder ==
                    true,
                child: BuyOrderItem(
                  icon: orderIcons?.bracketOrderIcon??"",
                  title: "Stop Loss and Target",
                  subtitle: subtitleWithSymbol(
                    userDataRes?.ordersSubTitle?.bracketOrder,
                    widget.symbol,
                  ),
                  onTap: () {
                    var conditionalType = ConditionType.bracketOrder;
                      context
                          .read<TickerSearchManager>()
                          .conditionalRedirection(widget.symbol ?? "",
                              tickerID: widget.tickerID,
                              qty: widget.qty,
                              conditionalType: conditionalType);
                  },
                ),
              ),

            if (widget.portfolioTradeType == 1 || widget.portfolioTradeType == 2)
            Visibility(visible: userDataRes?.userConditionalOrderPermission?.bracketOrder == true,child: BaseListDivider()),

            if (widget.portfolioTradeType == 3 &&
                widget.allTradType?['order_type_original'] != "BRACKET_ORDER")
              Column(
                children: [
                  Visibility(
                    visible: widget.allTradType?['trade_type'] == "Buy",
                    child: BuyOrderItem(
                      icon: orderIcons?.buyIcon??"",
                      title: "Buy More Shares",
                      subtitle: subtitleWithSymbol(
                        userDataRes?.ordersSubTitle?.buyOrder,
                        widget.symbol,
                      ),
                      onTap: () {
                        var conditionalType = widget
                                    .allTradType?['order_type_original'] ==
                                "LIMIT_ORDER"
                            ? ConditionType.limitOrder
                            : widget.allTradType?['order_type_original'] ==
                                    "STOP_ORDER"
                                ? ConditionType.stopOrder
                                : widget.allTradType?['order_type_original'] ==
                                        "STOP_LIMIT_ORDER"
                                    ? ConditionType.stopLimitOrder
                                    : ConditionType.trailingOrder;

                        _onTapCondition(
                            symbol: widget.symbol ?? "",
                            selectedStock: "Buy",
                            conditionalType: conditionalType);
                      },
                    ),
                  ),
                  Visibility(visible: widget.allTradType?['trade_type'] == "Buy",child: BaseListDivider()),

                  Visibility(
                    visible: widget.allTradType?['trade_type'] == "Buy",
                    child: BuyOrderItem(
                      icon: orderIcons?.sellOrderIcon??"",
                      title: "Sell Shares",
                      subtitle: subtitleWithSymbol(
                        userDataRes?.ordersSubTitle?.sellOrder,
                        widget.symbol,
                      ),
                      onTap: () {
                        var conditionalType = widget
                                    .allTradType?['order_type_original'] ==
                                "LIMIT_ORDER"
                            ? ConditionType.limitOrder
                            : widget.allTradType?['order_type_original'] ==
                                    "STOP_ORDER"
                                ? ConditionType.stopOrder
                                : widget.allTradType?['order_type_original'] ==
                                        "STOP_LIMIT_ORDER"
                                    ? ConditionType.stopLimitOrder
                                    : ConditionType.trailingOrder;
                        _onTapCondition(
                            symbol: widget.symbol ?? "",
                            selectedStock: "Sell",
                            conditionalType: conditionalType);
                      },
                    ),
                  ),
                  Visibility(visible: widget.allTradType?['trade_type'] == "Buy",child: BaseListDivider()),
                  Visibility(
                    visible: widget.allTradType?['trade_type'] == "Short",
                    child: BuyOrderItem(
                      icon: orderIcons?.shortOrderIcon??"",
                      title: "Short More Shares",
                      subtitle: subtitleWithSymbol(
                        userDataRes?.ordersSubTitle?.buyOrder,
                        widget.symbol,
                      ),
                      onTap: () {
                        var conditionalType = widget
                                    .allTradType?['order_type_original'] ==
                                "LIMIT_ORDER"
                            ? ConditionType.limitOrder
                            : widget.allTradType?['order_type_original'] ==
                                    "STOP_ORDER"
                                ? ConditionType.stopOrder
                                : widget.allTradType?['order_type_original'] ==
                                        "STOP_LIMIT_ORDER"
                                    ? ConditionType.stopLimitOrder
                                    : ConditionType.trailingOrder;
                        _onTapCondition(
                            symbol: widget.symbol ?? "",
                            selectedStock: "Short",
                            conditionalType: conditionalType);
                      },
                    ),
                  ),
                  Visibility(visible: widget.allTradType?['trade_type'] == "Short",child: BaseListDivider()),
                  Visibility(
                    visible: widget.allTradType?['trade_type'] == "Short",
                    child: BuyOrderItem(
                      icon: orderIcons?.buyToCoverIcon??"",
                      title: "Buy to Cover Shares",
                      subtitle: subtitleWithSymbol(
                        userDataRes?.ordersSubTitle?.sellOrder,
                        widget.symbol,
                      ),
                      onTap: () {
                        var conditionalType = widget
                                    .allTradType?['order_type_original'] ==
                                "LIMIT_ORDER"
                            ? ConditionType.limitOrder
                            : widget.allTradType?['order_type_original'] ==
                                    "STOP_ORDER"
                                ? ConditionType.stopOrder
                                : widget.allTradType?['order_type_original'] ==
                                        "STOP_LIMIT_ORDER"
                                    ? ConditionType.stopLimitOrder
                                    : ConditionType.trailingOrder;
                        _onTapCondition(
                            symbol: widget.symbol ?? "",
                            selectedStock: "BUY_TO_COVER",
                            conditionalType: conditionalType);
                      },
                    ),
                  ),
                  Visibility(visible: widget.allTradType?['trade_type'] == "Short",child: BaseListDivider()),
                ],
              ),
            Visibility(
              visible: (widget.portfolioTradeType == 3),
              child: BuyOrderItem(
                icon: orderIcons?.bracketOrderIcon??"",
                title: "Square Off Order",
                subtitle: subtitleWithSymbol(
                    userDataRes?.ordersSubTitle?.sellOrder,
                    widget.symbol),
                onTap: () {
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
                          .read<SOpenManager>()
                          .squareOffRequest(widget.tickerID?.toString());
                      if (result == true) {
                        // Navigator.pushNamed(
                        //     navigatorKey.currentContext!, SimulatorIndex.path);
                        Navigator.pushNamed(
                            navigatorKey.currentContext!, Tabs.path,
                            arguments: {
                              'index': 2,
                            });
                      }
                    },
                  );
                },
              ),
            ),
            Visibility(visible:widget.portfolioTradeType == 3,child: BaseListDivider()),
          ],
        )
      ],
    );
  }
}
