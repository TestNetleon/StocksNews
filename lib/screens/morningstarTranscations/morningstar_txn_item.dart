import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morningstar_purchase_res.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MorningStarTxnItem extends StatelessWidget {
  const MorningStarTxnItem({required this.data, super.key});

  final MorningStarPurchase data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebviewLink(stringURL: data.pdfUrl),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ThemeColors.background,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Image.asset(Images.stockIcon, width: 48),
              const SpacerHorizontal(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.symbol,
                    style: stylePTSansBold(),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    data.quantStarRatingDate,
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
