import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/marketData/paperTrade/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class SdTrade extends StatefulWidget {
  const SdTrade({super.key});

  @override
  State<SdTrade> createState() => _SdTradeState();
}

class _SdTradeState extends State<SdTrade> {
  void _showPopupMenu(BuildContext context, Offset offset) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      popUpAnimationStyle: AnimationStyle(curve: Curves.easeIn),
      context: context,
      position: RelativeRect.fromRect(
          offset & const Size(40, 40), Offset.zero & overlay.size),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'buy',
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 100,
              alignment: Alignment.center,
              child: _card("Buy", icon: Icons.sell_outlined),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'sell',
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 100,
              alignment: Alignment.center,
              child: _card("Sell", icon: Icons.sell_outlined),
            ),
          ),
        ),
      ],
      elevation: 8.0,
      color: ThemeColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ).then((String? value) {
      if (value != null) {
        Utils().showLog('Selected: $value');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaperTradeIndex(
              buy: value == "buy",
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
        color: ThemeColors.background.withOpacity(0.8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          final Offset offset = button.localToGlobal(
              button.size.center(Offset.zero),
              ancestor: overlay);
          _showPopupMenu(context, offset);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: _card("Trade"),
        ),
      ),
    );
  }

  Widget _card(text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 194, 216, 51),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(
              icon ?? Icons.travel_explore_rounded,
              size: 20,
              color: ThemeColors.background,
            ),
          ),
          Flexible(
            child: Text(
              "$text",
              style: stylePTSansBold(color: ThemeColors.background),
            ),
          ),
        ],
      ),
    );
  }
}
