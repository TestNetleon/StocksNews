import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/dividends_res.dart';
import 'package:stocks_news_new/providers/dividends_provider.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../stockDetail/index.dart';

class DividendsItem extends StatelessWidget {
  final DividendsRes data;
  final int index;
  final bool dividends;
//
  const DividendsItem({
    required this.data,
    required this.index,
    this.dividends = false,
    super.key,
  });

  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetail.path,
      arguments: {"slug": data.symbol},
    );
  }

  @override
  Widget build(BuildContext context) {
    DividendsProvider provider = context.watch<DividendsProvider>();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _onTap(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.sp),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 43,
                  height: 43,
                  child: ThemeImageView(url: data.image ?? ""),
                ),
              ),
            ),
            const SpacerHorizontal(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _onTap(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.symbol,
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: 5),
                    Text(
                      data.name,
                      style: stylePTSansRegular(
                        color: ThemeColors.greyText,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // const SpacerVertical(height: 5),
                    // Text(
                    //   "${data.price}",
                    //   style: stylePTSansBold(fontSize: 14),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),
            ),
            const SpacerHorizontal(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${data.date}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // const SpacerVertical(height: 5),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     data.percentageChange > 0
                //         ? Icon(
                //             Icons.arrow_upward,
                //             size: 14,
                //             color: data.percentageChange > 0
                //                 ? Colors.green
                //                 : Colors.red,
                //           )
                //         : Icon(
                //             Icons.arrow_downward_rounded,
                //             size: 14,
                //             color: data.percentageChange > 0
                //                 ? Colors.green
                //                 : Colors.red,
                //           ),
                //     RichText(
                //       text: TextSpan(
                //         children: [
                //           TextSpan(
                //             text:
                //                 "${data.priceChange} (${data.percentageChange}%)",
                //             style: stylePTSansRegular(
                //               fontSize: 11,
                //               color: data.percentageChange > 0
                //                   ? Colors.green
                //                   : Colors.red,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // // Text(
                // //   data.change.toString(),
                // //   style: stylePTSansRegular(
                // //     fontSize: 12,
                // //     color: (data.change ?? 0) > 0
                // //         ? ThemeColors.accent
                // //         : Colors.red,
                // //   ),
                // // ),
              ],
            ),
            const SpacerHorizontal(width: 10),
            InkWell(
              onTap: () {
                if (dividends) {
                  provider.setOpenIndexDividendsStocks(
                    provider.openIndexDividendsStocks == index ? -1 : index,
                  );
                } else {
                  provider.setOpenIndex(
                    provider.openIndex == index ? -1 : index,
                  );
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: ThemeColors.accent,
                ),
                margin: EdgeInsets.only(left: 8.sp),
                padding: const EdgeInsets.all(3),
                child: Icon(
                  dividends
                      ? provider.openIndexDividendsStocks == index
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded
                      : provider.openIndex == index
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                  size: 16,
                ),
              ),
            )
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: dividends
                ? provider.openIndexDividendsStocks == index
                    ? null
                    : 0
                : provider.openIndex == index
                    ? null
                    : 0,
            margin: EdgeInsets.only(
              top: dividends
                  ? provider.openIndexDividendsStocks == index
                      ? 10.sp
                      : 0
                  : provider.openIndex == index
                      ? 10.sp
                      : 0,
              bottom: dividends
                  ? provider.openIndexDividendsStocks == index
                      ? 10.sp
                      : 0
                  : provider.openIndex == index
                      ? 10.sp
                      : 0,
            ),
            child: Column(
              children: [
                // Visibility(
                //   visible: data.date != null,
                //   child: InnerRowItem(
                //     lable: "Date",
                //     value: "${data.date}",
                //   ),
                // ),
                Visibility(
                  visible: data.exchangeShortName != null,
                  child: InnerRowItem(
                    lable: "Price",
                    value: "${data.price}",
                  ),
                ),
                Visibility(
                  visible: data.exchangeShortName != null,
                  child: InnerRowItem(
                    lable: "Price Change",
                    value: "${data.priceChange}",
                  ),
                ),
                Visibility(
                  visible: data.exchangeShortName != null,
                  child: InnerRowItem(
                    lable: "Percentage Change",
                    value: "${data.percentageChange}%",
                  ),
                ),
                Visibility(
                  visible: data.exchangeShortName != null,
                  child: InnerRowItem(
                    lable: "Exchange",
                    value: "${data.exchangeShortName}",
                  ),
                ),
                Visibility(
                  visible: data.adjDividend != null,
                  child: InnerRowItem(
                    lable: "Adj Dividend",
                    value: "${data.adjDividend}",
                  ),
                ),
                Visibility(
                  visible: data.dividend != null,
                  child: InnerRowItem(
                    lable: "Dividend",
                    value: "${data.dividend}",
                  ),
                ),
                Visibility(
                  visible: data.recordDate != null,
                  child: InnerRowItem(
                    lable: "Record Date",
                    value: "${data.recordDate}",
                  ),
                ),
                Visibility(
                  visible: data.paymentDate != null,
                  child: InnerRowItem(
                    lable: "Payment Date",
                    value: "${data.paymentDate}",
                  ),
                ),
                Visibility(
                  visible: data.declarationDate != null,
                  child: InnerRowItem(
                    lable: "Declaration Date",
                    value: "${data.declarationDate}",
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
