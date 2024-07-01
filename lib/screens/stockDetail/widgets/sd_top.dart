import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class SdTopCard extends StatelessWidget {
  final SdTopRes? top;
  final bool textRed;
  final bool gridRed;
  final Color otherColor;

  const SdTopCard({
    super.key,
    this.top,
    this.textRed = false,
    this.gridRed = false,
    this.otherColor = ThemeColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ThemeColors.greyBorder.withOpacity(0.3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: top?.key != null && top?.key != '',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    top?.key?.toUpperCase() ?? "N/A",
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ),
              ),
              Visibility(
                visible: top?.value != null && top?.value != '',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    "${top?.value ?? "N/A"}",
                    style: styleGeorgiaBold(
                        fontSize: 20,
                        color: textRed ? ThemeColors.sos : ThemeColors.accent),
                  ),
                ),
              ),
              Visibility(
                visible: top?.other != null && top?.other != '',
                child: Text(
                  top?.other ?? "N/A",
                  style: stylePTSansRegular(fontSize: 12, color: otherColor),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 5,
          right: 5,
          bottom: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              color: gridRed ? ThemeColors.sos : ThemeColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
