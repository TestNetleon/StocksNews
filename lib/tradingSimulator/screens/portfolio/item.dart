import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_portfolio_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class TsPortfolioListItem extends StatelessWidget {
  final TsPortfolioRes? item;
  final Function()? onTap;
  const TsPortfolioListItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(url: item?.image ?? ""),
                  ),
                ),
                const SpacerHorizontal(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item?.symbol ?? "",
                        style: styleGeorgiaBold(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       item?.symbol ?? "",
                      //       style: styleGeorgiaBold(fontSize: 18),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //     SpacerHorizontal(width: 5),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(40),
                      //         color: item?.orderType == 'buy'
                      //             ? ThemeColors.accent
                      //             : ThemeColors.sos,
                      //       ),
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 10, vertical: 2),
                      //       child: Text(
                      //         // item?.buy == true ? "Buy" : "Sell",
                      //         item?.orderType ?? "",
                      //         style: stylePTSansBold(fontSize: 12),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SpacerVertical(height: 5),
                      Text(
                        item?.symbol ?? "",
                        style: styleGeorgiaRegular(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${item?.price}",
                        style: stylePTSansBold(fontSize: 18)),
                    const SpacerVertical(height: 5),
                    // RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text:
                    //             "${item?.change} (${item?.changePercentage?.toCurrency()}%)",
                    //         style: stylePTSansRegular(
                    //           fontSize: 14,
                    //           color: (item?.changePercentage ?? 0) > 0
                    //               ? Colors.green
                    //               : Colors.red,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
            // const SpacerVertical(height: 5),
            const Divider(color: ThemeColors.greyBorder, height: 20),
            // const SpacerVertical(height: 5),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       const Icon(
            //         Icons.cases_outlined,
            //         size: 14,
            //       ),
            //       const SpacerHorizontal(width: 5),
            //       Text(
            //         "${item?.quantity ?? "N/A"} Qty",
            //         style: stylePTSansRegular(fontSize: 14),
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ],
            //   ),
            // ),
            // const SpacerVertical(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        "Quantity",
                        style: stylePTSansRegular(
                          color: ThemeColors.greyText,
                          fontSize: 13,
                        ),
                      ),
                      const SpacerVertical(height: 3),
                      Text(
                        "${item?.quantity}",
                        // item?.totalAmount == null
                        //     ? item?.totalAmount?.toCurrency() ?? "N/A"
                        //     : "\$${item?.totalAmount?.toCurrency() ?? "N/A"}",
                        style: stylePTSansBold(
                            color: ThemeColors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 40),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        "Total Amount",
                        style: stylePTSansRegular(
                          color: ThemeColors.greyText,
                          fontSize: 13,
                        ),
                      ),
                      const SpacerVertical(height: 3),
                      Text(
                        item?.totalAmount,
                        // == null
                        //     ? (item?.totalAmount?.toCurrency()) ?? "N/A"
                        //     : "\$${item?.totalAmount?.toCurrency() ?? "N/A"}",
                        style: stylePTSansBold(
                            color: ThemeColors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // const SpacerHorizontal(width: 40),
                // Flexible(
                //   child: Column(
                //     children: [
                //       Text(
                //         "4.33%",
                //         style: stylePTSansRegular(
                //           color: ThemeColors.sos,
                //           fontSize: 13,
                //         ),
                //       ),
                //       const SpacerVertical(height: 3),
                //       Text(
                //         "-\$0.22",
                //         style: stylePTSansBold(
                //             color: ThemeColors.sos, fontSize: 14),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            // // Text(
            // //   "QTY: ${order?.shares ?? "N/A"}",
            // //   style: styleGeorgiaBold(fontSize: 15),
            // //   maxLines: 1,
            // //   overflow: TextOverflow.ellipsis,
            // // ),
            // // const SpacerVertical(height: 5),
            // // Text(
            // //   order?.invested == null
            // //       ? "Invested: ${order?.invested?.toCurrency() ?? "N/A"}"
            // //       : "Invested: \$${order?.invested?.toCurrency() ?? "N/A"}",
            // //   style: styleGeorgiaBold(fontSize: 15),
            // //   maxLines: 1,
            // //   overflow: TextOverflow.ellipsis,
            // // ),
            // const SpacerVertical(height: 10),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Text(
            //     DateFormat().format(DateTime.now()),
            //     style: stylePTSansRegular(
            //         fontSize: 13, color: ThemeColors.greyText),
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
