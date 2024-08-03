import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_insider_res.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdCongressionalItem extends StatelessWidget {
  final CongressionalDatum? data;
  final bool isOpen;
  final Function() onTap;
//
  const SdCongressionalItem({
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
