import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdTopWidgetDetail extends StatelessWidget {
  const SdTopWidgetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;
    // CompanyInfo? companyInfo = provider.tabRes?.companyInfo;
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visibility(
        //   visible: true,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.white,
        //       ),
        //       padding: const EdgeInsets.all(10),
        //       width: 70,
        //       height: 70,
        //       child: ThemeImageView(url: companyInfo?.image ?? ""),
        //     ),
        //   ),
        // ),
        // const SpacerHorizontal(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.greyBorder,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    "Stock Price",
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ),
                Text(
                  "\$ USD",
                  style: stylePTSansRegular(fontSize: 12),
                ),
              ],
            ),
            SpacerVertical(height: 10),
            Text(keyStats?.price ?? "", style: stylePTSansBold(fontSize: 26)),
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

        // SpacerHorizontal(width: 20),
        SizedBox(
          height: 50,
          width: 60,
          child: VerticalDivider(
            color: ThemeColors.greyText,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.greyBorder,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              margin: EdgeInsets.only(right: 5),
              child: Text(
                "Mkt Cap",
                style: stylePTSansRegular(fontSize: 12),
              ),
            ),
            SpacerVertical(height: 10),
            Text(
              keyStats?.marketCap ?? "",
              style: stylePTSansBold(fontSize: 26),
            ),
            // Visibility(
            //   visible: keyStats?.change != null,
            //   child: Row(
            //     children: [
            //       Icon(
            //         (keyStats?.change ?? 0) > 0
            //             ? Icons.arrow_drop_up
            //             : Icons.arrow_drop_down,
            //         color: (keyStats?.change ?? 0) > 0
            //             ? ThemeColors.accent
            //             : Colors.red,
            //         size: 20.sp,
            //       ),
            //       Text(
            //         "${keyStats?.changeWithCur} (${keyStats?.changesPercentage?.toCurrency()}%)",
            //         style: stylePTSansBold(
            //           fontSize: 12,
            //           color: (keyStats?.change ?? 0) > 0
            //               ? ThemeColors.accent
            //               : Colors.red,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),

        // SizedBox(
        //   height: 50,
        //   width: 60,
        //   child: VerticalDivider(
        //     color: ThemeColors.greyText,
        //   ),
        // ),
        // GestureDetector(
        //   onTap: () {
        //     commonShare(
        //       title:
        //           "${provider.tabRes?.keyStats?.name} (${provider.tabRes?.keyStats?.symbol})",
        //       url: provider.tabRes?.shareUrl ?? "",
        //     );
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Color.fromARGB(236, 2, 78, 5),
        //     ),
        //     padding: EdgeInsets.all(20),
        //     child: const Icon(Icons.share_outlined, size: 18),
        //   ),
        // )

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(keyStats?.price ?? "", style: stylePTSansBold(fontSize: 32)),
        //     const SpacerVertical(height: 2),
        //     Visibility(
        //       visible: keyStats?.change != null,
        //       child: Row(
        //         children: [
        //           Icon(
        //             (keyStats?.change ?? 0) > 0
        //                 ? Icons.arrow_drop_up
        //                 : Icons.arrow_drop_down,
        //             color: (keyStats?.change ?? 0) > 0
        //                 ? ThemeColors.accent
        //                 : Colors.red,
        //             size: 20.sp,
        //           ),
        //           Text(
        //             "${keyStats?.changeWithCur} (${keyStats?.changesPercentage?.toCurrency()}%)",
        //             style: stylePTSansBold(
        //               fontSize: 12,
        //               color: (keyStats?.change ?? 0) > 0
        //                   ? ThemeColors.accent
        //                   : Colors.red,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
