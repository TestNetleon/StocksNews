import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../utils/colors.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                    style: stylePTSansBold(fontSize: 15),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                // Icon(open ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: open ? 1 : 0.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, double value, child) {
                    return Transform.rotate(
                      angle: value * 3.14159,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_drop_down,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              color: ThemeColors.greyBorder.withOpacity(0.2),
              border: Border(
                bottom: BorderSide(
                  color: ThemeColors.greyBorder.withOpacity(0.2),
                ),
              ),
            ),
            height: open ? null : 0,
            // padding: const EdgeInsets.only(
            //     top: Dimen.itemSpacing, bottom: Dimen.itemSpacing),
            child: child,
          ),
        ),
      ],
    );
  }
}
