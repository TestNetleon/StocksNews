import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_user_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradingWithTypes/order_info_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradingWithTypes/widgets/buy_order_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ActionInNbs extends StatefulWidget {
  final String? symbol;
  final int? from;
  final BaseTickerRes? item;
  final BaseLockInfoRes? simulatorLockInfoRes;
  const ActionInNbs(
      {super.key,
      this.symbol,
      this.from,
      this.item,
      this.simulatorLockInfoRes});

  @override
  State<ActionInNbs> createState() => _ActionInNbsState();
}

class _ActionInNbsState extends State<ActionInNbs> {
  bool? isLocked = false;
  UserOrdersCheck? _userOrdersCheck;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
      getForUser();
    });
  }

  Future _getData() async {
    PortfolioManager manager = context.read<PortfolioManager>();
    manager.getDashboardData(showProgress: true);
  }

  Future _onTap({String? symbol, StockType? selectedStock}) async {
    setState(() {});
    try {
      TickerSearchManager manager =
          navigatorKey.currentContext!.read<TickerSearchManager>();
      if (symbol != null && symbol != '') {
        manager.stockHolding(symbol, selectedStock: selectedStock);
      }
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? subtitleWithSymbol(String? text, String? symbol) {
    if (text == null && text == "") return "";
    return text?.replaceFirst("<symbol>", "$symbol");
  }
  Future getForUser() async {
    _userOrdersCheck = await Preference.getUserCheck();
    setState(() {});
  }

  Future _onTapConditions({ConditionType? cType}) async {
    try {
      TickerSearchManager manager = context.read<TickerSearchManager>();
      if(cType==ConditionType.recurringOrder){
        manager.stockHoldingOfRecurringCondition(widget.symbol ?? "");
      }
      else{
        manager.conditionalRedirection(
            widget.symbol ?? "",
            conditionalType: cType
        );
      }


    }
    catch (e) {
      //
    }
  }
  Future openInfoSheet({ConditionType? cType, StockType? selectedStock}) async {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      context: navigatorKey.currentContext!,
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
                cType: cType,
                selectedStock: selectedStock),
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

  @override
  Widget build(BuildContext context) {
    PortfolioManager portfolioManager = context.watch<PortfolioManager>();
    OrdersSubTitle? ordersSubTitle =
        portfolioManager.userData?.userDataRes?.ordersSubTitle;
    BaseLockInfoRes? lockInfoRes = portfolioManager.userData?.lockInfo;
    UserConditionalOrderPermissionRes? userConditionalOrderPermissionRes =
        portfolioManager.userData?.userDataRes?.userConditionalOrderPermission;
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
                    widget.item?.image ?? "",
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
                      '${widget.item?.symbol}',
                      style: styleBaseBold(
                          color: ThemeColors.splashBG, fontSize: 16),
                    ),
                    Text(
                      '${widget.item?.name}',
                      style: styleBaseRegular(
                          color: ThemeColors.neutral40, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 5),
              Container(
                height: 35,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.greyText, width: 0.5),
                    color: ThemeColors.splashBG,
                    borderRadius: BorderRadius.circular(8.0)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          navigatorKey.currentContext!, SDIndex.path,
                          arguments: {
                            'symbol': widget.symbol ?? "",
                          });
                    },
                    child: Text(
                      "Stock Overview",
                      textAlign: TextAlign.center,
                      style:
                          styleBaseBold(fontSize: 14, color: ThemeColors.white),
                    )),
              )
            ],
          ),
          Divider(
            color: ThemeColors.neutral5,
            thickness: 1,
            height: 20,
          ),
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
            icon: orderIcons?.buyIcon??"",
            title: "Buy Order",
            subtitle:
                subtitleWithSymbol(ordersSubTitle?.buyOrder, widget.symbol),
            onTap: () {
              if (lockInfoRes != null) {
                BaseBottomSheet().bottomSheet(
                    isScrollable: false,
                    child: BaseLockItem(
                      manager: portfolioManager,
                      lockWithImage: false,
                    ));
              } else {
                var selectedStock = StockType.buy;
                if(_userOrdersCheck?.buyOrder==true){
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                }else{
                  openInfoSheet(selectedStock: selectedStock);
                }

              }
            },
          ),
          BaseListDivider(),
          BuyOrderItem(
            icon: orderIcons?.sellOrderIcon??"",
            title: "Sell Order",
            subtitle: subtitleWithSymbol(
              ordersSubTitle?.sellOrder,
              widget.symbol,
            ),
            onTap: () {
              if (lockInfoRes != null) {
                BaseBottomSheet().bottomSheet(
                    isScrollable: false,
                    child: BaseLockItem(
                      manager: portfolioManager,
                      lockWithImage: false,
                    ));
              } else {
                var selectedStock = StockType.sell;
                if(_userOrdersCheck?.sellOrder==true){
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                }else{
                  openInfoSheet(selectedStock: selectedStock);
                }
              }
            },
          ),
          BaseListDivider(),
          BuyOrderItem(
            icon: orderIcons?.shortOrderIcon??"",
            title: "Short Order",
            subtitle: subtitleWithSymbol(
              ordersSubTitle?.shortOrder,
              widget.symbol,
            ),
            onTap: () {
              if (lockInfoRes != null) {
                BaseBottomSheet().bottomSheet(
                    isScrollable: false,
                    child: BaseLockItem(
                      manager: portfolioManager,
                      lockWithImage: false,
                    ));
              } else {
                var selectedStock = StockType.short;
                if(_userOrdersCheck?.shortOrder==true){
                  navigatorKey.currentContext!
                      .read<TickerSearchManager>()
                      .shortRedirection(widget.symbol ?? "");
                }
                else{
                  openInfoSheet(selectedStock: selectedStock);
                }

              }
            },
          ),
          BaseListDivider(),
          BuyOrderItem(
            icon: orderIcons?.buyToCoverIcon??"",
            title: "Buy to Cover Order",
            subtitle: subtitleWithSymbol(
              ordersSubTitle?.buyToCoverOrder,
              widget.symbol,
            ),
            onTap: () {
              if (lockInfoRes != null) {
                BaseBottomSheet().bottomSheet(
                    isScrollable: false,
                    child: BaseLockItem(
                      manager: portfolioManager,
                      lockWithImage: false,
                    ));
              } else {
                var selectedStock = StockType.btc;
                if(_userOrdersCheck?.btcOrder==true){
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                }else{
                  openInfoSheet(selectedStock: selectedStock);
                }

              }
            },
          ),
          SpacerVertical(height: Pad.pad5),
          Visibility(
            visible: userConditionalOrderPermissionRes?.bracketOrder == true,
            child: Text(
              "Conditional orders",
              style: styleBaseBold(
                fontSize: 18,
                color: ThemeColors.black,
              ),
            ),
          ),
          Visibility(
            visible: userConditionalOrderPermissionRes?.bracketOrder == true,
            child: BuyOrderItem(
              icon: orderIcons?.bracketOrderIcon??"",
              title: "Bracket Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.bracketOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.bracketOrder;
                if (lockInfoRes != null) {
                  BaseBottomSheet().bottomSheet(
                      isScrollable: false,
                      child: BaseLockItem(
                        manager: portfolioManager,
                        lockWithImage: false,
                      ));
                } else {
                  if(_userOrdersCheck?.bracketOrder==true){
                    _onTapConditions(cType: selectedType);
                  }else{
                    openInfoSheet(cType: selectedType);
                  }
                  //openInfoSheet(cType: ConditionType.bracketOrder);
                }
              },
            ),
          ),
          Visibility(visible: userConditionalOrderPermissionRes?.bracketOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userConditionalOrderPermissionRes?.limitOrder == true,
            child: BuyOrderItem(
              icon: orderIcons?.limitOrderIcon??"",
              title: "Limit Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.limitOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.limitOrder;
                if (lockInfoRes != null) {
                  BaseBottomSheet().bottomSheet(
                      isScrollable: false,
                      child: BaseLockItem(
                        manager: portfolioManager,
                        lockWithImage: false,
                      ));
                } else {
                  if(_userOrdersCheck?.limitOrder==true){
                    _onTapConditions(cType: selectedType);
                  }else{
                    openInfoSheet(cType: selectedType);
                  }
                //  openInfoSheet(cType: ConditionType.limitOrder);
                }
              },
            ),
          ),
          Visibility(visible: userConditionalOrderPermissionRes?.limitOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userConditionalOrderPermissionRes?.stopOrder == true,
            child: BuyOrderItem(
              icon: orderIcons?.stopOrderIcon??"",
              title: "Stop Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.stopOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.stopOrder;
                if (lockInfoRes != null) {
                  BaseBottomSheet().bottomSheet(
                      isScrollable: false,
                      child: BaseLockItem(
                        manager: portfolioManager,
                        lockWithImage: false,
                      ));
                } else {
                  if(_userOrdersCheck?.stopOrder==true){
                    _onTapConditions(cType: selectedType);
                  }else{
                    openInfoSheet(cType: selectedType);
                  }
                  //openInfoSheet(cType: ConditionType.stopOrder);
                }
              },
            ),
          ),
          Visibility(visible: userConditionalOrderPermissionRes?.stopOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userConditionalOrderPermissionRes?.stopLimitOrder == true,
            child: BuyOrderItem(
              icon: orderIcons?.stopLimitIcon??"",
              title: "Stop Limit Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.stopLimitOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.stopLimitOrder;
                if (lockInfoRes != null) {
                  BaseBottomSheet().bottomSheet(
                      isScrollable: false,
                      child: BaseLockItem(
                        manager: portfolioManager,
                        lockWithImage: false,
                      ));
                } else {
                  if(_userOrdersCheck?.stopLimitOrder==true){
                    _onTapConditions(cType: selectedType);
                  }else{
                    openInfoSheet(cType: selectedType);
                  }
                  //openInfoSheet(cType: ConditionType.stopLimitOrder);
                }
              },
            ),
          ),
          Visibility(visible: userConditionalOrderPermissionRes?.stopLimitOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userConditionalOrderPermissionRes?.trailingOrder == true,
            child: BuyOrderItem(
              icon: orderIcons?.trailingOrderIcon??"",
              title: "Trailing Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.trailingOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.trailingOrder;
                if (lockInfoRes != null) {
                  BaseBottomSheet().bottomSheet(
                      isScrollable: false,
                      child: BaseLockItem(
                        manager: portfolioManager,
                        lockWithImage: false,
                      ));
                } else {
                  if(_userOrdersCheck?.trailingOrder==true){
                    _onTapConditions(cType: selectedType);
                  }else{
                    openInfoSheet(cType: selectedType);
                  }
                //  openInfoSheet(cType: ConditionType.trailingOrder);
                }
              },
            ),
          ),
          Visibility(visible: userConditionalOrderPermissionRes?.trailingOrder == true,child: BaseListDivider()),
          Visibility(
            visible: userConditionalOrderPermissionRes?.recurringOrder == true,
            child: BuyOrderItem(
              icon: orderIcons?.recurringOrderIcon??"",
              title: "Recurring Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.recurringOrder,
                widget.symbol,
              ),
              onTap: () {
                var selectedType = ConditionType.recurringOrder;
                if (lockInfoRes != null) {
                  BaseBottomSheet().bottomSheet(
                      isScrollable: false,
                      child: BaseLockItem(
                        manager: portfolioManager,
                        lockWithImage: false,
                      ));
                } else {
                  if(_userOrdersCheck?.recurringOrder==true){
                    _onTapConditions(cType: selectedType);
                  }else{
                    openInfoSheet(cType: selectedType);
                  }
                 // openInfoSheet(cType: ConditionType.recurringOrder);
                }
              },
            ),
          ),
          Visibility(visible: userConditionalOrderPermissionRes?.recurringOrder == true,child: BaseListDivider()),

        ],
      ),
    );
  }
}
