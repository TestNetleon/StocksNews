import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class SdTopWidgetDetail extends StatelessWidget {
  const SdTopWidgetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;
    CompanyInfo? companyInfo = provider.tabRes?.companyInfo;
    return Row(
      children: [
        Visibility(
          visible: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 43,
              height: 43,
              child: ThemeImageView(url: companyInfo?.image ?? ""),
            ),
          ),
        ),
        const SpacerHorizontal(width: 12),
        Visibility(
          visible: keyStats?.symbol != null || keyStats?.name != null,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keyStats?.symbol ?? "",
                  style: styleGeorgiaBold(fontSize: 18),
                ),
                const SpacerVertical(height: 5),
                Text(
                  keyStats?.name ?? "",
                  style: styleGeorgiaRegular(
                    color: ThemeColors.greyText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SpacerHorizontal(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(keyStats?.price ?? "", style: stylePTSansBold(fontSize: 18)),
            const SpacerVertical(height: 2),
            Visibility(
              visible: keyStats?.change != null,
              child: Row(
                children: [
                  Icon(
                    (keyStats?.change ?? 0) > 0
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: (keyStats?.change ?? 0) > 0
                        ? ThemeColors.accent
                        : Colors.red,
                    size: 20.sp,
                  ),
                  Text(
                    "${keyStats?.changeWithCur} (${keyStats?.changesPercentage?.toCurrency()}%)",
                    style: stylePTSansBold(
                      fontSize: 12,
                      color: (keyStats?.change ?? 0) > 0
                          ? ThemeColors.accent
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
