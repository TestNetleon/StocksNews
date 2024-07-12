import 'package:flutter/material.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BenefitTitle extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const BenefitTitle({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (title != null && title != "") ||
          (subTitle != null && subTitle != ""),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Column(
          children: [
            Visibility(
              visible: title != null && title != "",
              child: Column(
                children: [
                  Text(
                    "$title",
                    style: stylePTSansRegular(
                      color: ThemeColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SpacerVertical(height: 8),
                ],
              ),
            ),
            Visibility(
              visible: subTitle != null && subTitle != "",
              child: Column(
                children: [
                  Text(
                    "$subTitle",
                    style: stylePTSansRegular(
                      color: ThemeColors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SpacerVertical(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
