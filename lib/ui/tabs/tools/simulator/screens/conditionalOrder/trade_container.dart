import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_open.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_pending.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_open_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/show_conditional_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/widgert/trade_custome_sliding.dart';
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

class ConditionalContainer extends StatefulWidget {
  final num? qty;
  final num? editTradeID;
  final ConditionType? conditionalType;
  final int? tickerID;

  const ConditionalContainer(
      {super.key,
      this.conditionalType,
      this.qty,
      this.editTradeID,
      this.tickerID});

  @override
  State<ConditionalContainer> createState() => _ConditionalContainerState();
}

class _ConditionalContainerState extends State<ConditionalContainer> {
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
  ];

  List<String> editedMenus = [
    'Buy',
    'Short',
    'Sell',
    'But to Cover',
  ];

  @override
  void initState() {
    super.initState();
    Utils().showLog(
        "ORDER DATA => ${widget.tickerID}, ${widget.qty}, ${widget.conditionalType}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      _availableBalance = context
              .read<PortfolioManager>()
              .userData
              ?.userDataRes
              ?.tradeBalance ??
          0;
      if (widget.tickerID != null) {
        TsOpenListRes? data = context
            .read<SOpenManager>()
            .data
            ?.firstWhere((ele) => ele.id == widget.tickerID);
        if (data != null) {
          Utils().showLog("BRACKET ORDER DATA => ${data.toJson()}");
          setState(() {
            _currentText = widget.qty.toString();
            controller.text = widget.qty.toString();
            selectedIndex = menus.indexWhere(
              (element) => element == data.tradeType,
            );
            Utils().showLog("selectedIndex => $selectedIndex");
          });
        }
      } else if (widget.editTradeID != null) {
        TsPendingListRes? data = context
            .read<SPendingManager>()
            .data
            ?.firstWhere((ele) => ele.id == widget.editTradeID);
        if (data != null) {
          Utils().showLog("ORDER DATA => ${data.toJson()}");
          setState(() {
            _currentText = (data.quantity ?? 0).toString();
            controller.text = _currentText;
            targetPriceController.text = data.targetPrice.toString();
            stopPriceController.text = data.stopPrice.toString();
            limitPriceController.text = data.limitPrice.toString();
            selectedIndex = editedMenus.indexWhere(
              (element) => element == data.tradeType,
            );
            _selectedTock = selectedIndex == 0
                ? StockType.buy
                : selectedIndex == 1
                    ? StockType.short
                    : selectedIndex == 2
                        ? StockType.sell
                        : StockType.btc;
            Utils().showLog("selectedIndex => $selectedIndex");
          });
        }
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

    if (widget.editTradeID != null) {
      final Map<String, dynamic> request = {
        // "token":
        //     navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
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
      ApiResponse response = await manager.requestUpdateShare(
        id: widget.editTradeID ?? 0,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        //context.read<TsPendingListProvider>().getData();

        final order = SummaryOrderNew(
          isShare: _selectedSegment == TypeTrade.shares,
          dollars: _selectedSegment == TypeTrade.dollar
              ? num.parse(_currentText)
              : (num.parse(_currentText) * (detailRes?.price ?? 0)),
          shares: _selectedSegment == TypeTrade.shares
              ? num.parse(_currentText)
              : (num.parse(_currentText) / (detailRes?.price ?? 0)),
          image: detailRes?.image,
          name: detailRes?.name,
          price: null,
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
        // Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,
        //     arguments: {"initialIndex": 1});

        Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path,
            arguments: {
              'index': 2,
              'childIndex': 1,
            });
        _clear();
        await showCOrderSuccessSheet(order, widget.conditionalType);
      } else {
        popUpAlert(
          message: "${response.message}",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }

      return;
    }

    if (widget.tickerID != null) {
      final Map<String, dynamic> request = {
        // "token":
        //     navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "order_type": 'BRACKET_ORDER',
        "target_price": targetPriceController.text,
        "stop_price": stopPriceController.text
      };
      ApiResponse response = await manager.tsAddConditional(
          request, widget.tickerID!.toInt(),
          showProgress: true);
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
        );
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,
        //     arguments: {"initialIndex": isPending ? 1 : 0});

        Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path,
            arguments: {
              'index': 2,
              'childIndex': isPending ? 1 : 0,
            });
        _clear();

        await showCOrderSuccessSheet(order, widget.conditionalType);
      } else {
        popUpAlert(
          message: "${response.message}",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }
    } else {
      if (_selectedTock == StockType.buy) {
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
            // "token":
            //     navigatorKey.currentContext!.read<UserProvider>().user?.token ??
            //         "",
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
            // Navigator.pushNamed(
            //     navigatorKey.currentContext!, SimulatorIndex.path,
            //     arguments: {"initialIndex": isPending ? 1 : 0});

            Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path,
                arguments: {
                  'index': 2,
                  'childIndex': isPending ? 1 : 0,
                });

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
          "action": _selectedTock == StockType.short
              ? "SHORT"
              : _selectedTock == StockType.sell
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
          // "token":
          //     navigatorKey.currentContext!.read<UserProvider>().user?.token ??
          //         "",
          "action": _selectedTock == StockType.short
              ? "SHORT"
              : _selectedTock == StockType.sell
                  ? "SELL"
                  : "BUY_TO_COVER",
          "symbol": detailRes?.symbol,
          "order_type":  widget.conditionalType == ConditionType.bracketOrder
              ? 'BRACKET_ORDER': widget.conditionalType == ConditionType.limitOrder
              ?'LIMIT_ORDER':
          widget.conditionalType == ConditionType.stopOrder ? "STOP_ORDER":
          widget.conditionalType == ConditionType.stopLimitOrder?"STOP_LIMIT_ORDER":"TRAILING_ORDER",
          "duration": "GOOD_UNTIL_CANCELLED",
          "quantity": controller.text,
          "target_price": targetPriceController.text,
          "stop_price": stopPriceController.text,
          "limit_price": limitPriceController.text,
        });*/

        ApiResponse response =
            await manager.requestSellShare(request, showProgress: true);
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
          _clear();
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          // Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,
          //     arguments: {"initialIndex": isPending ? 1 : 0});

          Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path,
              arguments: {
                'index': 2,
                'childIndex': isPending ? 1 : 0,
              });

          await showCOrderSuccessSheet(order, widget.conditionalType);
        } else {
          popUpAlert(message: "${response.message}", title: "Alert");
        }
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

  Future onTap({ConditionType? cType, StockType? selectedStock}) async {
    openInfoSheet(cType, selectedStock);
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
                        style: styleBaseRegular(
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
                        style: styleBaseBold(
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
                        style: styleBaseRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height: Pad.pad10),
                      Text(
                        "\$${invested.toCurrency()}",
                        style: styleBaseBold(
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
            visible: widget.conditionalType == ConditionType.bracketOrder,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: widget.editTradeID != null
                  ? 'Update Bracket Order'
                  : "Proceed Bracket Order",
              color: (invested > _availableBalance || invested == 0)
                  ? ThemeColors.neutral5
                  : ThemeColors.primary100,
              onPressed: (invested > _availableBalance || invested == 0)
                  ? null
                  : () {
                      if (targetPriceController.text.isEmpty ||
                          num.parse(targetPriceController.text) == 0.0) {
                        popUpAlert(
                          message: "Target price can't be empty",
                          title: "Alert",
                          icon: Images.alertPopGIF,
                        );
                        return;
                      } else if (stopPriceController.text.isEmpty ||
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
            visible: widget.conditionalType == ConditionType.limitOrder,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: widget.editTradeID != null
                  ? 'Update Limit Order'
                  : "Proceed Limit Order",
              color: (_selectedTock == StockType.buy ||
                      _selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedTock == StockType.buy ||
                          _selectedTock == StockType.short)
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
              text: widget.editTradeID != null
                  ? 'Update Stop Order'
                  : "Proceed Stop Order",
              color: (_selectedTock == StockType.buy ||
                      _selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedTock == StockType.buy ||
                          _selectedTock == StockType.short)
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
              text: widget.editTradeID != null
                  ? 'Update Stop Limit Order'
                  : "Proceed Stop Limit Order",
              color: (_selectedTock == StockType.buy ||
                      _selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedTock == StockType.buy ||
                          _selectedTock == StockType.short)
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
              text: widget.editTradeID != null
                  ? 'Update Trailing Order'
                  : "Proceed Trailing Order",
              color: (_selectedTock == StockType.buy ||
                      _selectedTock == StockType.short)
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: ((_selectedTock == StockType.buy ||
                          _selectedTock == StockType.short)
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
                (_selectedTock == StockType.buy ||
                    _selectedTock == StockType.short) &&
                (invested > _availableBalance),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current balance is ',
                  style: styleBaseRegular(color: ThemeColors.neutral40),
                  children: [
                    TextSpan(
                      text: _availableBalance.toFormattedPrice(),
                      style: styleBaseBold(
                          color: ThemeColors.splashBG, fontSize: 14),
                    ),
                    TextSpan(
                        style: styleBaseRegular(color: ThemeColors.neutral40),
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
                num.parse(controller.text) > (widget.qty ?? 0),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current share holding is ',
                  style: styleBaseRegular(color: ThemeColors.neutral40),
                  children: [
                    TextSpan(
                      text: '${widget.qty}',
                      style: styleBaseBold(
                          color: ThemeColors.splashBG, fontSize: 14),
                    ),
                    TextSpan(
                        style: styleBaseRegular(color: ThemeColors.neutral40),
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
    PortfolioManager portfolioManager = context.read<PortfolioManager>();
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
                    onTap: () {
                      onTap(
                          cType: widget.conditionalType,
                          selectedStock: _selectedTock);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.conditionalType == ConditionType.bracketOrder
                              ? 'BRACKET ORDER'
                              : widget.conditionalType ==
                                      ConditionType.limitOrder
                                  ? 'LIMIT ORDER'
                                  : widget.conditionalType ==
                                          ConditionType.stopOrder
                                      ? "STOP ORDER"
                                      : widget.conditionalType ==
                                              ConditionType.stopLimitOrder
                                          ? "STOP LIMIT ORDER"
                                          : "TRAILING ORDER",
                          style: styleBaseBold(
                            color: ThemeColors.splashBG,
                            fontSize: 12,
                          ),
                        ),
                        SpacerHorizontal(width: 5),
                        Icon(Icons.info_sharp,
                            color: ThemeColors.splashBG, size: 18)
                      ],
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  Visibility(
                    visible:
                        widget.tickerID == null && widget.editTradeID == null,
                    child: TradeCustomeSliding(
                      menus: menus,
                      onValueChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                          _selectedTock = selectedIndex == 0
                              ? StockType.buy
                              : StockType.short;
                        });
                      },
                      selectedIndex: selectedIndex,
                    ),
                  ),
                  Visibility(
                      visible: widget.tickerID == null,
                      child: const SpacerVertical(height: 15)),
                  Text(
                    'Enter number of shares',
                    style: styleBaseRegular(
                        color: ThemeColors.neutral80, fontSize: 18),
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
                    readOnly: (widget.tickerID == null ? false : true),
                  ),
                  if (widget.qty != null)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Available quantity - ${widget.qty ?? 0}',
                        style: styleBaseBold(),
                      ),
                    ),
                  Visibility(
                    visible:
                        widget.conditionalType == ConditionType.bracketOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Target Price",
                          style: styleBaseBold(color: ThemeColors.splashBG),
                          subTitle: selectedIndex == 0
                              ? portfolioManager
                                      .userData
                                      ?.userDataRes
                                      ?.labelInfoStrings
                                      ?.buy
                                      ?.bracketOrder
                                      ?.targetPrice ??
                                  ""
                              : selectedIndex == 1
                                  ? portfolioManager
                                          .userData
                                          ?.userDataRes
                                          ?.labelInfoStrings
                                          ?.short
                                          ?.bracketOrder
                                          ?.targetPrice ??
                                      ""
                                  : selectedIndex == 2
                                      ? portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.sell
                                              ?.bracketOrder
                                              ?.targetPrice ??
                                          ""
                                      : portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.buyToCover
                                              ?.bracketOrder
                                              ?.targetPrice ??
                                          "",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: ThemeColors.neutral6,
                          fillColor: ThemeColors.neutral5,
                          borderColor: ThemeColors.neutral5,
                          style: styleBaseRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              styleBaseRegular(color: ThemeColors.splashBG),
                          controller: targetPriceController,
                          placeholder: "Target Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SpacerVertical(),
                        ScreenTitle(
                          title: "Stop Price",
                          style: styleBaseBold(color: ThemeColors.splashBG),
                          subTitle: selectedIndex == 0
                              ? portfolioManager
                                      .userData
                                      ?.userDataRes
                                      ?.labelInfoStrings
                                      ?.buy
                                      ?.bracketOrder
                                      ?.stopPrice ??
                                  ""
                              : selectedIndex == 1
                                  ? portfolioManager
                                          .userData
                                          ?.userDataRes
                                          ?.labelInfoStrings
                                          ?.short
                                          ?.bracketOrder
                                          ?.stopPrice ??
                                      ""
                                  : selectedIndex == 2
                                      ? portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.sell
                                              ?.bracketOrder
                                              ?.stopPrice ??
                                          ""
                                      : portfolioManager
                                              .userData
                                              ?.userDataRes
                                              ?.labelInfoStrings
                                              ?.buyToCover
                                              ?.bracketOrder
                                              ?.stopPrice ??
                                          "",
                          dividerPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        ThemeInputField(
                          cursorColor: ThemeColors.neutral6,
                          fillColor: ThemeColors.neutral5,
                          borderColor: ThemeColors.neutral5,
                          style: styleBaseRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              styleBaseRegular(color: ThemeColors.splashBG),
                          controller: stopPriceController,
                          placeholder: "Stop Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.conditionalType == ConditionType.limitOrder,
                    child: Column(
                      children: [
                        ScreenTitle(
                          title: "Limit Price",
                          style: styleBaseBold(color: ThemeColors.splashBG),
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
                          style: styleBaseRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              styleBaseRegular(color: ThemeColors.splashBG),
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
                          style: styleBaseBold(color: ThemeColors.splashBG),
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
                          style: styleBaseRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              styleBaseRegular(color: ThemeColors.splashBG),
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
                          style: styleBaseBold(color: ThemeColors.splashBG),
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
                          style: styleBaseRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              styleBaseRegular(color: ThemeColors.splashBG),
                          controller: stopPriceController,
                          placeholder: "Stop Price",
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SpacerVertical(),
                        ScreenTitle(
                          title: "Limit Price",
                          style: styleBaseBold(color: ThemeColors.splashBG),
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
                          style: styleBaseRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              styleBaseRegular(color: ThemeColors.splashBG),
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
                          title: "Trailing Stop Loss",
                          style: styleBaseBold(color: ThemeColors.splashBG),
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
                          style: styleBaseRegular(color: ThemeColors.splashBG),
                          hintStyle:
                              styleBaseRegular(color: ThemeColors.splashBG),
                          controller: stopPriceController,
                          placeholder: "Trailing Stop Loss",
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
