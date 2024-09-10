import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/colors.dart';
import '../../../../../utils/theme.dart';

class CustomSlidingSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final List<String> menus;
  final Function(int) onValueChanged;
  final TextStyle? style;
  final List<Color>? colors;

  final Color unselectedBackgroundColor;

  const CustomSlidingSegmentedControl({
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
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: selectedIndex,
      thumbColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      onValueChanged: (int? index) {
        if (index != null) {
          onValueChanged(index);
        }
      },
      children: {
        for (int i = 0; i < menus.length; i++)
          i: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
                      fontSize: 13,
                      color: selectedIndex == i
                          ? ThemeColors.white
                          : ThemeColors.greyText,
                    ),
              ),
            ),
          ),
      },
    );
  }
}
