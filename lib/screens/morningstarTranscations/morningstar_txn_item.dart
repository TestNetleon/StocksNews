import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morningstar_purchase_res.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
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
              ClipRRect(
                borderRadius: BorderRadius.circular(0.sp),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 43,
                  height: 43,
                  child: CachedNetworkImagesWidget(data.tickerImage ?? ""),
                ),
              ),
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
