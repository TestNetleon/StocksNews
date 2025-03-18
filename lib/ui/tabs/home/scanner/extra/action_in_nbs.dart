import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_user_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradingWithTypes/order_info_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradingWithTypes/widgets/buy_order_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class ActionInNbs extends StatefulWidget {
  final bool? isLocked;
  final String? symbol;
  final int? from;
  final BaseTickerRes? item;
  final BaseLockInfoRes? simulatorLockInfoRes;
  const ActionInNbs({super.key, this.isLocked,this.symbol, this.from, this.item,this.simulatorLockInfoRes});

  @override
  State<ActionInNbs> createState() => _ActionInNbsState();
}

class _ActionInNbsState extends State<ActionInNbs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData() async {
    PortfolioManager manager = context.read<PortfolioManager>();
    manager.getDashboardData();
  }

  Future _onTap({String? symbol, StockType? selectedStock}) async {
    setState(() {});
    try {
      TickerSearchManager manager = navigatorKey.currentContext!.read<TickerSearchManager>();
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
    PortfolioManager portfolioManager = context.watch<PortfolioManager>();
    OrdersSubTitle? ordersSubTitle =portfolioManager.userData?.userDataRes?.ordersSubTitle;
    UserConditionalOrderPermissionRes? userConditionalOrderPermissionRes =portfolioManager.userData?.userDataRes?.userConditionalOrderPermission;
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
                        style: styleGeorgiaBold(
                            color: ThemeColors.splashBG, fontSize: 16),
                      ),
                      Text(
                        '${widget.item?.name}',
                        style: styleGeorgiaRegular(
                            color: ThemeColors.neutral40, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width:5),
                Container(
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal:8),
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeColors.greyText, width: 0.5),
                      color: ThemeColors.splashBG,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(navigatorKey.currentContext!, SDIndex.path,
                          arguments: {
                            'symbol': widget.symbol ?? "",
                          });

                    },
                    child: Text(
                    "Stock Overview",
                    textAlign: TextAlign.center,
                    style:stylePTSansBold(fontSize: 14,color: ThemeColors.white),
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
              style: stylePTSansBold(
                fontSize: 18,
                color: ThemeColors.black,
              ),
            ),
            SpacerVertical(height: Pad.pad5),
            BuyOrderItem(
              title: "Buy Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.buyOrder, widget.symbol
              ),
              onTap: () {
                BaseLockItem(
                  manager: portfolioManager,
                  callAPI: () async {
                    await portfolioManager.getDashboardData(reset: true);
                  },
                );
                var selectedStock = StockType.buy;
                _onTap(symbol: widget.symbol, selectedStock: selectedStock);

              },
            ),
            BuyOrderItem(
              title: "Sell Order",
              subtitle: subtitleWithSymbol(ordersSubTitle?.sellOrder,
                widget.symbol,
              ),
              onTap: () {
                // if (isLocked){
                //   commonLockSheet(isLocked,havePermissions);
                // }
                // else {
                  var selectedStock = StockType.sell;
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
              //  }
              },
            ),
            BuyOrderItem(
              title: "Short Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.shortOrder,
                widget.symbol,
              ),
              onTap: () {
                // if (isLocked){
                //   commonLockSheet(isLocked,havePermissions);
                // }
                // else{
                  navigatorKey.currentContext!
                      .read<TickerSearchManager>()
                      .shortRedirection(widget.symbol ?? "");
                //}

              },
            ),
            BuyOrderItem(
              title: "Buy to Cover Order",
              subtitle: subtitleWithSymbol(
                ordersSubTitle?.buyToCoverOrder,
                widget.symbol,
              ),
              onTap: () {
                // if (isLocked){
                //   commonLockSheet(isLocked,havePermissions);
                // }
                // else{
                  var selectedStock = StockType.btc;
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
               // }

              },
            ),
            SpacerVertical(height: Pad.pad5),
            Visibility(
              visible:userConditionalOrderPermissionRes?.bracketOrder ==
                  true,
              child: Text(
                "Conditional orders",
                style: stylePTSansBold(
                  fontSize: 18,
                  color: ThemeColors.black,
                ),
              ),
            ),
            Visibility(
              visible: userConditionalOrderPermissionRes?.bracketOrder ==
                  true,
              child: BuyOrderItem(
                title: "Bracket Order",
                subtitle: subtitleWithSymbol(
                  ordersSubTitle?.bracketOrder,
                  widget.symbol,
                ),
                onTap: () {
                  // if (isLocked){
                  //   commonLockSheet(isLocked,havePermissions);
                  // }
                  // else{
                    openInfoSheet(cType: ConditionType.bracketOrder);
                 // }

                },
              ),
            ),
            Visibility(
              visible: userConditionalOrderPermissionRes?.limitOrder ==
                  true,
              child: BuyOrderItem(
                title: "Limit Order",
                subtitle: subtitleWithSymbol(
                  ordersSubTitle?.limitOrder,
                  widget.symbol,
                ),
                onTap: () {
                  // if (isLocked){
                  //   commonLockSheet(isLocked,havePermissions);
                  // }
                  // else{

                    openInfoSheet(cType: ConditionType.limitOrder);
                 // }

                },
              ),
            ),
            Visibility(
              visible: userConditionalOrderPermissionRes?.stopOrder ==
                  true,
              child: BuyOrderItem(
                title: "Stop Order",
                subtitle: subtitleWithSymbol(
                  ordersSubTitle?.stopOrder,
                  widget.symbol,
                ),
                onTap: () {
                  // if (isLocked){
                  //   commonLockSheet(isLocked,havePermissions);
                  // }
                  // else{
                    openInfoSheet(cType: ConditionType.stopOrder);
                //  }

                },
              ),
            ),
            Visibility(
              visible: userConditionalOrderPermissionRes?.stopLimitOrder ==
                  true,
              child: BuyOrderItem(
                title: "Stop Limit Order",
                subtitle: subtitleWithSymbol(
                  ordersSubTitle?.stopLimitOrder,
                  widget.symbol,
                ),
                onTap: () {

                  // if (isLocked){
                  //   commonLockSheet(isLocked,havePermissions);
                  // }
                  // else{
                    openInfoSheet(cType: ConditionType.stopLimitOrder);
                 // }

                },
              ),
            ),
            Visibility(
              visible: userConditionalOrderPermissionRes?.trailingOrder ==
                  true,
              child: BuyOrderItem(
                title: "Trailing Order",
                subtitle: subtitleWithSymbol(
                  ordersSubTitle?.trailingOrder,
                  widget.symbol,
                ),
                onTap: () {
                  // if (isLocked){
                  //   commonLockSheet(isLocked,havePermissions);
                  // }
                  // else{
                    openInfoSheet(cType: ConditionType.trailingOrder);
                  //}
                },
              ),
            ),
            Visibility(
              visible: userConditionalOrderPermissionRes?.recurringOrder ==
                  true,
              child: BuyOrderItem(
                title: "Recurring Order",
                subtitle: subtitleWithSymbol(
                  ordersSubTitle?.recurringOrder,
                  widget.symbol,
                ),
                onTap: () {
                  // if (isLocked){
                  //   commonLockSheet(isLocked,havePermissions);
                  // }
                  // else{
                    openInfoSheet(cType: ConditionType.recurringOrder);
                 // }

                },
              ),
            ),
          ],
        ),
      );

  }
}
