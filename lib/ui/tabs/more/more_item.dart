import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
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
    return Container(
      // padding: EdgeInsets.all(Pad.pad16),
      padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ThemeColors.neutral5),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 32,
            height: 32,
            color: Colors.black,
          ),
          SpacerHorizontal(width: Pad.pad8),
          Expanded(
            child: Text(
              label,
              style: styleBaseRegular(fontSize: 16, height: 1.2),
            ),
          ),
          Image.asset(Images.moreItem, width: 24, height: 24),
        ],
      ),
    );
  }
}
