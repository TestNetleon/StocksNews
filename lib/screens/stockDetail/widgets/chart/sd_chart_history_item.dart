import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/chart.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdChartHistory extends StatelessWidget {
  final PriceHistory? data;
  final bool isOpen;
  final Function() onTap;
//
  const SdChartHistory({
    required this.data,
    required this.isOpen,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data?.date}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerHorizontal(width: 10),
                Text(
                  "${data?.openingPrice}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerHorizontal(width: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data?.closingPrice ?? "",
                          style: stylePTSansBold(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "(${data?.changePercent ?? ""}%)",
                          style: stylePTSansBold(
                            fontSize: 14,
                            color: data?.changePercent > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SpacerVertical(height: 5),
                    InkWell(
                      onTap: onTap,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ThemeColors.accent,
                        ),
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          // provider.openIndex == index
                          isOpen
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: isOpen ? null : 0,
            margin: EdgeInsets.only(
              top: isOpen ? 10.sp : 0,
              bottom: isOpen ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "High",
                  value: "${data?.high}",
                ),
                InnerRowItem(
                  lable: "Low",
                  value: "${data?.low}",
                ),
                InnerRowItem(
                  lable: "Volume",
                  value: "${data?.volume}",
                ),
                InnerRowItem(
                  lable: "Market Capitalization",
                  value: "${data?.marketCapitalization}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
