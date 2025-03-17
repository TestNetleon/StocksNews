import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/TradingWithTypes/order_info_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/TradingWithTypes/widgets/buy_order_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TradOrderScreen extends StatefulWidget {
  final String? symbol;
  final dynamic qty;
  final BaseTickerRes? data;
  final int? tickerID;
  const TradOrderScreen({
    super.key,
    this.symbol,
    this.data,
    this.qty,
    this.tickerID,
  });

  @override
  State<TradOrderScreen> createState() => _TradOrderScreenState();
}

class _TradOrderScreenState extends State<TradOrderScreen> {
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

  Future openInfoSheet({ConditionType? cType, StockType? selectedStock}) async {
    /*BaseBottomSheet().bottomSheet(
        child:Stack(
          alignment: Alignment.topRight,
          children: [
            OrderInfoSheet(
                symbol: widget.symbol,
                qty: widget.qty,
                tickerID: widget.tickerID,
                cType: cType,
                selectedStock: selectedStock),
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 10, top: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ThemeColors.primary),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: ThemeColors.white, size: 18)),
            ),
          ],
        )
    );*/
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: false,
      builder: (context) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            OrderInfoSheet(
                symbol: widget.symbol,
                qty: widget.qty,
                tickerID: widget.tickerID,
                cType: cType,
                selectedStock: selectedStock),
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 10, top: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ThemeColors.primary),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: ThemeColors.white, size: 18)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TradeManager manager = context.watch<TradeManager>();
    PortfolioManager portfolioManager = context.watch<PortfolioManager>();
    StockDataManagerRes? stock = manager.tappedStock;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Pad.pad5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                            ? ThemeColors.success120
                            : ThemeColors.error120,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpacerVertical(height: 10),
          BaseListDivider(height: 20),
          SpacerVertical(height: Pad.pad5),
          Text(
            "Regular orders",
            style: styleBaseBold(
              fontSize: 18,
              color: ThemeColors.black,
            ),
          ),
          SpacerVertical(height: Pad.pad5),
          BuyOrderItem(
            title: "Buy Order",
            subtitle: subtitleWithSymbol(
              portfolioManager.userData?.userDataRes?.ordersSubTitle?.buyOrder,
              widget.symbol,
            ),
            onTap: () {
              var selectedStock = StockType.buy;
              if (widget.symbol != null) {
                _onTap(symbol: widget.symbol, selectedStock: selectedStock);
              } else {
                // Navigator.pushNamed(context, SearchTickerIndex.path,arguments: {"stockType":selectedStock});
                /*Navigator.push(
                  context,
                  createRoute(
                      SearchTradingTicker(selectedStock: selectedStock)),
                );*/
              }
            },
          ),
          BuyOrderItem(
            title: "Sell Order",
            subtitle: subtitleWithSymbol(
              portfolioManager.userData?.userDataRes?.ordersSubTitle?.sellOrder,
              widget.symbol,
            ),
            onTap: () {
              var selectedStock = StockType.sell;
              if (widget.symbol != null) {
                _onTap(symbol: widget.symbol, selectedStock: selectedStock);
              } else {
                //  Navigator.pushNamed(context, SearchTickerIndex.path,arguments: {"stockType":selectedStock});
              }
            },
          ),
          BuyOrderItem(
            title: "Short Order",
            subtitle: subtitleWithSymbol(
              portfolioManager
                  .userData?.userDataRes?.ordersSubTitle?.shortOrder,
              widget.symbol,
            ),
            onTap: () {
              if (widget.symbol != null) {
                navigatorKey.currentContext!
                    .read<TickerSearchManager>()
                    .shortRedirection(widget.symbol ?? "");
              } else {
                // Navigator.pushNamed(context, SearchTickerIndex.path,arguments: {"stockType":selectedStock});
              }
            },
          ),
          BuyOrderItem(
            title: "Buy to Cover Order",
            subtitle: subtitleWithSymbol(
              portfolioManager
                  .userData?.userDataRes?.ordersSubTitle?.buyToCoverOrder,
              widget.symbol,
            ),
            onTap: () {
              var selectedStock = StockType.btc;
              if (widget.symbol != null) {
                _onTap(symbol: widget.symbol, selectedStock: selectedStock);
              } else {
                //Navigator.pushNamed(context, SearchTickerIndex.path,arguments: {"stockType":selectedStock});
              }
            },
          ),
          SpacerVertical(height: Pad.pad5),
          Visibility(
            visible: portfolioManager.userData?.userDataRes
                    ?.userConditionalOrderPermission?.bracketOrder ==
                true,
            child: Text(
              "Conditional orders",
              style: styleBaseBold(
                fontSize: 18,
                color: ThemeColors.black,
              ),
            ),
          ),
          Visibility(
            visible: portfolioManager.userData?.userDataRes
                    ?.userConditionalOrderPermission?.bracketOrder ==
                true,
            child: BuyOrderItem(
              title: "Bracket Order",
              subtitle: subtitleWithSymbol(
                portfolioManager
                    .userData?.userDataRes?.ordersSubTitle?.bracketOrder,
                widget.symbol,
              ),
              onTap: () {
                // var conditionalType = ConditionType.bracketOrder;
                /*if (widget.symbol != null) {
                  context.read<TickerSearchManager>().conditionalRedirection(
                      widget.symbol ?? "",
                      tickerID: widget.tickerID,
                      qty: widget.qty,
                      conditionalType: conditionalType);
                }*/
                openInfoSheet(cType: ConditionType.bracketOrder);
              },
            ),
          ),
          Visibility(
            visible: portfolioManager.userData?.userDataRes
                    ?.userConditionalOrderPermission?.limitOrder ==
                true,
            child: BuyOrderItem(
              title: "Limit Order",
              subtitle: subtitleWithSymbol(
                portfolioManager
                    .userData?.userDataRes?.ordersSubTitle?.limitOrder,
                widget.symbol,
              ),
              onTap: () {
                // var conditionalType = ConditionType.limitOrder;
                /*if (widget.symbol != null) {
                  context.read<TickerSearchManager>().conditionalRedirection(
                      widget.symbol ?? "",
                      tickerID: widget.tickerID,
                      qty: widget.qty,
                      conditionalType: conditionalType);
                }*/
                openInfoSheet(cType: ConditionType.limitOrder);
              },
            ),
          ),
          Visibility(
            visible: portfolioManager.userData?.userDataRes
                    ?.userConditionalOrderPermission?.stopOrder ==
                true,
            child: BuyOrderItem(
              title: "Stop Order",
              subtitle: subtitleWithSymbol(
                portfolioManager
                    .userData?.userDataRes?.ordersSubTitle?.stopOrder,
                widget.symbol,
              ),
              onTap: () {
                // var conditionalType = ConditionType.stopOrder;
                /* if (widget.symbol != null) {
                  context.read<TickerSearchManager>().conditionalRedirection(
                      widget.symbol ?? "",
                      tickerID: widget.tickerID,
                      qty: widget.qty,
                      conditionalType: conditionalType);
                }*/
                openInfoSheet(cType: ConditionType.stopOrder);
              },
            ),
          ),
          Visibility(
            visible: portfolioManager.userData?.userDataRes
                    ?.userConditionalOrderPermission?.stopLimitOrder ==
                true,
            child: BuyOrderItem(
              title: "Stop Limit Order",
              subtitle: subtitleWithSymbol(
                portfolioManager
                    .userData?.userDataRes?.ordersSubTitle?.stopLimitOrder,
                widget.symbol,
              ),
              onTap: () {
                // var conditionalType = ConditionType.stopLimitOrder;
                /*if (widget.symbol != null) {
                  context.read<TickerSearchManager>().conditionalRedirection(
                      widget.symbol ?? "",
                      tickerID: widget.tickerID,
                      qty: widget.qty,
                      conditionalType: conditionalType);
                }*/
                openInfoSheet(cType: ConditionType.stopLimitOrder);
              },
            ),
          ),
          Visibility(
            visible: portfolioManager.userData?.userDataRes
                    ?.userConditionalOrderPermission?.trailingOrder ==
                true,
            child: BuyOrderItem(
              title: "Trailing Order",
              subtitle: subtitleWithSymbol(
                portfolioManager
                    .userData?.userDataRes?.ordersSubTitle?.trailingOrder,
                widget.symbol,
              ),
              onTap: () {
                // var conditionalType = ConditionType.trailingOrder;
                /*if (widget.symbol != null) {
                  context.read<TickerSearchManager>().conditionalRedirection(
                      widget.symbol ?? "",
                      tickerID: widget.tickerID,
                      qty: widget.qty,
                      conditionalType: conditionalType);
                }*/
                openInfoSheet(cType: ConditionType.trailingOrder);
              },
            ),
          ),
          Visibility(
            visible: portfolioManager.userData?.userDataRes
                    ?.userConditionalOrderPermission?.recurringOrder ==
                true,
            child: BuyOrderItem(
              title: "Recurring Order",
              subtitle: subtitleWithSymbol(
                portfolioManager
                    .userData?.userDataRes?.ordersSubTitle?.recurringOrder,
                widget.symbol,
              ),
              onTap: () {
                if (widget.symbol != null) {
                  openInfoSheet(cType: ConditionType.recurringOrder);
                  /*  context
                      .read<TickerSearchManager>()
                      .stockHoldingOfRecurringCondition(widget.symbol ?? "");*/
                } else {
                  //  Navigator.pushNamed(context, SearchTickerIndex.path);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
