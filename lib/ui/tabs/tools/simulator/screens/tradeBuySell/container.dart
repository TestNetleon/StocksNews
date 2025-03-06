import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/sheet/sucess_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/s_top.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BuySellContainer extends StatefulWidget {
  final StockType? selectedStock;
  final num? qty;
  final num? editTradeID;

  const BuySellContainer({
    super.key,
    this.selectedStock,
    this.qty,
    this.editTradeID,
  });

  @override
  State<BuySellContainer> createState() => _BuySellContainerState();
}

class _BuySellContainerState extends State<BuySellContainer> {
  TextEditingController controller = TextEditingController();
  TextEditingController limitController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  TextEditingController stopLossController = TextEditingController();

  TypeTrade _selectedSegment = TypeTrade.shares;
  FocusNode focusNode = FocusNode();
  String _currentText = "0";
  String _lastEntered = "";
  String _previousText = "";
  int _keyCounter = 0;
  num _availableBalance = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      _availableBalance =
          context.read<PortfolioManager>().userData?.userDataRes?.tradeBalance ?? 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    limitController.dispose();
    targetController.dispose();
    stopLossController.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    super.dispose();
  }

  _onTap() async {
    closeKeyboard();
    TradeManager manager = context.read<TradeManager>();
    BaseTickerRes? detailRes = manager.detailRes;

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
    TradeManager manager = context.read<TradeManager>();
    PortfolioManager portfolioManager = context.read<PortfolioManager>();
    BaseTickerRes? detailRes = manager.detailRes;

    num invested = _selectedSegment == TypeTrade.shares
        ? (detailRes?.price ?? 0) * num.parse(_currentText)
        : num.parse(_currentText);
    if (widget.editTradeID != null) {
      final Map<String, dynamic> request = {
        "quantity": controller.text,
        "order_type": 'MARKET_ORDER',
        "duration": "GOOD_UNTIL_CANCELLED"
      };
      ApiResponse response = await manager.requestUpdateShare(
        id: widget.editTradeID ?? 0,
        request: request,
        showProgress: true,
      );
      if (response.status) {
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
          selectedStock: widget.selectedStock,
          date: response.data['result']['created_date'],
        );
        Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,arguments: {"initialIndex":1});

        _clear();
        await showTsOrderSuccessSheet(order, widget.selectedStock);
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

    if (widget.selectedStock == StockType.buy) {
      if (invested > (portfolioManager.userData?.userDataRes?.tradeBalance ?? 0)) {
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
          "order_type": 'MARKET_ORDER',
          "duration": "GOOD_UNTIL_CANCELLED"

        };

        ApiResponse response = await manager.requestBuyShare(request, showProgress: true);
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
            // price: numPrice?.toFormattedPrice(),
            currentPrice: numPrice,
            symbol: detailRes?.symbol,
            invested: invested,
            selectedStock: widget.selectedStock,
            date: response.data['result']['created_date'],
          );
          Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,arguments: {"initialIndex":isPending ?1:0});

          _clear();
          await showTsOrderSuccessSheet(order, widget.selectedStock);
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
        "action": widget.selectedStock == StockType.sell
            ? "SELL"
            : widget.selectedStock == StockType.short
            ? "SHORT"
            : "BUY_TO_COVER",
        "symbol": detailRes?.symbol,
        "order_type": 'MARKET_ORDER',
        "duration": "GOOD_UNTIL_CANCELLED",
        "quantity": controller.text,

      };
     /* FormData request = FormData.fromMap({
        // "token":
        //     navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "action": widget.selectedStock == StockType.sell
            ? "SELL"
            : widget.selectedStock == StockType.short
                ? "SHORT"
                : "BUY_TO_COVER",
        "symbol": detailRes?.symbol,
        "order_type": 'MARKET_ORDER',
        "duration": "GOOD_UNTIL_CANCELLED",
        "quantity": controller.text, //entered value
      });*/

      ApiResponse response = await manager.requestSellShare(request, showProgress: true);
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
          selectedStock: widget.selectedStock,
          date: response.data['result']['created_date'],
        );

        _clear();
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,arguments: {"initialIndex":isPending ?1:0});

        await showTsOrderSuccessSheet(order, widget.selectedStock);
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
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Balance',
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height:  Pad.pad10),
                      Text(
                        portfolioManager.userData?.userDataRes?.tradeBalance != null
                            ? "\$${formatBalance(num.parse(portfolioManager.userData!.userDataRes!.tradeBalance.toCurrency()))}"
                            : '\$0',
                        style: stylePTSansBold(
                            fontSize: 16,
                            color: ThemeColors.splashBG
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpacerHorizontal(width: Pad.pad10),
              Expanded(
                child:
                CommonCard(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Order Value',
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height:  Pad.pad10),
                      Text(
                        "\$${invested.toCurrency()}",
                        style: stylePTSansBold(
                            fontSize: 16,
                            color: ThemeColors.splashBG
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SpacerVertical(height: Pad.pad10),
          Visibility(
            visible: widget.selectedStock != StockType.short,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: widget.selectedStock == StockType.buy
                  ? widget.editTradeID != null
                      ? 'Update Buy Order'
                      : "Proceed Buy Order"
                  : widget.selectedStock == StockType.sell
                      ? widget.editTradeID != null
                          ? 'Update Sell Order'
                          : "Proceed Sell Order"
                      : widget.editTradeID != null
                          ? 'Update Buy to Cover Order'
                          : "Proceed Buy to Cover Order",
              color: widget.selectedStock == StockType.buy
                  ? (invested > _availableBalance || invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100
                  : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0) ||
                          invested == 0)
                      ? ThemeColors.neutral5
                      : ThemeColors.primary100,
              onPressed: (widget.selectedStock == StockType.buy
                      ? (invested > _availableBalance || invested == 0)
                      : (controller.text.isEmpty ||
                          num.parse(controller.text) > (widget.qty ?? 0)))
                  ? null
                  : _onTap,
            ),
          ),
          Visibility(
            visible: widget.selectedStock == StockType.short,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.neutral5,
              disableTextColor: ThemeColors.black,
              textColor: ThemeColors.splashBG,
              text: widget.editTradeID != null
                  ? 'Update Short Order'
                  : "Proceed Short Order",
              color: (invested > _availableBalance || invested == 0)
                  ? ThemeColors.neutral5
                  : (controller.text.isEmpty)
                      ? ThemeColors.neutral5
                  : ThemeColors.primary100,
              onPressed: (invested > _availableBalance || invested == 0)
                  ? null
                  : (controller.text.isEmpty)
                      ? null
                      : _onTap,
            ),
          ),
          Visibility(
            visible: controller.text.isNotEmpty &&
                (widget.selectedStock == StockType.buy ||
                    widget.selectedStock == StockType.short) &&
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
                (widget.selectedStock == StockType.sell ||
                    widget.selectedStock == StockType.btc) &&
                num.parse(controller.text) > (widget.qty ?? 0),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current share holding is ',
                  style: stylePTSansRegular(color:ThemeColors.neutral40),
                  children: [
                    TextSpan(
                      text: '${widget.qty}',
                      style: stylePTSansBold(
                          color: ThemeColors.splashBG, fontSize: 14),
                    ),
                    TextSpan(
                        style:
                        stylePTSansRegular(color: ThemeColors.neutral40),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const STopWidget(),
                  SpacerVertical(),
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

                  if (widget.qty != null &&
                      widget.selectedStock != StockType.short)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Available quantity - ${widget.qty ?? 0}',
                        style: styleGeorgiaBold(),
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
