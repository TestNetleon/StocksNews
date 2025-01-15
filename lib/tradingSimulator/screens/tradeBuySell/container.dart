import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/common_heading.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_pending_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/trade/sheet.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../manager/sse.dart';
import '../../providers/trade_provider.dart';

class BuySellContainer extends StatefulWidget {
  final bool buy;
  final num? qty;
  final num? editTradeID;

  const BuySellContainer({
    super.key,
    this.buy = true,
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
  // bool _limitOrder = false;
  // bool _bracketOrder = false;

  // String text = "";
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
    controller.clear();
    limitController.clear();
    targetController.clear();
    stopLossController.clear();
    SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    super.dispose();
  }

  _calculationsForBUY() {}
  _calculationsForSELL() {}

  _onTap() async {
    closeKeyboard();
    StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;

    if (keyStats?.tradeMarketStatus == false) {
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
    StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
    TradeProviderNew tradeProviderNew = context.read<TradeProviderNew>();
    TsPortfolioProvider portfolioProvider = context.read<TsPortfolioProvider>();

    String cleanedString =
        provider.tabRes?.keyStats?.price?.replaceAll(RegExp(r'[^\d.]'), '') ??
            "";
    num price = num.parse(cleanedString);
    num invested = _selectedSegment == TypeTrade.shares
        ? price * num.parse(_currentText)
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
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "quantity": controller.text,
        "order_type": 'MARKET_ORDER',
        "duration": "GOOD_UNTIL_CANCELLED"
      };
      ApiResponse response = await tradeProviderNew.requestUpdateShare(
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
              : (num.parse(_currentText) * price),
          shares: _selectedSegment == TypeTrade.shares
              ? num.parse(_currentText)
              : (num.parse(_currentText) / price),
          image: provider.tabRes?.companyInfo?.image,
          name: provider.tabRes?.keyStats?.name,
          price: provider.tabRes?.keyStats?.price,
          symbol: provider.tabRes?.keyStats?.symbol,
          invested: invested,
          buy: widget.buy,
          date: response.data['result']['created_date'],
        );
        // Navigator.pop(context);
        // Navigator.pop(context);
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => TsDashboard(initialIndex: 1),
          ),
        );
        _clear();
        // widget.buy
        //     ? tradeProviderNew.addOrderData(order)
        //     : tradeProviderNew.sellOrderData(order);
        await showTsOrderSuccessSheet(order, widget.buy);
      } else {
        popUpAlert(
          message: "${response.message}",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }

      return;
    }

    if (widget.buy) {
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
          "symbol": provider.tabRes?.keyStats?.symbol,
          "quantity": controller.text, //entered value
          "order_type": 'MARKET_ORDER',
          "duration": "GOOD_UNTIL_CANCELLED"
          // "current_price": provider.tabRes?.keyStats?.price
          //         ?.replaceAll(RegExp(r'[^\d.]'), '') ??
          //     "",
          // "type": _selectedSegment == TypeTrade.shares
          //     ? "1"
          //     : "2", // 1 = share , 2 = amount
          // "image": provider.tabRes?.companyInfo?.image, //entered value
        };

        // Conditionally add optional parameters if they have values
        // if (limitController.text.isNotEmpty) {
        //   request["limit_order"] = limitController.text;
        // }

        // if (targetController.text.isNotEmpty) {
        //   request["target_price"] = targetController.text;
        // }

        // if (stopLossController.text.isNotEmpty) {
        //   request["stop_loss"] = stopLossController.text;
        // }

        ApiResponse response =
            await tradeProviderNew.requestBuyShare(request, showProgress: true);
        Utils().showLog('~~~~~${response.status}~~~~');
        if (response.status) {
          context.read<TsPortfolioProvider>().getDashboardData();
          context.read<TsOpenListProvider>().getData();
          // Navigator.pop(context);

          final order = SummaryOrderNew(
            isShare: _selectedSegment == TypeTrade.shares,
            change: provider.tabRes?.keyStats?.changeWithCur,
            changePercentage: provider.tabRes?.keyStats?.changesPercentage,
            dollars: _selectedSegment == TypeTrade.dollar
                ? num.parse(_currentText)
                : (num.parse(_currentText) * price),
            shares: _selectedSegment == TypeTrade.shares
                ? num.parse(_currentText)
                : (num.parse(_currentText) / price),
            image: provider.tabRes?.companyInfo?.image,
            name: provider.tabRes?.keyStats?.name,
            price: provider.tabRes?.keyStats?.price,
            symbol: provider.tabRes?.keyStats?.symbol,
            invested: invested,
            buy: widget.buy,
            date: response.data['result']['created_date'],
          );
          // Navigator.pop(context);
          // Navigator.pop(context);
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => TsDashboard(initialIndex: isPending ? 1 : 0),
            ),
          );
          _clear();
          // widget.buy
          //     ? tradeProviderNew.addOrderData(order)
          //     : tradeProviderNew.sellOrderData(order);
          await showTsOrderSuccessSheet(order, widget.buy);
        } else {
          popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF,
          );
        }
      }
    } else {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "action": "SELL",
        "symbol": provider.tabRes?.keyStats?.symbol,
        "order_type": 'MARKET_ORDER',
        "duration": "GOOD_UNTIL_CANCELLED",
        // "current_price": provider.tabRes?.keyStats?.price
        //         ?.replaceAll(RegExp(r'[^\d.]'), '') ??
        //     "",
        // "type": _selectedSegment == TypeTrade.shares
        //     ? "1"
        //     : "2", // 1 = share , 2 = amount
        "quantity": controller.text, //entered value
        // "image": provider.tabRes?.companyInfo?.image, //entered value
      });

      ApiResponse response =
          await tradeProviderNew.requestSellShare(request, showProgress: true);
      Utils().showLog('~~~~~${response.status}~~~~');

      if (response.status) {
        // context.read<HomeProvider>().getHomeSlider();
        context.read<TsOpenListProvider>().getData();
        final order = SummaryOrderNew(
          isShare: _selectedSegment == TypeTrade.shares,
          change: provider.tabRes?.keyStats?.changeWithCur,
          changePercentage: provider.tabRes?.keyStats?.changesPercentage,
          dollars: _selectedSegment == TypeTrade.dollar
              ? num.parse(_currentText)
              : (num.parse(_currentText) * price),
          shares: _selectedSegment == TypeTrade.shares
              ? num.parse(_currentText)
              : (num.parse(_currentText) / price),
          image: provider.tabRes?.companyInfo?.image,
          name: provider.tabRes?.keyStats?.name,
          price: provider.tabRes?.keyStats?.price,
          symbol: provider.tabRes?.keyStats?.symbol,
          invested: invested,
          buy: widget.buy,
          date: response.data['result']['created_date'],
        );

        _clear();

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TsDashboard(initialIndex: isPending ? 1 : 0),
          ),
        );

        // widget.buy
        //     ? tradeProviderNew.addOrderData(order)
        //     : tradeProviderNew.sellOrderData(order);
        await showTsOrderSuccessSheet(order, widget.buy);
      } else {
        // TODO:
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
    StockDetailProviderNew stockDetailProviderNew =
        context.read<StockDetailProviderNew>();

    TsPortfolioProvider portfolioProvider = context.read<TsPortfolioProvider>();

    String cleanedString = stockDetailProviderNew.tabRes?.keyStats?.price
            ?.replaceAll(RegExp(r'[^\d.]'), '') ??
        "0";
    num price = num.tryParse(cleanedString) ?? 0;

    num parsedCurrentText = num.tryParse(_currentText) ?? 0;
    num invested = _selectedSegment == TypeTrade.shares
        ? price * parsedCurrentText
        : parsedCurrentText;
    Utils().showLog('invested=> $invested');
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
                      ]),
                ),
              ),
            ],
          ),
          const SpacerVertical(),
          ThemeButton(
            disabledBackgroundColor: ThemeColors.greyBorder,
            text: widget.buy
                ? widget.editTradeID != null
                    ? 'Update Buy Order'
                    : "Proceed Buy Order"
                : widget.editTradeID != null
                    ? 'Update Sell Order'
                    : "Proceed Sell Order",
            color: widget.buy
                ? (invested > _availableBalance || invested == 0)
                    ? ThemeColors.greyText
                    : ThemeColors.accent
                : (controller.text.isEmpty ||
                        num.parse(controller.text) > (widget.qty ?? 0) ||
                        invested == 0)
                    ? ThemeColors.greyText
                    : ThemeColors.sos,
            onPressed: (widget.buy
                    ? (invested > _availableBalance || invested == 0)
                    : (controller.text.isEmpty ||
                        num.parse(controller.text) > (widget.qty ?? 0)))
                ? null
                : _onTap,
          ),
          Visibility(
            visible: controller.text.isNotEmpty &&
                widget.buy &&
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
                !widget.buy &&
                num.parse(controller.text) > (widget.qty ?? 0),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SdCommonHeading(),

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
                  // AnimatedInput(
                  //   controller: controller,
                  // ),
                  if (widget.qty != null)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Available quantity - ${widget.qty ?? 0}',
                        style: styleGeorgiaBold(),
                      ),
                    ),
                  SpacerVertical(),
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
