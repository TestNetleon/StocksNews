import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_user_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

Future openInfoSheet(ConditionType? cType, StockType? selectedStock) async {
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
            cType: cType,
            selectedStock: selectedStock,
            buttonVisible: false,
          ),
          Container(
            width: 35,
            height: 35,
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ThemeColors.black),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(navigatorKey.currentContext!);
                },
                icon: Icon(Icons.clear, color: ThemeColors.white, size: 18)),
          ),
        ],
      );
    },
  );
 /* await BaseBottomSheet().bottomSheet(
      child:Stack(
        alignment: Alignment.topRight,
        children: [
          OrderInfoSheet(
            cType: cType,
            selectedStock: selectedStock,
            buttonVisible: false,
          ),
          Container(
            width: 35,
            height: 35,
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ThemeColors.primary),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(navigatorKey.currentContext!);
                },
                icon: Icon(Icons.clear, color: ThemeColors.white, size: 18)),
          ),
        ],
      )
  );*/
}

class OrderInfoSheet extends StatefulWidget {
  final String? symbol;
  final dynamic qty;
  final int? tickerID;
  final ConditionType? cType;
  final StockType? selectedStock;
  final bool buttonVisible;
  const OrderInfoSheet(
      {super.key,
      this.symbol,
      this.qty,
      this.tickerID,
      this.cType,
      this.selectedStock,
      this.buttonVisible=true
      });

  @override
  State<OrderInfoSheet> createState() => _OrderInfoSheetState();
}

class _OrderInfoSheetState extends State<OrderInfoSheet> {
  bool boxChecked = false;
  UserOrdersCheck? _userOrdersCheck;
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       TickerSearchManager manager = context.read<TickerSearchManager>();
       manager.orderInfo(conditionalType: widget.cType,selectedStock: widget.selectedStock);
      if(widget.buttonVisible){
        context.read<PortfolioManager>().getHolidays();
        getForUser();
      }
    });
  }

  Future getForUser() async {
    _userOrdersCheck = await Preference.getUserCheck();
      if(widget.selectedStock==StockType.buy){
        boxChecked=_userOrdersCheck?.buyOrder??false;
      }
      if(widget.selectedStock==StockType.sell){
        boxChecked=_userOrdersCheck?.sellOrder??false;
      }
      if(widget.selectedStock==StockType.short){
        boxChecked=_userOrdersCheck?.shortOrder??false;
      }
      if(widget.selectedStock==StockType.btc){
        boxChecked=_userOrdersCheck?.btcOrder??false;
      }
      if(widget.cType==ConditionType.bracketOrder){
        boxChecked=_userOrdersCheck?.bracketOrder??false;
      }
      if(widget.cType==ConditionType.limitOrder){
        boxChecked=_userOrdersCheck?.limitOrder??false;
      }
      if(widget.cType==ConditionType.stopOrder){
        boxChecked=_userOrdersCheck?.stopOrder??false;
      }
      if(widget.cType==ConditionType.stopLimitOrder){
        boxChecked=_userOrdersCheck?.stopLimitOrder??false;
      }
      if(widget.cType==ConditionType.trailingOrder){
        boxChecked=_userOrdersCheck?.trailingOrder??false;
      }if(widget.cType==ConditionType.recurringOrder){
        boxChecked=_userOrdersCheck?.recurringOrder??false;
      }
      setState(() {});
  }

  Future<void> setUser(UserOrdersCheck? userOrdersCheck) async {
    if (userOrdersCheck == null) return;
    await Preference.saveUserCheck(userOrdersCheck);
    setState(() {});
  }
  void onProceed() {
    if(widget.selectedStock==StockType.buy){
      _userOrdersCheck?.buyOrder=boxChecked;
    }
    if(widget.selectedStock==StockType.sell){
      _userOrdersCheck?.sellOrder=boxChecked;
    }
    if(widget.selectedStock==StockType.short){
      _userOrdersCheck?.shortOrder=boxChecked;
    }
    if(widget.selectedStock==StockType.btc){
      _userOrdersCheck?.btcOrder=boxChecked;
    }
    if(widget.cType==ConditionType.bracketOrder){
      _userOrdersCheck?.bracketOrder=boxChecked;
    }
    if(widget.cType==ConditionType.limitOrder){
      _userOrdersCheck?.limitOrder=boxChecked;
    }
    if(widget.cType==ConditionType.stopOrder){
      _userOrdersCheck?.stopOrder=boxChecked;
    }
    if(widget.cType==ConditionType.stopLimitOrder){
      _userOrdersCheck?.stopLimitOrder=boxChecked;
    }
    if(widget.cType==ConditionType.trailingOrder){
      _userOrdersCheck?.trailingOrder=boxChecked;
    }
    if(widget.cType==ConditionType.recurringOrder){
      _userOrdersCheck?.recurringOrder=boxChecked;
    }
    setState(() {});
    setUser(_userOrdersCheck);
    if (widget.symbol != null) {
      if(widget.cType==ConditionType.recurringOrder){
        context.read<TickerSearchManager>().stockHoldingOfRecurringCondition(widget.symbol ?? "");
      }
      else{
        context
            .read<TickerSearchManager>()
            .conditionalRedirection(widget.symbol ?? "",
            tickerID: widget.tickerID,
            qty: widget.qty,
            conditionalType: widget.cType);
      }
    }
  }
  _changeBox() {
    boxChecked = !boxChecked;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    TickerSearchManager manager = context.watch<TickerSearchManager>();
    PortfolioManager portfolioManager = context.watch<PortfolioManager>();
    TsUserDataRes? userDataRes = portfolioManager.userData?.userDataRes;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BaseLoaderContainer(
              hasData: manager.infoData != null,
              isLoading: manager.isInfoLoading,
              error: manager.error,
              showPreparingText: true,
              child: SingleChildScrollView(
                child: HtmlWidget(
                  manager.infoData?.html ?? "",
                ),
              ),
            ),
          ),
          Visibility(visible:widget.buttonVisible,child: SpacerVertical(height: 14)),
          Visibility(
            visible:widget.buttonVisible,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Pad.pad5),
                  child: InkWell(
                    onTap: _changeBox,
                    child: Container(
                      height: 20.sp,
                      width: 20.sp,
                      decoration: BoxDecoration(
                        color: boxChecked
                            ? ThemeColors.primary120
                            : ThemeColors.white,
                        border: Border.all(
                          color: boxChecked
                              ? ThemeColors.white
                              : ThemeColors.primary120,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.sp,
                        color: boxChecked
                            ? ThemeColors.black
                            : ThemeColors.white,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Pad.pad10),
                    child: Text(
                      userDataRes?.strings?.defPrevConcernLbl??"",
                      style: styleBaseRegular(
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(visible:widget.buttonVisible,child: SpacerVertical(height: 14)),
          Visibility(
            visible: widget.buttonVisible,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.greyBorder,
              text: "Proceed Order",
              color: ThemeColors.splashBG,
              textColor: ThemeColors.white,
              onPressed:!boxChecked?null:onProceed,
            ),
          )
        ],
      ),
    );
  }
}
