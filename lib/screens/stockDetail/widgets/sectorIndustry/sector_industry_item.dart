import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/sector_industry_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../index.dart';

class SectorIndustryItem extends StatelessWidget {
  final int index;
  final SectorIndustryData? data;
  const SectorIndustryItem({super.key, required this.index, this.data});
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => StockDetail(symbol: data!.symbol)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0.sp),
              child: Container(
                padding: const EdgeInsets.all(5),
                width: 43,
                height: 43,
                // child: ThemeImageView(
                //   url: "${data?.image}",
                // ),
                child: CachedNetworkImagesWidget(data?.image),
              ),
            ),
            const SpacerHorizontal(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data?.symbol}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "${data?.name}",
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${data?.price}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        (data?.changesPercentage ?? 0) > 0
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: (data?.changesPercentage ?? 0) > 0
                            ? ThemeColors.accent
                            : Colors.red,
                        size: 16,
                      ),
                      Flexible(
                        child: Text(
                          "${data?.formattedChange} (${data?.changesPercentage.toCurrency()}%)",
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: (data?.changesPercentage ?? 0) > 0
                                ? ThemeColors.accent
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
