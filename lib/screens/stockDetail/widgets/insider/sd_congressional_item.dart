import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_insider_res.dart';
import 'package:stocks_news_new/providers/high_low_pe.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdCongressionalItem extends StatelessWidget {
  final CongressionalDatum? data;
  final int index;
  const SdCongressionalItem({super.key, this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    HighLowPeProvider provider = context.watch<HighLowPeProvider>();
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "${data?.name}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data?.type ?? "",
                      style: stylePTSansBold(
                          fontSize: 14,
                          color: data?.type == "Purchase"
                              ? ThemeColors.accent
                              : ThemeColors.sos),
                    ),
                    const SpacerVertical(height: 5),
                    GestureDetector(
                      onTap: () {
                        provider.setOpenIndex(
                          provider.openIndex == index ? -1 : index,
                        );
                      },
                      child: Container(
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                          // color: data?.transactionType == "Buy"
                          //     ? ThemeColors.accent
                          //     : data?.transactionType == "Sell"
                          //         ? ThemeColors.sos
                          //         : ThemeColors.white,

                          color: ThemeColors.white,
                        ),
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          provider.openIndex == index
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: ThemeColors.background,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: provider.openIndex == index ? null : 0,
            margin: EdgeInsets.only(
              top: provider.openIndex == index ? 10.sp : 0,
              bottom: provider.openIndex == index ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  label: 'Trade Data',
                  value: "${data!.amount}",
                ),
                InnerRowItem(
                  label: "Date Filed",
                  value: "${data?.dateFiled}",
                ),
                InnerRowItem(
                  label: "Date Traded",
                  value: "${data!.dateTraded}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
