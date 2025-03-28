import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class MoreItem extends StatelessWidget {
  const MoreItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon, label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Consumer<ThemeManager>(
        builder: (context, value, child) {
          return Container(
            // padding: EdgeInsets.all(Pad.pad16),
            padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ThemeColors.neutral5,
                  width: value.isDarkMode ? 0 : 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  width: 32,
                  height: 32,
                  color:
                      // value.isDarkMode ? ThemeColors.white :
                      ThemeColors.black,
                ),
                SpacerHorizontal(width: Pad.pad8),
                Expanded(
                  child: Text(
                    label,
                    // style: styleBaseRegular(fontSize: 16, height: 1.2),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Image.asset(
                  Images.moreItem,
                  width: 24,
                  height: 24,
                  // color: value.isDarkMode ? ThemeColors.white : null,
                  color: ThemeColors.black,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
