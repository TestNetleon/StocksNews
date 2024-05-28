import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';

class CompareNewBox extends StatelessWidget {
  final String title;
  final bool open;
  final Function()? onTap;
  final Widget? child;
  final bool hideTop;
  const CompareNewBox({
    super.key,
    required this.title,
    this.open = false,
    this.onTap,
    this.child,
    this.hideTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                top: hideTop
                    ? BorderSide.none
                    : BorderSide(
                        color: ThemeColors.greyBorder.withOpacity(0.4)),
                bottom: BorderSide(
                  color: ThemeColors.greyBorder.withOpacity(0.4),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: stylePTSansBold(),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Icon(open ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.topCenter,
          child: Container(
            height: open ? null : 0,
            padding: const EdgeInsets.only(top: Dimen.itemSpacing),
            child: child,
          ),
        ),
      ],
    );
  }
}
