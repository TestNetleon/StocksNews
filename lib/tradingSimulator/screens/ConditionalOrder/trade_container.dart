import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us_item.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_topbar.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_pending_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/ConditionalOrder/show_conditional_sheet.dart';
import 'package:stocks_news_new/tradingSimulator/screens/ConditionalOrder/widgert/trade_custome_sliding.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/detailTop/top.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';


class ConditionalContainer extends StatefulWidget {
  final num? qty;
  final num? editTradeID;
  final ConditionType? conditionalType;

  const ConditionalContainer({
    super.key,
    this.conditionalType,
    this.qty,
    this.editTradeID,
  });

  @override
  State<ConditionalContainer> createState() => _ConditionalContainerState();
}

class _ConditionalContainerState extends State<ConditionalContainer> {
  TextEditingController controller = TextEditingController();
  TextEditingController targetPriceController = TextEditingController();
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      _availableBalance =
          context.read<TsPortfolioProvider>().userData?.tradeBalance ?? 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    targetPriceController.dispose();
    stopPriceController.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    super.dispose();
  }

  _onTap() async {
    closeKeyboard();
    TradeProviderNew provider = context.read<TradeProviderNew>();
    TsStockDetailRes? detailRes = provider.detailRes;

    if (detailRes?.executable == false && widget.editTradeID == null) {
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
    if (widget.editTradeID != null) {
      final Map<String, dynamic> request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "quantity": controller.text,
        "order_type": 'MARKET_ORDER',
        "duration": "GOOD_UNTIL_CANCELLED"
      };
      ApiResponse response = await provider.requestUpdateShare(
        id: widget.editTradeID ?? 0,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        context.read<TsPendingListProvider>().getData();

        final order = SummaryOrderNew(
          isShare: _selectedSegment == TypeTrade.shares,
          dollars: _selectedSegment == TypeTrade.dollar
              ? num.parse(_currentText)
              : (num.parse(_currentText) * (detailRes?.currentPrice ?? 0)),
          shares: _selectedSegment == TypeTrade.shares
              ? num.parse(_currentText)
              : (num.parse(_currentText) / (detailRes?.currentPrice ?? 0)),
          image: detailRes?.image,
          name: detailRes?.company,
          // price: '${detailRes?.currentPrice?.toFormattedPrice()}',
          price: null,

          symbol: detailRes?.symbol,
          invested: invested,
          //selectedStock: widget.selectedStock,
          date: response.data['result']['created_date'],
        );
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => TsDashboard(initialIndex: 1),
          ),
        );
        _clear();
       // await showTsOrderSuccessSheet(order, widget.selectedStock);
      } else {
        popUpAlert(
          message: "${response.message}",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }

      return;
    }
    closeKeyboard();
    if (controller.text.isEmpty || num.parse(controller.text) == 0.0) {
      popUpAlert(
        message: "Value can't be empty",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    if (targetPriceController.text.isEmpty || num.parse(targetPriceController.text) == 0.0) {
      popUpAlert(
        message: "Target price can't be empty",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    if (stopPriceController.text.isEmpty || num.parse(stopPriceController.text) == 0.0) {
      popUpAlert(
        message: "Stop price can't be empty",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    if (_selectedTock==StockType.buy) {
      if (invested > (portfolioProvider.userData?.tradeBalance ?? 0)) {
        popUpAlert(
          message: "Insufficient available balance to place this order.",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
        return;
      } else {
        final Map<String, dynamic> request = {
          "token": navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
          "action": "BUY",
          "symbol": detailRes?.symbol,
          "quantity": controller.text,
          "order_type": 'BRACKET_ORDER',
          "duration": "GOOD_UNTIL_CANCELLED",
          "target_price":targetPriceController.text,
          "stop_price": stopPriceController.text

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
            // price: numPrice?.toFormattedPrice(),
            currentPrice: numPrice,
            symbol: detailRes?.symbol,
            invested: invested,
            date: response.data['result']['created_date'],
          );
         // await Future.delayed(Duration(seconds: 1));
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
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "action": _selectedTock==StockType.short
            ? "SHORT"
            : _selectedTock==StockType.sell
                ? "SELL"
                : "BUY_TO_COVER",
        "symbol": detailRes?.symbol,
        "order_type":  widget.conditionalType == ConditionType.bracketOrder?'BRACKET_ORDER':"",
        "duration": "GOOD_UNTIL_CANCELLED",
        "quantity": controller.text,
        "target_price":targetPriceController.text,
        "stop_price": stopPriceController.text
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
          // price: numPrice?.toFormattedPrice(),
          currentPrice: numPrice,
          symbol: detailRes?.symbol,
          invested: invested,
         // selectedStock: widget.selectedStock,
          date: response.data['result']['created_date'],
        );

        _clear();
       // await Future.delayed(Duration(seconds: 1));
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
          ThemeButton(
            disabledBackgroundColor: ThemeColors.greyBorder,
            text:widget.editTradeID != null
                ? 'Update Bracket Order'
                : "Proceed Bracket Order",
            color: (invested > _availableBalance || invested == 0)
                ? ThemeColors.greyText
                : ThemeColors.accent,
            onPressed:
            (invested > _availableBalance || invested == 0)?null:
            _onTap,
          ),
          Visibility(
            visible: controller.text.isNotEmpty && (_selectedTock==StockType.buy ||_selectedTock==StockType.short) && (invested > _availableBalance),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  TradeCustomeSliding(
                    menus: menus,
                    onValueChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                        _selectedTock=selectedIndex==0?StockType.buy:StockType.short;
                      });

                    },
                    selectedIndex: selectedIndex,
                  ),
                  const SpacerVertical(height: 5),
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
                  Align(alignment:Alignment.centerLeft,child: showAsteriskText(text: "Target Price", bold: true,showAsterisk: false)),
                  const SpacerVertical(height: 5),
                  ThemeInputField(
                    cursorColor: Colors.white,
                    fillColor: ThemeColors.primaryLight,
                    borderColor: ThemeColors.primaryLight,
                    controller: targetPriceController,
                    placeholder: "Target Price",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: stylePTSansRegular(color: Colors.white),
                  ),
                  const SpacerVertical(),
                  Align(alignment:Alignment.centerLeft,child: showAsteriskText(text: "Stop Price", bold: true,showAsterisk: false)),
                  const SpacerVertical(height: 5),
                  ThemeInputField(
                    cursorColor: Colors.white,
                    fillColor: ThemeColors.primaryLight,
                    borderColor: ThemeColors.primaryLight,
                    controller: stopPriceController,
                    placeholder: "Stop Price",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: stylePTSansRegular(color: Colors.white),
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
