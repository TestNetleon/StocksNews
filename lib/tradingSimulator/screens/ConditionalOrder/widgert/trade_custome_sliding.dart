import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class TradeCustomeSliding extends StatelessWidget {
  final int selectedIndex;
  final List<String> menus;
  final Function(int) onValueChanged;
  final TextStyle? style;
  final List<Color>? colors;

  final Color unselectedBackgroundColor;

  const TradeCustomeSliding({
    super.key,
    required this.selectedIndex,
    required this.menus,
    required this.onValueChanged,
    this.style,
    this.unselectedBackgroundColor = Colors.transparent,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: selectedIndex,
        thumbColor: const Color.fromARGB(255, 61, 61, 61),
        backgroundColor: Colors.transparent,
        onValueChanged: (int? index) {
          if (index != null) {
            onValueChanged(index);
          }
        },
        children: {
          for (int i = 0; i < menus.length; i++)
            i: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: selectedIndex == i
                    ? LinearGradient(
                  colors: colors ??
                      [
                        ThemeColors.bottomsheetGradient,
                        ThemeColors.accent,
                      ],
                )
                    : null,
              ),
              child: Center(
                child: Text(
                  menus[i],
                  style: style ??
                      styleGeorgiaBold(
                        fontSize: 15,
                        color: selectedIndex == i
                            ? ThemeColors.white
                            : ThemeColors.greyText,
                      ),
                ),
              ),
            ),
        },
      ),
    );
  }
}
