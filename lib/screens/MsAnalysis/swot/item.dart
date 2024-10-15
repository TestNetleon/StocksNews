import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromARGB(255, 102, 100, 100),
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Text(
                    label,
                    style: stylePTSansBold(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 195, 195, 195),
                    ),
                  ),
                  const SpacerVertical(height: 8.0),
                  Text(
                    value,
                    style: stylePTSansBold(
                      fontSize: 16,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
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
                  style: stylePTSansBold(fontSize: 14.0, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
