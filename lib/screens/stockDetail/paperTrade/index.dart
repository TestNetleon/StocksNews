import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/paperTrade/text_field.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../providers/trade_provider.dart';
import '../widgets/common_heading.dart';

class PaperTradeIndex extends StatelessWidget {
  final bool buy;
  const PaperTradeIndex({
    super.key,
    this.buy = true,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: true,
        canSearch: true,
      ),
      body: SdTypeBuySell(buy: buy),
    );
  }
}

class SdTypeBuySell extends StatefulWidget {
  final bool buy;

  const SdTypeBuySell({
    super.key,
    this.buy = true,
  });

  @override
  State<SdTypeBuySell> createState() => _SdTypeBuySellState();
}

class _SdTypeBuySellState extends State<SdTypeBuySell> {
  TypeTrade _selectedSegment = TypeTrade.shares;
  // final TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _currentText = "0";
  String _lastEntered = "";
  int _keyCounter = 0;
  String _previousText = "";

  String text = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    controller.clear();
    super.dispose();
  }

  _onTap() {
    StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
    TradeProviderNew tradeProviderNew = context.read<TradeProviderNew>();

    String cleanedString =
        provider.tabRes?.keyStats?.price?.replaceAll(RegExp(r'[^\d.]'), '') ??
            "";
    num price = num.parse(cleanedString);
    num invested = _selectedSegment == TypeTrade.shares
        ? price * num.parse(_currentText)
        : num.parse(_currentText);

    Utils().showLog("Price is => $price");
    if (_selectedSegment == TypeTrade.shares) {
      Utils().showLog("Shares bought in Shares => $_currentText");
    } else {
      Utils().showLog(
          "Shares bought in Dollars => ${(num.parse(_currentText) / price)}");
    }

    Utils().showLog("Invested Amount => $invested");

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
      }
    } else {
      int existingOrderIndex = tradeProviderNew.orders
          .indexWhere((o) => o.symbol == provider.tabRes?.keyStats?.symbol);
      if (existingOrderIndex < 0) {
        Utils().showLog("$existingOrderIndex");
        popUpAlert(
            message:
                "You have not bought any shares of ${provider.tabRes?.keyStats?.symbol}. ",
            title: "Alert");
        return;
      }

      SummaryOrderNew existingOrder =
          tradeProviderNew.orders[existingOrderIndex];

      num existingInvested = existingOrder.invested ?? 0;
      num newInvested = invested;

      if (newInvested > existingInvested) {
        popUpAlert(
            message: "Attempted to sell more investment than available.",
            title: "Alert");
        return;
      }
    }

    popUpAlert(
      message: "New Message",
      title: "Alert",
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      cancel: true,
      canPop: false,
      child: Column(
        children: [
          Text(
            widget.buy
                ? "Buy ${provider.tabRes?.keyStats?.symbol}"
                : "Sell ${provider.tabRes?.keyStats?.symbol}",
            style: stylePTSansBold(color: ThemeColors.background, fontSize: 30),
          ),
          const SpacerVertical(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Price: ",
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 20,
                ),
              ),
              Flexible(
                child: Text(
                  "${provider.tabRes?.keyStats?.price}",
                  style: stylePTSansBold(
                      color: ThemeColors.background, fontSize: 20),
                ),
              ),
            ],
          ),
          const Divider(
            color: ThemeColors.greyBorder,
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Quantity: ",
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 20,
                ),
              ),
              Flexible(
                child: Text(
                  _selectedSegment == TypeTrade.shares
                      ? _currentText
                      : (num.parse(_currentText) / price).toCurrency(),
                  style: stylePTSansBold(
                    color: ThemeColors.background,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: ThemeColors.greyBorder,
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Total Amount: ",
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 20,
                ),
              ),
              Flexible(
                child: Text(
                  "\$${invested.toCurrency()}",
                  style: stylePTSansBold(
                      color: ThemeColors.background, fontSize: 20),
                ),
              ),
            ],
          ),
          const SpacerVertical(height: 20),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
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
          ),
        );
        _clear();
      },
    );
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
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  // IntrinsicWidth(
                  //   child: TextFormField(
                  //     focusNode: focusNode,
                  //     controller: controller,
                  //     onChanged: (value) {
                  //       controller.text = value;
                  //       text = value;
                  //       setState(() {});
                  //     },
                  //     style: stylePTSansRegular(fontSize: 100),
                  //     inputFormatters: [
                  //       _formatter,
                  //       LengthLimitingTextInputFormatter(6),
                  //     ],
                  //     showCursor: false,
                  //     keyboardType: TextInputType.number,
                  //     textAlign: TextAlign.center,
                  //     decoration: InputDecoration(
                  //       contentPadding:
                  //           const EdgeInsets.symmetric(horizontal: 10),
                  //       hintText: "0",
                  //       hintStyle: stylePTSansRegular(fontSize: 100),
                  //       focusedBorder: UnderlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: widget.buy
                  //               ? ThemeColors.accent
                  //               : ThemeColors.sos,
                  //         ),
                  //       ),
                  //       enabledBorder: const UnderlineInputBorder(
                  //         borderSide: BorderSide(color: ThemeColors.greyBorder),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Stack(
                  //   alignment: Alignment.center,
                  //   children: [
                  //     TextFormField(
                  //       focusNode: focusNode,
                  //       textAlign: TextAlign.center,
                  //       inputFormatters: [LengthLimitingTextInputFormatter(7)],
                  //       keyboardType: TextInputType.phone,
                  //       controller: controller,
                  //       // onChanged: (text) {
                  //       //   setState(() {
                  //       //     // Detect if text is being cleared
                  //       //     if (text.length < _previousText.length) {
                  //       //       Utils()
                  //       //           .showLog("Detect if text is being cleared");
                  //       //       _lastEntered = "";
                  //       //       _currentText = text;
                  //       //       _keyCounter++;
                  //       //     } else {
                  //       //       Utils().showLog("Adding new characters");
                  //       //       // Adding new characters
                  //       //       _lastEntered = text.substring(text.length - 1);
                  //       //       _currentText = text;
                  //       //       _keyCounter++;
                  //       //     }
                  //       //     _previousText = text;
                  //       //   });
                  //       // },
                  //       onChanged: (text) {
                  //         _onChange(text);
                  //       },
                  //       decoration: const InputDecoration(
                  //         focusedBorder: UnderlineInputBorder(
                  //           borderSide:
                  //               BorderSide(color: ThemeColors.transparent),
                  //         ),
                  //       ),
                  //       style: const TextStyle(
                  //           fontSize: 80, color: Colors.transparent),
                  //       cursorColor: Colors.transparent,
                  //     ),
                  //     Positioned.fill(
                  //       child: Align(
                  //         alignment: Alignment.center,
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             focusNode.requestFocus();
                  //           },
                  //           child: Container(
                  //             decoration: const BoxDecoration(
                  //               border: Border(
                  //                 bottom: BorderSide(color: ThemeColors.accent),
                  //               ),
                  //             ),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Text(
                  //                   _currentText.substring(
                  //                       0,
                  //                       _currentText.length -
                  //                           _lastEntered.length),
                  //                   style: const TextStyle(
                  //                       fontSize: 80, color: Colors.white),
                  //                 ),
                  //                 ClipRect(
                  //                   child: AnimatedSwitcher(
                  //                     duration:
                  //                         const Duration(milliseconds: 300),
                  //                     transitionBuilder: (Widget child,
                  //                         Animation<double> animation) {
                  //                       final slideIn = Tween<Offset>(
                  //                         begin: const Offset(0.0, 1.0),
                  //                         end: const Offset(0.0, 0.0),
                  //                       ).animate(animation);
                  //                       final slideOut = Tween<Offset>(
                  //                         begin: const Offset(60.0, 60.0),
                  //                         end: const Offset(0.0, -1.0),
                  //                       ).animate(animation);
                  //                       if (child.key ==
                  //                           ValueKey<String>(
                  //                               '$_lastEntered$_keyCounter')) {
                  //                         Utils().showLog("Slide In");
                  //                         return SlideTransition(
                  //                           position: slideIn,
                  //                           child: FadeTransition(
                  //                             opacity: animation,
                  //                             child: child,
                  //                           ),
                  //                         );
                  //                       } else {
                  //                         Utils().showLog("Slide Out");
                  //                         return SlideTransition(
                  //                           position: slideOut,
                  //                           child: FadeTransition(
                  //                             opacity: animation,
                  //                             child: child,
                  //                           ),
                  //                         );
                  //                       }
                  //                     },
                  //                     child: Text(
                  //                       _lastEntered,
                  //                       key: ValueKey<String>(
                  //                           '$_lastEntered$_keyCounter'),
                  //                       style: const TextStyle(
                  //                           fontSize: 80, color: Colors.white),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  TextfieldTrade(
                    controller: controller,
                    focusNode: focusNode,
                    text: _currentText.substring(
                        0, _currentText.length - _lastEntered.length),
                    change: (p0) {
                      _onChange(p0);
                    },
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
                            "\$${context.read<TradeProviderNew>().data.availableBalance.toCurrency()}",
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
            color: widget.buy ? ThemeColors.accent : ThemeColors.sos,
            onPressed: _onTap,
          ),
        ],
      ),
    );
  }
}
