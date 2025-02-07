import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_topbar.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/ConditionalOrder/show_conditional_sheet.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/detailTop/top.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

class ContainerConditioalBuySell extends StatefulWidget {
  final num? qty;
  final ConditionType? conditionalType;
  final String? tradeType;

  const ContainerConditioalBuySell({
    super.key,
    this.conditionalType,
    this.qty,
   this.tradeType,
  });

  @override
  State<ContainerConditioalBuySell> createState() => _ContainerConditioalBuySellState();
}

class _ContainerConditioalBuySellState extends State<ContainerConditioalBuySell> {
  TextEditingController controller = TextEditingController();
  TextEditingController targetPriceController = TextEditingController();
  TextEditingController limitPriceController = TextEditingController();
  TextEditingController stopPriceController = TextEditingController();

  TypeTrade _selectedSegment = TypeTrade.shares;
  StockType _selectedTock = StockType.buy;

  FocusNode focusNode = FocusNode();
  String _currentText = "0";
  String _lastEntered = "";
  String _previousText = "";
  int _keyCounter = 0;
  num _availableBalance = 0;
  int selectedIndex = 0;
  List<String> menus = [
    'Buy',
    'Short',
    'Sell',
    'But to Cover',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      _availableBalance = context.read<TsPortfolioProvider>().userData?.tradeBalance ?? 0;
      if(widget.tradeType!=null){
        selectedIndex = menus.indexWhere((element) => element == widget.tradeType);
        _selectedTock = selectedIndex == 0
            ? StockType.buy
            : selectedIndex == 1?
        StockType.short:
        selectedIndex == 2?
        StockType.sell:
        StockType.btc;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    targetPriceController.dispose();
    stopPriceController.dispose();
    limitPriceController.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    super.dispose();
  }

  _onTap() async {
    closeKeyboard();
    TradeProviderNew provider = context.read<TradeProviderNew>();
    TsStockDetailRes? detailRes = provider.detailRes;

    if (detailRes?.executable == false) {
      popUpAlert(
        title: "Confirm Order",
        message:
            "You are making transaction when market is closed. Your transaction will be take place when market is open. This order will be pending until then.",
        okText: "Continue",
        onTap: () {
          Navigator.pop(context);
          _onContinue(isPending: true);
        },
        cancel: true,
      );
    } else {
      _onContinue();
    }
  }

  _onContinue({bool isPending = false}) async {
    TradeProviderNew provider = context.read<TradeProviderNew>();
    TsPortfolioProvider portfolioProvider = context.read<TsPortfolioProvider>();
    TsStockDetailRes? detailRes = provider.detailRes;

    num invested = _selectedSegment == TypeTrade.shares
        ? (detailRes?.currentPrice ?? 0) * num.parse(_currentText)
        : num.parse(_currentText);

    closeKeyboard();
    if (controller.text.isEmpty || num.parse(controller.text) == 0.0) {
      popUpAlert(
        message: "Value can't be empty",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    if (_selectedTock == StockType.buy) {
      if (invested > (portfolioProvider.userData?.tradeBalance ?? 0)) {
        popUpAlert(
          message: "Insufficient available balance to place this order.",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
        return;
      } else {
        final Map<String, dynamic> request = {
          "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ??
              "",
          "action": "BUY",
          "symbol": detailRes?.symbol,
          "quantity": controller.text,
          "order_type":  widget.conditionalType == ConditionType.bracketOrder ? 'BRACKET_ORDER': widget.conditionalType == ConditionType.limitOrder ?'LIMIT_ORDER' : "STOP_ORDER",
          "duration": "GOOD_UNTIL_CANCELLED",
          "target_price": targetPriceController.text,
          "stop_price": stopPriceController.text,
          "limit_price": limitPriceController.text,
        };

        ApiResponse response =
        await provider.requestBuyShare(request, showProgress: true);
        Utils().showLog('~~~~~${response.status}~~~~');
        if (response.status) {
          context.read<TsPortfolioProvider>().getDashboardData();
          context.read<TsOpenListProvider>().getData();
          num? numPrice = response.data['result']['executed_at'];
          final order = SummaryOrderNew(
            isShare: _selectedSegment == TypeTrade.shares,
            change: '${detailRes?.change?.toFormattedPrice()}',
            changePercentage: detailRes?.changePercentage,
            dollars: _selectedSegment == TypeTrade.dollar
                ? num.parse(_currentText)
                : (num.parse(_currentText) * (detailRes?.currentPrice ?? 0)),
            shares: _selectedSegment == TypeTrade.shares
                ? num.parse(_currentText)
                : (num.parse(_currentText) / (detailRes?.currentPrice ?? 0)),
            image: detailRes?.image,
            name: detailRes?.company,
            currentPrice: numPrice,
            symbol: detailRes?.symbol,
            invested: invested,
            date: response.data['result']['created_date'],
            targetPrice: targetPriceController.text.isNotEmpty?num.parse(targetPriceController.text):0,
            stopPrice:  stopPriceController.text.isNotEmpty?num.parse(stopPriceController.text):0,
            limitPrice:  limitPriceController.text.isNotEmpty?num.parse(limitPriceController.text):0,
          );

          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => TsDashboard(initialIndex: isPending ? 1 : 0),
            ),
          );
          _clear();

          await showCOrderSuccessSheet(order, widget.conditionalType);
        } else {
          popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF,
          );
        }
      }
    }
    else {
      FormData request = FormData.fromMap({
        "token":
        navigatorKey.currentContext!.read<UserProvider>().user?.token ??
            "",
        "action": _selectedTock == StockType.short
            ? "SHORT"
            : _selectedTock == StockType.sell
            ? "SELL"
            : "BUY_TO_COVER",
        "symbol": detailRes?.symbol,
        "order_type":  widget.conditionalType == ConditionType.bracketOrder
            ? 'BRACKET_ORDER': widget.conditionalType == ConditionType.limitOrder
            ?'LIMIT_ORDER' : "STOP_ORDER",
        "duration": "GOOD_UNTIL_CANCELLED",
        "quantity": controller.text,
        "target_price": targetPriceController.text,
        "stop_price": stopPriceController.text,
        "limit_price": limitPriceController.text,
      });

      ApiResponse response =
      await provider.requestSellShare(request, showProgress: true);
      Utils().showLog('~~~~~${response.status}~~~~');

      if (response.status) {
        num? numPrice = response.data['result']['executed_at'];
        context.read<TsOpenListProvider>().getData();
        final order = SummaryOrderNew(
          isShare: _selectedSegment == TypeTrade.shares,
          change: '${detailRes?.change?.toFormattedPrice()}',
          changePercentage: detailRes?.changePercentage,
          dollars: _selectedSegment == TypeTrade.dollar
              ? num.parse(_currentText)
              : (num.parse(_currentText) * (detailRes?.currentPrice ?? 0)),
          shares: _selectedSegment == TypeTrade.shares
              ? num.parse(_currentText)
              : (num.parse(_currentText) / (detailRes?.currentPrice ?? 0)),
          image: detailRes?.image,
          name: detailRes?.company,
          currentPrice: numPrice,
          symbol: detailRes?.symbol,
          invested: invested,
          date: response.data['result']['created_date'],
          targetPrice: targetPriceController.text.isNotEmpty?num.parse(targetPriceController.text):0,
          stopPrice:  stopPriceController.text.isNotEmpty?num.parse(stopPriceController.text):0,
          limitPrice:  limitPriceController.text.isNotEmpty?num.parse(limitPriceController.text):0,
        );
        _clear();
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TsDashboard(initialIndex: isPending ? 1 : 0),
          ),
        );
        await showCOrderSuccessSheet(order, widget.conditionalType);
      } else {
        popUpAlert(message: "${response.message}", title: "Alert");
      }
    }
  }
  _clear() {
    Timer(const Duration(milliseconds: 50), () {
      controller.clear();
      setState(() {
        _currentText = "0";
        _lastEntered = '';
        _keyCounter = 0;
      });
    });
  }

  _onValueChange(TypeTrade? value) {
    if (value != null) {
      setState(() {
        _selectedSegment = value;
      });
    }
  }
  _onChange(String text) {
    try {
      Utils().showLog("TEXT=>$text");

      setState(() {
        if (text.length < _previousText.length) {
          // Clearing text
          _lastEntered = "";
          _currentText = text;
          _keyCounter++;
          if (text == '') {
            _currentText = '0';
          }
        } else {
          if (text == "." || text == "0.") {
            Utils().showLog("IF");
            _currentText = "0.";
            controller.text = "0.";
          } else {
            Utils().showLog("ELSE");

            // Adding new characters
            _lastEntered = text.substring(text.length - 1);
            _currentText = text;
            _keyCounter++;
          }
        }
        _previousText = text;
      });
    } catch (e) {
      Utils().showLog('error $e');
    }
  }

  Widget _newMethod() {
    TradeProviderNew provider = context.read<TradeProviderNew>();
    TsStockDetailRes? detailRes = provider.detailRes;

    TsPortfolioProvider portfolioProvider = context.read<TsPortfolioProvider>();

    num parsedCurrentText = num.tryParse(_currentText) ?? 0;
    num invested = _selectedSegment == TypeTrade.shares
        ? (detailRes?.currentPrice ?? 0) * parsedCurrentText
        : parsedCurrentText;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    text: "Balance: ",
                    style: stylePTSansBold(fontSize: 14),
                    children: [
                      TextSpan(
                        text: portfolioProvider.userData?.tradeBalance != null
                            ? "\$${formatBalance(num.parse(portfolioProvider.userData!.tradeBalance.toCurrency()))}"
                            : '\$0',
                        style: stylePTSansRegular(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    text: "Order Value: ",
                    style: stylePTSansBold(fontSize: 14),
                    children: [
                      TextSpan(
                        text: "\$${invested.toCurrency()}",
                        style: stylePTSansRegular(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SpacerVertical(),

          Visibility(
            visible:widget.conditionalType == ConditionType.limitOrder,
            child: ThemeButton(
              disabledBackgroundColor: ThemeColors.greyBorder,
              text: "Proceed Limit Order",
              color:(_selectedTock == StockType.buy||_selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                  ? ThemeColors.greyText
                  : ThemeColors.accent
                  : (controller.text.isEmpty ||
                  num.parse(controller.text) > (widget.qty ?? 0) ||
                  invested == 0)
                  ? ThemeColors.greyText
                  : ThemeColors.sos,
              onPressed:
              ((_selectedTock == StockType.buy||_selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                  : (controller.text.isEmpty ||
                  num.parse(controller.text) > (widget.qty ?? 0))
              ) ? null : (){
                if (limitPriceController.text.isEmpty || num.parse(limitPriceController.text) == 0.0) {
                  popUpAlert(
                    message: "Limit price can't be empty",
                    title: "Alert",
                    icon: Images.alertPopGIF,
                  );
                  return;
                }
                else{
                  _onTap();
                }
              },
            ),
          ),

          Visibility(
            visible:widget.conditionalType == ConditionType.stopOrder,
            child: ThemeButton(
              disabledBackgroundColor: ThemeColors.greyBorder,
              text: "Proceed Stop Order",
              color:(_selectedTock == StockType.buy||_selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                  ? ThemeColors.greyText
                  : ThemeColors.accent
                  : (controller.text.isEmpty ||
                  num.parse(controller.text) > (widget.qty ?? 0) ||
                  invested == 0)
                  ? ThemeColors.greyText
                  : ThemeColors.sos,
              onPressed:
              ((_selectedTock == StockType.buy||_selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                  : (controller.text.isEmpty ||
                  num.parse(controller.text) > (widget.qty ?? 0))
              ) ? null : (){
                if (stopPriceController.text.isEmpty || num.parse(stopPriceController.text) == 0.0) {
                  popUpAlert(
                    message: "Stop price can't be empty",
                    title: "Alert",
                    icon: Images.alertPopGIF,
                  );
                  return;
                }
                else{
                  _onTap();
                }
              },
            ),
          ),

          Visibility(
            visible: controller.text.isNotEmpty &&
                (_selectedTock == StockType.buy ||
                    _selectedTock == StockType.short) &&
                (invested > _availableBalance),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current balance is ',
                  style: styleGeorgiaRegular(color: const Color(0xFFC7C8CC)),
                  children: [
                    TextSpan(
                      text: _availableBalance.toFormattedPrice(),
                      style: styleGeorgiaBold(
                          color: ThemeColors.white, fontSize: 15),
                    ),
                    TextSpan(
                        style:
                            styleGeorgiaRegular(color: const Color(0xFFC7C8CC)),
                        text:
                            '. You cannot purchase shares with an order value that exceeds your available balance.')
                  ],
                ),
              ),
            ),
          ),

          Visibility(
            visible: controller.text.isNotEmpty &&
                (_selectedTock == StockType.sell ||
                    _selectedTock == StockType.btc) &&
                num.parse(controller.text)>(widget.qty??0),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current share holding is ',
                  style: styleGeorgiaRegular(color: const Color(0xFFC7C8CC)),
                  children: [
                    TextSpan(
                      text: '${widget.qty}',
                      style: styleGeorgiaBold(
                          color: ThemeColors.white, fontSize: 15),
                    ),
                    TextSpan(
                        style:
                        styleGeorgiaRegular(color: const Color(0xFFC7C8CC)),
                        text:
                        '. You cannot sell more shares than you currently own.')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TsPortfolioProvider portfolioProvider = context.read<TsPortfolioProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const TsTopWidget(),
                  const SpacerVertical(height: 5),

                  Container(
                      width: 110,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient:  LinearGradient(
                        colors: [
                          ThemeColors.bottomsheetGradient,
                          ThemeColors.accent,
                        ],

                      )
                    ),
                    child: Center(
                      child: Text(
                        selectedIndex==0?"Buy":
                        selectedIndex==1?"Short":
                        selectedIndex==2?"Sell":"Buy to Cover",
                        style:styleGeorgiaBold(
                            fontSize: 15,
                            color: ThemeColors.white
                        ),
                      ),
                    ),
                  ),
                 /* TradeCustomeSliding(
                    menus: menus,
                    onValueChanged: (index) {},
                    selectedIndex: selectedIndex,
                  ),*/
                  Visibility(child: const SpacerVertical(height: 5)),
                  TextfieldTrade(
                    controller: controller,
                    focusNode: focusNode,
                    text: _currentText.substring(
                      0,
                      _currentText.length - _lastEntered.length,
                    ),
                    change: _onChange,
                    counter: _keyCounter,
                    lastEntered: _lastEntered,
                  ),
                  Text(
                    'Enter number of shares',
                    style: styleGeorgiaRegular(color: ThemeColors.greyText),
                  ),
                  if (widget.qty != null)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Available quantity - ${widget.qty ?? 0}',
                        style: styleGeorgiaBold(),
                      ),
                    ),
                  SpacerVertical(),
                  Visibility(
                    visible:  widget.conditionalType == ConditionType.limitOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Limit Price",
                          style: stylePTSansBold(color: Colors.white),
                          subTitle:
                          selectedIndex==0?
                          portfolioProvider.userData?.labelInfoStrings?.buy?.limitOrder?.limitPrice??"":
                          selectedIndex==1?
                          portfolioProvider.userData?.labelInfoStrings?.short?.limitOrder?.limitPrice??"":
                          selectedIndex==2?
                          portfolioProvider.userData?.labelInfoStrings?.sell?.limitOrder?.limitPrice??"":
                          portfolioProvider.userData?.labelInfoStrings?.buyToCover?.limitOrder?.limitPrice??"",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: Colors.white,
                          fillColor: ThemeColors.primaryLight,
                          borderColor: ThemeColors.primaryLight,
                          controller: limitPriceController,
                          placeholder: "Limit Price",
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                          style: stylePTSansRegular(color: Colors.white),
                        ),

                      ],
                    ),
                  ),

                  Visibility(
                    visible:widget.conditionalType == ConditionType.stopOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Stop Price",
                          style: stylePTSansBold(color: Colors.white),
                          subTitle:
                          selectedIndex==0?
                          portfolioProvider.userData?.labelInfoStrings?.buy?.stopOrder?.stopPrice??"":
                          selectedIndex==1?
                          portfolioProvider.userData?.labelInfoStrings?.short?.stopOrder?.stopPrice??"":
                          selectedIndex==2?
                          portfolioProvider.userData?.labelInfoStrings?.sell?.stopOrder?.stopPrice??"":
                          portfolioProvider.userData?.labelInfoStrings?.buyToCover?.stopOrder?.stopPrice??"",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: Colors.white,
                          fillColor: ThemeColors.primaryLight,
                          borderColor: ThemeColors.primaryLight,
                          controller: stopPriceController,
                          placeholder: "Stop Price",
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                          style: stylePTSansRegular(color: Colors.white),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
          _newMethod(),
        ],
      ),
    );
  }
}
