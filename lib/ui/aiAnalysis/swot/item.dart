import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MsSwotItem extends StatelessWidget {
  const MsSwotItem({
    super.key,
    required this.label,
    required this.value,
    required this.keyword,
    required this.childRadius,
    required this.crossAxisAlignment,
    this.left,
    this.onTap,
    this.right,
    this.top,
    this.bottom,
    this.color,
  });

  final String label, value, keyword;
  final double? left, top, right, bottom;
  final BorderRadius childRadius;
  final CrossAxisAlignment crossAxisAlignment;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Pad.pad8),
        child: BaseBorderContainer(
          padding: EdgeInsets.zero,
          innerPadding: EdgeInsets.zero,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Padding(
                padding: const EdgeInsets.all(Pad.pad16),
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    Text(
                      label,
                      style: styleBaseBold(
                        fontSize: 14,
                      ),
                    ),
                    const SpacerVertical(height: 8),
                    Text(
                      value,
                      style: styleBaseBold(
                        fontSize: 18,
                        color: color ?? ThemeColors.themeGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: bottom,
                right: right,
                left: left,
                top: top,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: ThemeColors.neutral5,
                    borderRadius: childRadius,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: bottom == 0 ? 8.0 : 0,
                    left: right == 0 ? 8.0 : 0,
                    right: left == 0 ? 8.0 : 0,
                    bottom: top == 0 ? 8.0 : 0,
                  ),
                  child: Text(
                    keyword,
                    style: styleBaseBold(fontSize: 14),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
