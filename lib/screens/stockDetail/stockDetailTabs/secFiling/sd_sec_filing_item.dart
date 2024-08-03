import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sec_filing_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdSecFilingItem extends StatelessWidget {
  final SecFiling? data;
  final int index;
  final Function() onCardTapped;

  const SdSecFilingItem({
    super.key,
    required this.data,
    required this.index,
    required this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              // ThemeColors.greyBorder,
              Color.fromARGB(255, 39, 39, 39),
            ],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Filling Date",
                    style: stylePTSansBold(fontSize: 14),
                  ),
                ),
                const SpacerHorizontal(width: 5),
                Text(
                  data?.fillingDate ?? "",
                  style: stylePTSansRegular(fontSize: 14),
                ),
              ],
            ),
            const SpacerVertical(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Accepted Date",
                    style: stylePTSansBold(fontSize: 14),
                  ),
                ),
                const SpacerHorizontal(width: 5),
                Text(
                  data?.acceptedDate ?? "",
                  style: stylePTSansRegular(fontSize: 14),
                ),
              ],
            ),
            const SpacerVertical(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => openUrl(data?.link),
                behavior: HitTestBehavior.translucent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ThemeColors.accent,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Text(
                    "View",
                    style: styleGeorgiaRegular(fontSize: 13),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
