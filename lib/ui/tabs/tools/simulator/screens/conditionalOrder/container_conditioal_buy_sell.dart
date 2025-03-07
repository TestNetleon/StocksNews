import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_open.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/show_conditional_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradingWithTypes/order_info_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/s_top.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
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
  State<ContainerConditioalBuySell> createState() =>
      _ContainerConditioalBuySellState();
}

class _ContainerConditioalBuySellState
    extends State<ContainerConditioalBuySell> {
  TextEditingController controller = TextEditingController();
  TextEditingController targetPriceController = TextEditingController();
  TextEditingController limitPriceController = TextEditingController();
  TextEditingController stopPriceController = TextEditingController();

  TypeTrade _selectedSegment = TypeTrade.shares;
  StockType? _selectedStock;

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
      _availableBalance = context
              .read<PortfolioManager>()
              .userData
              ?.userDataRes
              ?.tradeBalance ??
          0;
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
    TradeManager manager = context.read<TradeManager>();
    BaseTickerRes? detailRes = manager.detailRes;

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
    TradeManager manager = context.read<TradeManager>();
    PortfolioManager portfolioManager = context.read<PortfolioManager>();
    BaseTickerRes? detailRes = manager.detailRes;

    num invested = _selectedSegment == TypeTrade.shares
        ? (detailRes?.price ?? 0) * num.parse(_currentText)
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
    if (_selectedStock == StockType.buy) {
      if (invested >
          (portfolioManager.userData?.userDataRes?.tradeBalance ?? 0)) {
        popUpAlert(
          message: "Insufficient available balance to place this order.",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
        return;
      } else {
        final Map<String, dynamic> request = {
          "action": "BUY",
          "symbol": detailRes?.symbol,
          "quantity": controller.text,
          "order_type": widget.conditionalType == ConditionType.bracketOrder
              ? 'BRACKET_ORDER'
              : widget.conditionalType == ConditionType.limitOrder
                  ? 'LIMIT_ORDER'
                  : widget.conditionalType == ConditionType.stopOrder
                      ? "STOP_ORDER"
                      : widget.conditionalType == ConditionType.stopLimitOrder
                          ? "STOP_LIMIT_ORDER"
                          : "TRAILING_ORDER",
          "duration": "GOOD_UNTIL_CANCELLED",
          "target_price": targetPriceController.text,
          "stop_price": stopPriceController.text,
          "limit_price": limitPriceController.text,
        };

        ApiResponse response =
            await manager.requestBuyShare(request, showProgress: true);
        Utils().showLog('~~~~~${response.status}~~~~');
        if (response.status) {
          num? numPrice = response.data['result']['executed_at'];
          final order = SummaryOrderNew(
            isShare: _selectedSegment == TypeTrade.shares,
            change: '${detailRes?.change?.toFormattedPrice()}',
            changePercentage: detailRes?.changesPercentage,
            dollars: _selectedSegment == TypeTrade.dollar
                ? num.parse(_currentText)
                : (num.parse(_currentText) * (detailRes?.price ?? 0)),
            shares: _selectedSegment == TypeTrade.shares
                ? num.parse(_currentText)
                : (num.parse(_currentText) / (detailRes?.price ?? 0)),
            image: detailRes?.image,
            name: detailRes?.name,
            currentPrice: numPrice,
            symbol: detailRes?.symbol,
            invested: invested,
            date: response.data['result']['created_date'],
            targetPrice: targetPriceController.text.isNotEmpty
                ? num.parse(targetPriceController.text)
                : 0,
            stopPrice: stopPriceController.text.isNotEmpty
                ? num.parse(stopPriceController.text)
                : 0,
            limitPrice: limitPriceController.text.isNotEmpty
                ? num.parse(limitPriceController.text)
                : 0,
          );

          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,
              arguments: {"initialIndex": isPending ? 1 : 0});
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
    } else {
      final Map<String, dynamic> request = {
        "action": _selectedStock == StockType.short
            ? "SHORT"
            : _selectedStock == StockType.sell
                ? "SELL"
                : "BUY_TO_COVER",
        "symbol": detailRes?.symbol,
        "order_type": widget.conditionalType == ConditionType.bracketOrder
            ? 'BRACKET_ORDER'
            : widget.conditionalType == ConditionType.limitOrder
                ? 'LIMIT_ORDER'
                : widget.conditionalType == ConditionType.stopOrder
                    ? "STOP_ORDER"
                    : widget.conditionalType == ConditionType.stopLimitOrder
                        ? "STOP_LIMIT_ORDER"
                        : "TRAILING_ORDER",
        "duration": "GOOD_UNTIL_CANCELLED",
        "quantity": controller.text,
        "target_price": targetPriceController.text,
        "stop_price": stopPriceController.text,
        "limit_price": limitPriceController.text,
      };
      /* FormData request = FormData.fromMap({
        "action": _selectedStock == StockType.short
            ? "SHORT"
            : _selectedStock == StockType.sell
            ? "SELL"
            : "BUY_TO_COVER",
        "symbol": detailRes?.symbol,
        "order_type":  widget.conditionalType == ConditionType.bracketOrder
            ? 'BRACKET_ORDER': widget.conditionalType == ConditionType.limitOrder
            ?'LIMIT_ORDER' : widget.conditionalType == ConditionType.stopOrder ? "STOP_ORDER":
        widget.conditionalType == ConditionType.stopLimitOrder?"STOP_LIMIT_ORDER":"TRAILING_ORDER",
        "duration": "GOOD_UNTIL_CANCELLED",
        "quantity": controller.text,
        "target_price": targetPriceController.text,
        "stop_price": stopPriceController.text,
        "limit_price": limitPriceController.text,
      });
*/
      ApiResponse response =
          await manager.requestSellShare(request, showProgress: true);
      Utils().showLog('~~~~~${response.status}~~~~');

      if (response.status) {
        num? numPrice = response.data['result']['executed_at'];
        context.read<SOpenManager>().getData();
        final order = SummaryOrderNew(
          isShare: _selectedSegment == TypeTrade.shares,
          change: '${detailRes?.change?.toFormattedPrice()}',
          changePercentage: detailRes?.changesPercentage,
          dollars: _selectedSegment == TypeTrade.dollar
              ? num.parse(_currentText)
              : (num.parse(_currentText) * (detailRes?.price ?? 0)),
          shares: _selectedSegment == TypeTrade.shares
              ? num.parse(_currentText)
              : (num.parse(_currentText) / (detailRes?.price ?? 0)),
          image: detailRes?.image,
          name: detailRes?.name,
          currentPrice: numPrice,
          symbol: detailRes?.symbol,
          invested: invested,
          date: response.data['result']['created_date'],
          targetPrice: targetPriceController.text.isNotEmpty
              ? num.parse(targetPriceController.text)
              : 0,
          stopPrice: stopPriceController.text.isNotEmpty
              ? num.parse(stopPriceController.text)
              : 0,
          limitPrice: limitPriceController.text.isNotEmpty
              ? num.parse(limitPriceController.text)
              : 0,
        );
        _clear();
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,
            arguments: {"initialIndex": isPending ? 1 : 0});
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
    TradeManager manager = context.read<TradeManager>();
    BaseTickerRes? detailRes = manager.detailRes;

    PortfolioManager portfolioManager = context.read<PortfolioManager>();

    num parsedCurrentText = num.tryParse(_currentText) ?? 0;
    num invested = _selectedSegment == TypeTrade.shares
        ? (detailRes?.price ?? 0) * parsedCurrentText
        : parsedCurrentText;
    return Container(
      padding: const EdgeInsets.all(Pad.pad3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Balance',
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height: Pad.pad10),
                      Text(
                        portfolioManager.userData?.userDataRes?.tradeBalance !=
                                null
                            ? "\$${formatBalance(num.parse(portfolioManager.userData!.userDataRes!.tradeBalance.toCurrency()))}"
                            : '\$0',
                        style: stylePTSansBold(
                            fontSize: 16, color: ThemeColors.splashBG),
                      ),
                    ],
                  ),
                ),
              ),
              SpacerHorizontal(width: Pad.pad10),
              Expanded(
                child: CommonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Order Value',
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height: Pad.pad10),
                      Text(
                        "\$${invested.toCurrency()}",
                        style: stylePTSansBold(
                            fontSize: 16, color: ThemeColors.splashBG),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SpacerVertical(height: Pad.pad10),
          Visibility(
            visible: widget.conditionalType == ConditionType.limitOrder,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: "Proceed Limit Order",
              color: (_selectedStock == StockType.buy ||
                      _selectedStock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedStock == StockType.buy ||
                          _selectedStock == StockType.short)
                      ? (invested > _availableBalance || invested == 0)
                      : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0)))
                  ? null
                  : () {
                      if (limitPriceController.text.isEmpty ||
                          num.parse(limitPriceController.text) == 0.0) {
                        popUpAlert(
                          message: "Limit price can't be empty",
                          title: "Alert",
                          icon: Images.alertPopGIF,
                        );
                        return;
                      } else {
                        _onTap();
                      }
                    },
            ),
          ),
          Visibility(
            visible: widget.conditionalType == ConditionType.stopOrder,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: "Proceed Stop Order",
              color: (_selectedStock == StockType.buy ||
                      _selectedStock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedStock == StockType.buy ||
                          _selectedStock == StockType.short)
                      ? (invested > _availableBalance || invested == 0)
                      : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0)))
                  ? null
                  : () {
                      if (stopPriceController.text.isEmpty ||
                          num.parse(stopPriceController.text) == 0.0) {
                        popUpAlert(
                          message: "Stop price can't be empty",
                          title: "Alert",
                          icon: Images.alertPopGIF,
                        );
                        return;
                      } else {
                        _onTap();
                      }
                    },
            ),
          ),
          Visibility(
            visible: widget.conditionalType == ConditionType.stopLimitOrder,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: "Proceed Stop Limit Order",
              color: (_selectedStock == StockType.buy ||
                      _selectedStock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedStock == StockType.buy ||
                          _selectedStock == StockType.short)
                      ? (invested > _availableBalance || invested == 0)
                      : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0)))
                  ? null
                  : () {
                      if (stopPriceController.text.isEmpty ||
                          num.parse(stopPriceController.text) == 0.0) {
                        popUpAlert(
                          message: "Stop price can't be empty",
                          title: "Alert",
                          icon: Images.alertPopGIF,
                        );
                        return;
                      } else if (limitPriceController.text.isEmpty ||
                          num.parse(limitPriceController.text) == 0.0) {
                        popUpAlert(
                          message: "Limit price can't be empty",
                          title: "Alert",
                          icon: Images.alertPopGIF,
                        );
                        return;
                      } else {
                        _onTap();
                      }
                    },
            ),
          ),
          Visibility(
            visible: widget.conditionalType == ConditionType.trailingOrder,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: "Proceed Trailing Order",
              color: (_selectedStock == StockType.buy ||
                      _selectedStock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedStock == StockType.buy ||
                          _selectedStock == StockType.short)
                      ? (invested > _availableBalance || invested == 0)
                      : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0)))
                  ? null
                  : () {
                      if (stopPriceController.text.isEmpty ||
                          num.parse(stopPriceController.text) == 0.0) {
                        popUpAlert(
                          message: "Trail price can't be empty",
                          title: "Alert",
                          icon: Images.alertPopGIF,
                        );
                        return;
                      } else {
                        _onTap();
                      }
                    },
            ),
          ),
          Visibility(
            visible: controller.text.isNotEmpty &&
                (_selectedStock == StockType.buy ||
                    _selectedStock == StockType.short) &&
                (invested > _availableBalance),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current balance is ',
                  style: stylePTSansRegular(color: ThemeColors.neutral40),
                  children: [
                    TextSpan(
                      text: _availableBalance.toFormattedPrice(),
                      style: stylePTSansBold(
                          color: ThemeColors.splashBG, fontSize: 14),
                    ),
                    TextSpan(
                        style: stylePTSansRegular(color: ThemeColors.neutral40),
                        text:
                            '. You cannot purchase shares with an order value that exceeds your available balance.')
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: controller.text.isNotEmpty &&
                (_selectedStock == StockType.sell ||
                    _selectedStock == StockType.btc) &&
                num.parse(controller.text) > (widget.qty ?? 0),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current share holding is ',
                  style: stylePTSansRegular(color: ThemeColors.neutral40),
                  children: [
                    TextSpan(
                      text: '${widget.qty}',
                      style: stylePTSansBold(
                          color: ThemeColors.splashBG, fontSize: 14),
                    ),
                    TextSpan(
                        style: stylePTSansRegular(color: ThemeColors.neutral40),
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

  Future onTap({ConditionType? cType, StockType? selectedStock}) async {
     openInfoSheet(cType,selectedStock);
  }

  @override
  Widget build(BuildContext context) {
    PortfolioManager portfolioManager = context.read<PortfolioManager>();
    if (widget.tradeType != null) {
      selectedIndex =
          menus.indexWhere((element) => element == widget.tradeType);
      _selectedStock = selectedIndex == 0
          ? StockType.buy
          : selectedIndex == 1
              ? StockType.short
              : selectedIndex == 2
                  ? StockType.sell
                  : StockType.btc;
    }
    print(selectedIndex);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const STopWidget(),
                  GestureDetector(
                    onTap: (){
                      onTap(cType: widget.conditionalType,selectedStock: _selectedStock);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.conditionalType == ConditionType.bracketOrder
                              ? 'BRACKET ORDER': widget.conditionalType == ConditionType.limitOrder ?'LIMIT ORDER':
                          widget.conditionalType == ConditionType.stopOrder ? "STOP ORDER":
                          widget.conditionalType == ConditionType.stopLimitOrder?"STOP LIMIT ORDER":"TRAILING ORDER",
                          style: stylePTSansBold(
                            color: ThemeColors.splashBG,
                            fontSize: 12,
                          ),
                        ),
                        SpacerHorizontal(width: 5),
                        Icon(Icons.info_sharp,color: ThemeColors.splashBG,size: 18)
                      ],
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  const SpacerVertical(height: 5),
                  Container(
                    width: 110,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            ThemeColors.neutral40,
                            ThemeColors.splashBG,
                          ],
                        )),
                    child: Center(
                      child: Text(
                        selectedIndex == 0
                            ? "Buy"
                            : selectedIndex == 1
                                ? "Short"
                                : selectedIndex == 2
                                    ? "Sell"
                                    : "Buy to Cover",
                        style: styleGeorgiaBold(
                            fontSize: 15, color: ThemeColors.white),
                      ),
                    ),
                  ),
                  Visibility(child: const SpacerVertical(height: Pad.pad10)),
                  Text(
                    'Enter number of shares',
                    style: styleGeorgiaRegular(color: ThemeColors.neutral80,fontSize: 18),
                  ),
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
                    visible: widget.conditionalType == ConditionType.limitOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Limit Price",
                          style: stylePTSansBold(color: ThemeColors.splashBG),
                          subTitle: selectedIndex == 0
                              ? portfolioManager
                                      .userData
                                      ?.userDataRes
                                      ?.labelInfoStrings
                                      ?.buy
                                      ?.limitOrder
                                      ?.limitPrice ??
                                  ""
                              : selectedIndex == 1
                                  ? portfolioManager
                                          .userData
                                          ?.userDataRes
                                          ?.labelInfoStrings
                                          ?.short
                                          ?.limitOrder
                                          ?.limitPrice ??
                                      ""
                                  : selectedIndex == 2
                                      ? portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.sell
                                              ?.limitOrder
                                              ?.limitPrice ??
                                          ""
                                      : portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.buyToCover
                                              ?.limitOrder
                                              ?.limitPrice ??
                                          "",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: ThemeColors.neutral6,
                          fillColor: ThemeColors.neutral5,
                          borderColor: ThemeColors.neutral5,
                          style:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          controller: limitPriceController,
                          placeholder: "Limit Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.conditionalType == ConditionType.stopOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Stop Price",
                          style: stylePTSansBold(color: ThemeColors.splashBG),
                          subTitle: selectedIndex == 0
                              ? portfolioManager
                                      .userData
                                      ?.userDataRes
                                      ?.labelInfoStrings
                                      ?.buy
                                      ?.stopOrder
                                      ?.stopPrice ??
                                  ""
                              : selectedIndex == 1
                                  ? portfolioManager
                                          .userData
                                          ?.userDataRes
                                          ?.labelInfoStrings
                                          ?.short
                                          ?.stopOrder
                                          ?.stopPrice ??
                                      ""
                                  : selectedIndex == 2
                                      ? portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.sell
                                              ?.stopOrder
                                              ?.stopPrice ??
                                          ""
                                      : portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.buyToCover
                                              ?.stopOrder
                                              ?.stopPrice ??
                                          "",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: ThemeColors.neutral6,
                          fillColor: ThemeColors.neutral5,
                          borderColor: ThemeColors.neutral5,
                          style:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          controller: stopPriceController,
                          placeholder: "Stop Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        widget.conditionalType == ConditionType.stopLimitOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Stop Price",
                          style: stylePTSansBold(color: ThemeColors.splashBG),
                          subTitle: selectedIndex == 0
                              ? portfolioManager
                                      .userData
                                      ?.userDataRes
                                      ?.labelInfoStrings
                                      ?.buy
                                      ?.stopLimitOrder
                                      ?.stopPrice ??
                                  ""
                              : selectedIndex == 1
                                  ? portfolioManager
                                          .userData
                                          ?.userDataRes
                                          ?.labelInfoStrings
                                          ?.short
                                          ?.stopLimitOrder
                                          ?.stopPrice ??
                                      ""
                                  : selectedIndex == 2
                                      ? portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.sell
                                              ?.stopLimitOrder
                                              ?.stopPrice ??
                                          ""
                                      : portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.buyToCover
                                              ?.stopLimitOrder
                                              ?.stopPrice ??
                                          "",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: ThemeColors.neutral6,
                          fillColor: ThemeColors.neutral5,
                          borderColor: ThemeColors.neutral5,
                          style:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          controller: stopPriceController,
                          placeholder: "Stop Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SpacerVertical(),
                        ScreenTitle(
                          title: "Limit Price",
                          style: stylePTSansBold(color: ThemeColors.splashBG),
                          subTitle: selectedIndex == 0
                              ? portfolioManager
                                      .userData
                                      ?.userDataRes
                                      ?.labelInfoStrings
                                      ?.buy
                                      ?.stopLimitOrder
                                      ?.limitPrice ??
                                  ""
                              : selectedIndex == 1
                                  ? portfolioManager
                                          .userData
                                          ?.userDataRes
                                          ?.labelInfoStrings
                                          ?.short
                                          ?.stopLimitOrder
                                          ?.limitPrice ??
                                      ""
                                  : selectedIndex == 2
                                      ? portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.sell
                                              ?.stopLimitOrder
                                              ?.limitPrice ??
                                          ""
                                      : portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.buyToCover
                                              ?.stopLimitOrder
                                              ?.limitPrice ??
                                          "",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: ThemeColors.neutral6,
                          fillColor: ThemeColors.neutral5,
                          borderColor: ThemeColors.neutral5,
                          style:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          controller: limitPriceController,
                          placeholder: "Limit Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        widget.conditionalType == ConditionType.trailingOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Trail Price",
                          style: stylePTSansBold(color: ThemeColors.splashBG),
                          subTitle: selectedIndex == 0
                              ? portfolioManager
                                      .userData
                                      ?.userDataRes
                                      ?.labelInfoStrings
                                      ?.buy
                                      ?.trailingOrder
                                      ?.stopPrice ??
                                  ""
                              : selectedIndex == 1
                                  ? portfolioManager
                                          .userData
                                          ?.userDataRes
                                          ?.labelInfoStrings
                                          ?.short
                                          ?.trailingOrder
                                          ?.stopPrice ??
                                      ""
                                  : selectedIndex == 2
                                      ? portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.sell
                                              ?.trailingOrder
                                              ?.stopPrice ??
                                          ""
                                      : portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.buyToCover
                                              ?.trailingOrder
                                              ?.stopPrice ??
                                          "",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: ThemeColors.neutral6,
                          fillColor: ThemeColors.neutral5,
                          borderColor: ThemeColors.neutral5,
                          style:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              stylePTSansRegular(color: ThemeColors.splashBG),
                          controller: stopPriceController,
                          placeholder: "Trail Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
