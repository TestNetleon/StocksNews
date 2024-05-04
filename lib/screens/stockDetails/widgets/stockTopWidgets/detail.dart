import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class StockDetailTopWidgetDetail extends StatelessWidget {
  const StockDetailTopWidgetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
//
    KeyStats? keyStats = provider.data?.keyStats;
    CompanyInfo? companyInfo = provider.data?.companyInfo;
    return Row(
      children: [
        Visibility(
          visible: companyInfo?.image != null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0.sp),
            child: Container(
              padding: EdgeInsets.all(5.sp),
              width: 43.sp,
              height: 43.sp,
              child: ThemeImageView(url: companyInfo?.image ?? ""),

              //  Image.asset(
              //   Images.userPlaceholder,
              //   fit: BoxFit.cover,
              // ),
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
