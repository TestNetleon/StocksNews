import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_user_res.dart';
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
  UserOrdersCheck? _userOrdersCheck;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getForUser();
    });

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
                selectedStock: selectedStock
            ),
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 10, top: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ThemeColors.black),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: ThemeColors.white, size: 18)),
            ),
          ],
        );
      },
    ).whenComplete(getForUser);
  }

  Future _onTapConditions({ConditionType? cType}) async {
    try {
      TickerSearchManager manager = context.read<TickerSearchManager>();
      if(cType==ConditionType.recurringOrder){
        context.read<PortfolioManager>().getHolidays();
        manager.stockHoldingOfRecurringCondition(widget.symbol ?? "");
      }
      else{
        manager.conditionalRedirection(
            widget.symbol ?? "",
            tickerID: widget.tickerID,
            qty: widget.qty,
            conditionalType: cType
        );
      }


    } catch (e) {
      //
    }
  }

  Future getForUser() async {
    _userOrdersCheck = await Preference.getUserCheck();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TradeManager manager = context.watch<TradeManager>();
    PortfolioManager portfolioManager = context.watch<PortfolioManager>();
    StockDataManagerRes? stock = manager.tappedStock;
    TsUserDataRes? userDataRes = portfolioManager.userData?.userDataRes;
    OrderIcons? orderIcons = portfolioManager.userData?.userDataRes?.icons;
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
            icon: orderIcons?.buyIcon??"",
            subtitle: subtitleWithSymbol(userDataRes?.ordersSubTitle?.buyOrder,
              widget.symbol,
            ),
            onTap: () {
              var selectedStock = StockType.buy;
              if(_userOrdersCheck?.buyOrder==true){
                _onTap(symbol: widget.symbol, selectedStock: selectedStock);
              }else{
                openInfoSheet(selectedStock: selectedStock);
              }


            },
          ),
          BaseListDivider(),
          BuyOrderItem(
            icon: orderIcons?.sellOrderIcon??"",
            title: "Sell Order",
            subtitle: subtitleWithSymbol(userDataRes?.ordersSubTitle?.sellOrder,
              widget.symbol,
            ),
            onTap: () {
              var selectedStock = StockType.sell;
              if(_userOrdersCheck?.sellOrder==true){
                _onTap(symbol: widget.symbol, selectedStock: selectedStock);
              }else{
                openInfoSheet(selectedStock: selectedStock);
              }

            },
          ),
          BaseListDivider(),
          BuyOrderItem(
            icon: orderIcons?.shortOrderIcon??"",
            title: "Short Order",
            subtitle: subtitleWithSymbol(
              userDataRes?.ordersSubTitle?.shortOrder,
              widget.symbol,
            ),
            onTap: () {
              var selectedStock = StockType.short;
              if(_userOrdersCheck?.shortOrder==true){
                navigatorKey.currentContext!
                    .read<TickerSearchManager>()
                    .shortRedirection(widget.symbol ?? "");
              }else{
                openInfoSheet(selectedStock: selectedStock);
              }
            },
          ),
          BaseListDivider(),
          BuyOrderItem(
            icon: orderIcons?.buyToCoverIcon??"",
            title: "Buy to Cover Order",
            subtitle: subtitleWithSymbol(
              userDataRes?.ordersSubTitle?.buyToCoverOrder,
              widget.symbol,
            ),
            onTap: () {
              var selectedStock = StockType.btc;
              if(_userOrdersCheck?.btcOrder==true){
                _onTap(symbol: widget.symbol, selectedStock: selectedStock);
              }else{
                openInfoSheet(selectedStock: selectedStock);
              }
            },
          ),
          SpacerVertical(height: Pad.pad5),
          Visibility(
            visible: userDataRes?.userConditionalOrderPermission?.bracketOrder ==
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
            visible: userDataRes?.userConditionalOrderPermission?.bracketOrder ==
                true,
            child: BuyOrderItem(
              icon: orderIcons?.bracketOrderIcon??"",
              title: "Bracket Order",
              subtitle: subtitleWithSymbol(
                userDataRes?.ordersSubTitle?.bracketOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.bracketOrder;
                if(_userOrdersCheck?.bracketOrder==true){
                  _onTapConditions(cType: selectedType);
                }else{
                  openInfoSheet(cType: selectedType);
                }

              },
            ),
          ),
          Visibility(visible: userDataRes?.userConditionalOrderPermission?.bracketOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userDataRes?.userConditionalOrderPermission?.limitOrder ==
                true,
            child: BuyOrderItem(
              icon: orderIcons?.limitOrderIcon??"",
              title: "Limit Order",
              subtitle: subtitleWithSymbol(
                userDataRes?.ordersSubTitle?.limitOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.limitOrder;
                if(_userOrdersCheck?.limitOrder==true){
                  _onTapConditions(cType: selectedType);
                }else{
                  openInfoSheet(cType: selectedType);
                }

              },
            ),
          ),
          Visibility(visible: userDataRes?.userConditionalOrderPermission?.limitOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userDataRes?.userConditionalOrderPermission?.stopOrder ==
                true,
            child: BuyOrderItem(
              icon: orderIcons?.stopOrderIcon??"",
              title: "Stop Order",
              subtitle: subtitleWithSymbol(
                userDataRes?.ordersSubTitle?.stopOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.stopOrder;
                if(_userOrdersCheck?.stopOrder==true){
                  _onTapConditions(cType: selectedType);
                }else{
                  openInfoSheet(cType: selectedType);
                }
              },
            ),
          ),
          Visibility(visible: userDataRes?.userConditionalOrderPermission?.stopOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userDataRes?.userConditionalOrderPermission?.stopLimitOrder ==
                true,
            child: BuyOrderItem(
              icon: orderIcons?.stopLimitIcon??"",
              title: "Stop Limit Order",
              subtitle: subtitleWithSymbol(
                userDataRes?.ordersSubTitle?.stopLimitOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.stopLimitOrder;
                if(_userOrdersCheck?.stopLimitOrder==true){
                  _onTapConditions(cType: selectedType);
                }else{
                  openInfoSheet(cType: selectedType);
                }
              },
            ),
          ),
          Visibility(visible: userDataRes?.userConditionalOrderPermission?.stopLimitOrder == true,child: BaseListDivider()),

          Visibility(
            visible: userDataRes?.userConditionalOrderPermission?.trailingOrder ==
                true,
            child: BuyOrderItem(
              icon: orderIcons?.trailingOrderIcon??"",
              title: "Trailing Order",
              subtitle: subtitleWithSymbol(
                userDataRes?.ordersSubTitle?.trailingOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.trailingOrder;
                if(_userOrdersCheck?.trailingOrder==true){
                  _onTapConditions(cType: selectedType);
                }else{
                  openInfoSheet(cType: selectedType);
                }
              },
            ),
          ),
          Visibility(visible: userDataRes?.userConditionalOrderPermission?.trailingOrder == true,child: BaseListDivider()),

          Visibility(
            visible: userDataRes?.userConditionalOrderPermission?.recurringOrder ==
                true,
            child: BuyOrderItem(
              icon: orderIcons?.recurringOrderIcon??"",
              title: "Recurring Order",
              subtitle: subtitleWithSymbol(
                userDataRes?.ordersSubTitle?.recurringOrder,
                widget.symbol,
              ),
              onTap: () {

                var selectedType = ConditionType.recurringOrder;
                if(_userOrdersCheck?.recurringOrder==true){
                  _onTapConditions(cType: selectedType);

                }else{
                  openInfoSheet(cType: selectedType);
                }

              },
            ),
          ),
          Visibility(visible: userDataRes?.userConditionalOrderPermission?.recurringOrder == true,child: BaseListDivider()),

        ],
      ),
    );
  }
}
