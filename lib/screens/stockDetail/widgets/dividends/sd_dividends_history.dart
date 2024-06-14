import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/ownership/ownership_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdDividendsHistory extends StatelessWidget {
  final DividendHistory? data;
  final bool isOpen;
  final Function() onTap;
//
  const SdDividendsHistory({
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
                Expanded(
                  flex: 2,
                  child: Text(
                    "${data?.announced}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data?.amount ?? "",
                      style: stylePTSansBold(
                        fontSize: 14,
                      ),
                    ),
                    const SpacerVertical(height: 5),
                    InkWell(
                      onTap: onTap,
                      // onTap: () {
                      //   provider.setOpenIndex(
                      //     provider.openIndex == index ? -1 : index,
                      //   );
                      // },
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
                  lable: "Yield",
                  value: "${data?.dividendHistoryYield}",
                ),
                InnerRowItem(
                  lable: "Ex-Dividend Date",
                  value: "${data?.exDividendDate}",
                ),
                InnerRowItem(
                  lable: "Record Date",
                  value: "${data?.recordDate}",
                ),
                InnerRowItem(
                  lable: "Payable Date",
                  value: "${data?.payableDate}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
