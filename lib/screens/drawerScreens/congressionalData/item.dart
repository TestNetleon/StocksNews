import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/congressional_res.dart';
import 'package:stocks_news_new/providers/high_low_pe.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';

class CongressionalItem extends StatelessWidget {
  final CongressionalRes? data;
  final int index;
  const CongressionalItem({super.key, this.data, required this.index});
  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetails.path,
      arguments: {"slug": data?.symbol},
    );
  }

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
                  child: InkWell(
                    onTap: () => _onTap(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data?.name}",
                          style: stylePTSansBold(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SpacerVertical(height: 3),
                        Text(
                          "${data?.symbol}",
                          style: stylePTSansBold(
                            fontSize: 13,
                            color: ThemeColors.accent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SpacerVertical(height: 3),
                        Text(
                          "${data?.company}",
                          style: stylePTSansBold(
                              fontSize: 14, color: ThemeColors.greyText),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SpacerVertical(height: 3),
                      ],
                    ),
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
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Text(
            //     "${data?.amount} Shares @ ${data?.currentPrice}",
            //     style: stylePTSansRegular(
            //       color: ThemeColors.greyText,
            //       fontSize: 12,
            //     ),
            //     maxLines: 2,
            //     textAlign: TextAlign.end,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
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
                  lable: "Current Price ",
                  value: "${data!.currentPrice}",
                ),
                InnerRowItem(
                  lable: "Trade Data",
                  value: "${data?.amount}",
                ),
                InnerRowItem(
                  lable: "Date Filed",
                  value: "${data!.dateFiled}",
                ),
                InnerRowItem(
                  lable: "Date Traded",
                  value: "${data?.dateTraded}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
