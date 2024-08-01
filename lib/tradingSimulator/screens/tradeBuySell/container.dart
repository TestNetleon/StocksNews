import 'dart:async';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../providers/trade_provider.dart';

class BuySellContainer extends StatefulWidget {
  final bool buy;
  final bool doPop;

  const BuySellContainer({
    super.key,
    this.buy = true,
    this.doPop = true,
  });

  @override
  State<BuySellContainer> createState() => _BuySellContainerState();
}

class _BuySellContainerState extends State<BuySellContainer> {
  TextEditingController controller = TextEditingController();
  TypeTrade _selectedSegment = TypeTrade.shares;
  FocusNode focusNode = FocusNode();
  String _currentText = "0";
  String _lastEntered = "";
  String _previousText = "";

  int _keyCounter = 0;
  num _availableBalance = 0;

  // String text = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      _availableBalance =
          context.read<TradeProviderNew>().data.availableBalance;
    });
  }

  @override
  void dispose() {
    controller.clear();
    super.dispose();
  }

  _onTap() async {
    StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
    TradeProviderNew tradeProviderNew = context.read<TradeProviderNew>();

    String cleanedString =
        provider.tabRes?.keyStats?.price?.replaceAll(RegExp(r'[^\d.]'), '') ??
            "";
    num price = num.parse(cleanedString);
    num invested = _selectedSegment == TypeTrade.shares
        ? price * num.parse(_currentText)
        : num.parse(_currentText);

    // Utils().showLog("Price is => $price");
    // if (_selectedSegment == TypeTrade.shares) {
    //   Utils().showLog("Shares bought in Shares => $_currentText");
    // } else {
    //   Utils().showLog(
    //     "Shares bought in Dollars => ${(num.parse(_currentText) / price)}",
    //   );
    // }
    // Utils().showLog("Invested Amount => $invested");

    closeKeyboard();
    if (controller.text.isEmpty || num.parse(controller.text) == 0.0) {
      popUpAlert(
        message: "Value can't be empty",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    if (widget.buy) {
      if (invested > tradeProviderNew.data.availableBalance) {
        popUpAlert(
          message: "Insufficient available balance to place this order.",
          title: "Alert",
        );
        return;
      } else {
        final request = {
          "token":
              navigatorKey.currentContext!.read<UserProvider>().user?.token ??
                  "",
          "trade_type": "buy",
          "symbol": provider.tabRes?.keyStats?.symbol,
          "current_price": provider.tabRes?.keyStats?.price
                  ?.replaceAll(RegExp(r'[^\d.]'), '') ??
              "",
          "type": _selectedSegment == TypeTrade.shares
              ? "1"
              : "2", // 1 = share , 2 = amount
          "quantity": controller.text, //entered value
          "image": provider.tabRes?.companyInfo?.image, //entered value
        };

        ApiResponse response = await tradeProviderNew.requestBuyShare(request);
        if (response.status) {
          context.read<HomeProvider>().getHomeSlider();
          context.read<TsOpenListProvider>().getData();
          // Navigator.pop(context);
          Navigator.pop(
            context,
            SummaryOrderNew(
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
            ),
          );
          _clear();
        } else {
          popUpAlert(message: "${response.message}", title: "Alert");
          // popUpAlert(
          //   message: "New Message",
          //   title: "Alert",
          //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          //   cancel: true,
          //   canPop: false,
          //   child: Column(
          //     children: [
          //       Text(
          //         widget.buy
          //             ? "Buy ${provider.tabRes?.keyStats?.symbol}"
          //             : "Sell ${provider.tabRes?.keyStats?.symbol}",
          //         style: stylePTSansBold(
          //             color: ThemeColors.background, fontSize: 30),
          //       ),
          //       const SpacerVertical(height: 30),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Text(
          //             "Price: ",
          //             style: stylePTSansRegular(
          //               color: ThemeColors.greyText,
          //               fontSize: 20,
          //             ),
          //           ),
          //           Flexible(
          //             child: Text(
          //               "${provider.tabRes?.keyStats?.price}",
          //               style: stylePTSansBold(
          //                   color: ThemeColors.background, fontSize: 20),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const Divider(
          //         color: ThemeColors.greyBorder,
          //         height: 25,
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Text(
          //             "Quantity: ",
          //             style: stylePTSansRegular(
          //               color: ThemeColors.greyText,
          //               fontSize: 20,
          //             ),
          //           ),
          //           Flexible(
          //             child: Text(
          //               _selectedSegment == TypeTrade.shares
          //                   ? _currentText
          //                   : (num.parse(_currentText) / price).toCurrency(),
          //               style: stylePTSansBold(
          //                 color: ThemeColors.background,
          //                 fontSize: 20,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const Divider(
          //         color: ThemeColors.greyBorder,
          //         height: 25,
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Text(
          //             "Total Amount: ",
          //             style: stylePTSansRegular(
          //               color: ThemeColors.greyText,
          //               fontSize: 20,
          //             ),
          //           ),
          //           Flexible(
          //             child: Text(
          //               "\$${invested.toCurrency()}",
          //               style: stylePTSansBold(
          //                   color: ThemeColors.background, fontSize: 20),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SpacerVertical(height: 20),
          //     ],
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.pop(
          //       context,
          //       SummaryOrderNew(
          //         isShare: _selectedSegment == TypeTrade.shares,
          //         change: provider.tabRes?.keyStats?.changeWithCur,
          //         changePercentage:
          //             provider.tabRes?.keyStats?.changesPercentage,
          //         dollars: _selectedSegment == TypeTrade.dollar
          //             ? num.parse(_currentText)
          //             : (num.parse(_currentText) * price),
          //         shares: _selectedSegment == TypeTrade.shares
          //             ? num.parse(_currentText)
          //             : (num.parse(_currentText) / price),
          //         image: provider.tabRes?.companyInfo?.image,
          //         name: provider.tabRes?.keyStats?.name,
          //         price: provider.tabRes?.keyStats?.price,
          //         symbol: provider.tabRes?.keyStats?.symbol,
          //         invested: invested,
          //         buy: widget.buy,
          //       ),
          //     );
          //     _clear();
          //   },
          // );
        }
      }
    } else {
      // int existingOrderIndex = tradeProviderNew.orders
      //     .indexWhere((o) => o.symbol == provider.tabRes?.keyStats?.symbol);
      // if (existingOrderIndex < 0) {
      //   Utils().showLog("$existingOrderIndex");
      //   popUpAlert(
      //       message:
      //           "You have not bought any shares of ${provider.tabRes?.keyStats?.symbol}. ",
      //       title: "Alert");
      //   return;
      // }
      // try {
      //   SummaryOrderNew existingOrder =
      //       tradeProviderNew.orders[existingOrderIndex];
      //   num existingInvested = existingOrder.invested ?? 0;
      //   num newInvested = invested;
      //   if (newInvested > existingInvested) {
      //     popUpAlert(
      //       message: "Attempted to sell more investment than available.",
      //       title: "Alert",
      //     );
      //     return;
      //   }
      // } catch (e) {
      //   //
      // }

      final request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        // "order_type": "buy",
        "symbol": provider.tabRes?.keyStats?.symbol,
        "current_price": provider.tabRes?.keyStats?.price
                ?.replaceAll(RegExp(r'[^\d.]'), '') ??
            "",
        "type": _selectedSegment == TypeTrade.shares
            ? "1"
            : "2", // 1 = share , 2 = amount
        "value": controller.text, //entered value
        "image": provider.tabRes?.companyInfo?.image, //entered value
      };

      ApiResponse response = await tradeProviderNew.requestSellShare(request);
      if (response.status) {
        context.read<HomeProvider>().getHomeSlider();
        context.read<TsOpenListProvider>().getData();
        // Navigator.pop(context);
        Navigator.pop(
          context,
          SummaryOrderNew(
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
          ),
        );
        _clear();
      } else {
        popUpAlert(message: "${response.message}", title: "Alert");
      }
    }

    // popUpAlert(
    //   message: "New Message",
    //   title: "Alert",
    //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    //   cancel: true,
    //   canPop: false,
    //   child: Column(
    //     children: [
    //       Text(
    //         widget.buy
    //             ? "Buy ${provider.tabRes?.keyStats?.symbol}"
    //             : "Sell ${provider.tabRes?.keyStats?.symbol}",
    //         style: stylePTSansBold(color: ThemeColors.background, fontSize: 30),
    //       ),
    //       const SpacerVertical(height: 30),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text(
    //             "Price: ",
    //             style: stylePTSansRegular(
    //               color: ThemeColors.greyText,
    //               fontSize: 20,
    //             ),
    //           ),
    //           Flexible(
    //             child: Text(
    //               "${provider.tabRes?.keyStats?.price}",
    //               style: stylePTSansBold(
    //                   color: ThemeColors.background, fontSize: 20),
    //             ),
    //           ),
    //         ],
    //       ),
    //       const Divider(
    //         color: ThemeColors.greyBorder,
    //         height: 25,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text(
    //             "Quantity: ",
    //             style: stylePTSansRegular(
    //               color: ThemeColors.greyText,
    //               fontSize: 20,
    //             ),
    //           ),
    //           Flexible(
    //             child: Text(
    //               _selectedSegment == TypeTrade.shares
    //                   ? _currentText
    //                   : (num.parse(_currentText) / price).toCurrency(),
    //               style: stylePTSansBold(
    //                 color: ThemeColors.background,
    //                 fontSize: 20,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       const Divider(
    //         color: ThemeColors.greyBorder,
    //         height: 25,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text(
    //             "Total Amount: ",
    //             style: stylePTSansRegular(
    //               color: ThemeColors.greyText,
    //               fontSize: 20,
    //             ),
    //           ),
    //           Flexible(
    //             child: Text(
    //               "\$${invested.toCurrency()}",
    //               style: stylePTSansBold(
    //                   color: ThemeColors.background, fontSize: 20),
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SpacerVertical(height: 20),
    //     ],
    //   ),
    //   onTap: () {
    //     Navigator.pop(context);
    //     Navigator.pop(
    //       context,
    //       SummaryOrderNew(
    //         isShare: _selectedSegment == TypeTrade.shares,
    //         change: provider.tabRes?.keyStats?.changeWithCur,
    //         changePercentage: provider.tabRes?.keyStats?.changesPercentage,
    //         dollars: _selectedSegment == TypeTrade.dollar
    //             ? num.parse(_currentText)
    //             : (num.parse(_currentText) * price),
    //         shares: _selectedSegment == TypeTrade.shares
    //             ? num.parse(_currentText)
    //             : (num.parse(_currentText) / price),
    //         image: provider.tabRes?.companyInfo?.image,
    //         name: provider.tabRes?.keyStats?.name,
    //         price: provider.tabRes?.keyStats?.price,
    //         symbol: provider.tabRes?.keyStats?.symbol,
    //         invested: invested,
    //         buy: widget.buy,
    //       ),
    //     );
    //     _clear();
    //   },
    // );
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CupertinoSlidingSegmentedControl<TypeTrade>(
                      backgroundColor: ThemeColors.greyBorder.withOpacity(0.4),
                      thumbColor:
                          widget.buy ? ThemeColors.accent : ThemeColors.sos,
                      groupValue: _selectedSegment,
                      onValueChanged: (TypeTrade? value) {
                        if (value != null) {
                          setState(() {
                            _selectedSegment = value;
                          });
                          _clear();
                        }
                      },
                      children: <TypeTrade, Widget>{
                        TypeTrade.shares: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.buy ? 'Buy in Shares' : 'Sell in Shares',
                            style: styleGeorgiaBold(),
                          ),
                        ),
                        TypeTrade.dollar: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.buy ? 'Buy in Dollars' : 'Sell in Dollars',
                            style: styleGeorgiaBold(),
                          ),
                        ),
                      },
                    ),
                  ),
                  const SpacerVertical(),
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
                ],
              ),
            ),
          ),
          _newMethod(),
        ],
      ),
    );
  }

  Widget _newMethod() {
    StockDetailProviderNew stockDetailProviderNew =
        context.read<StockDetailProviderNew>();
    String cleanedString = stockDetailProviderNew.tabRes?.keyStats?.price
            ?.replaceAll(RegExp(r'[^\d.]'), '') ??
        "";
    num price = num.parse(cleanedString);
    num invested = _selectedSegment == TypeTrade.shares
        ? price * num.parse(_currentText)
        : num.parse(_currentText);

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
                        text:
                            "\$${formatBalance(num.parse(context.read<TradeProviderNew>().data.availableBalance.toCurrency()))}",
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
            text: widget.buy ? "Proceed Buy Order" : "Proceed Sell Order",
            color: widget.buy
                ? (invested > _availableBalance || invested == 0)
                    ? ThemeColors.greyText
                    : ThemeColors.accent
                : (invested > _availableBalance || invested == 0)
                    ? ThemeColors.greyText
                    : ThemeColors.sos,
            onPressed: (invested > _availableBalance || invested == 0)
                ? () {}
                : _onTap,
          ),
        ],
      ),
    );
  }
}
