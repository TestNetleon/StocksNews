import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../providers/trade_provider.dart';
import '../../../route/my_app.dart';
import '../paperTrade/index.dart';
import 'sheet.dart';

class SdTrade extends StatefulWidget {
  const SdTrade({super.key});

  @override
  State<SdTrade> createState() => _SdTradeState();
}

class _SdTradeState extends State<SdTrade> {
  bool isSelected = false;

  void _showPopupMenu(BuildContext context, Offset offset) async {
    setState(() {
      isSelected = true;
    });
    await showMenu(
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      ),
      context: context,
      // position: RelativeRect.fromRect(
      //     offset & const Size(40, 40), Offset.zero & overlay.size),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy - 90,
        offset.dx,
        offset.dy,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: 'buy',
          child: Align(
            alignment: Alignment.center,
            child: _card(
              "Buy",
              icon: Icons.sell_outlined,
              color: ThemeColors.accent,
              textColor: ThemeColors.white,
            ),
          ),
        ),
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: 'sell',
          child: Align(
            alignment: Alignment.center,
            child: _card(
              "Sell",
              icon: Icons.sell_outlined,
              color: ThemeColors.sos,
              textColor: ThemeColors.white,
            ),
          ),
        ),
      ],
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ).then((String? value) async {
      setState(() {
        isSelected = false;
      });
      if (value != null) {
        Utils().showLog('Selected: $value');

        try {
          SummaryOrderNew order = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaperTradeIndex(buy: value == "buy"),
            ),
          );
          TradeProviderNew provider = context.read<TradeProviderNew>();
          log("1");
          value == "buy"
              ? provider.addOrderData(order)
              : provider.sellOrderData(order);
          await _showSheet(order, value == "buy");

          log("1");
        } catch (e) {
          //
        }
      }
    });
  }

  Future _showSheet(SummaryOrderNew? order, bool buy) async {
    await showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return SuccessTradeSheet(
          order: order,
          buy: buy,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isSelected)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: const Border(
              top: BorderSide(color: ThemeColors.greyBorder),
            ),
            color: ThemeColors.background.withOpacity(0.8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: stylePTSansRegular(
                        fontSize: 20, color: ThemeColors.greyText),
                    text: "Balance: ",
                    children: [
                      TextSpan(
                        text: "\$2005.34",
                        style: stylePTSansBold(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const SdSummaryOrders(),
              //       ),
              //     );
              //   },
              //   child: _card(
              //     "My Orders",
              //     color: ThemeColors.blue,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 24,
              //       vertical: 11,
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final Offset offset = button.localToGlobal(
                      button.size.topRight(Offset.zero),
                      ancestor: overlay);
                  _showPopupMenu(context, offset);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: isSelected
                      ? _card(
                          "Close",
                          icon: Icons.close,
                          color: ThemeColors.greyBorder,
                          textColor: ThemeColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 11,
                          ),
                        )
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          child: _card(
                            "Trade",
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 11,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(
    text, {
    IconData? icon,
    Color? color = const Color.fromARGB(255, 194, 216, 51),
    Color? textColor = ThemeColors.background,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 11,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(
              icon ?? Icons.travel_explore_rounded,
              size: 20,
              color: textColor,
            ),
          ),
          Flexible(
            child: Text(
              "$text",
              style: stylePTSansBold(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
