import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomePlaidItem extends StatelessWidget {
  final PlaidDataRes? data;
  const HomePlaidItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(5),
                      child: CachedNetworkImagesWidget(
                        data?.image,
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data?.tickerSymbol}",
                          style: stylePTSansBold(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SpacerVertical(height: 5),
                        Visibility(
                          visible: data?.name != null && data?.name != '',
                          child: Text(
                            "${data?.name}",
                            style: stylePTSansRegular(
                              color: ThemeColors.greyText,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data?.closePrice ?? "",
                  style: stylePTSansBold(fontSize: 14),
                ),
                const SpacerVertical(height: 5),
                Text(
                  "${data?.change} (${data?.changesPercentage})%",
                  style: stylePTSansRegular(
                    fontSize: 12,
                    color: (data?.changesPercentage ?? 0) > 0
                        ? ThemeColors.accent
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),

        // const SpacerVertical(height: 15),

        const Divider(
          color: ThemeColors.greyBorder,
          height: 15,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "QTY",
              style: stylePTSansRegular(fontSize: 13),
            ),
            Flexible(
              child: Text(
                "${data?.qty}",
                style: stylePTSansRegular(fontSize: 13),
              ),
            ),
          ],
        ),
        const SpacerVertical(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current value (QTY X Close price)",
              style: stylePTSansRegular(fontSize: 13),
            ),
            Flexible(
              child: Text(
                "${data?.investmentValue}",
                style: stylePTSansRegular(fontSize: 13),
              ),
            ),
          ],
        ),

        // Visibility(
        //   visible: (data?.type != '' && data?.type != null) ||
        //       (data?.closePriceAsOf != "" && data?.closePriceAsOf != null),
        //   child: const SpacerVertical(height: 20),
        // ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 5),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: Align(
        //           alignment: Alignment.centerLeft,
        //           child: Visibility(
        //             visible: data?.closePrice != '' && data?.closePrice != null,
        //             child: Column(
        //               children: [
        //                 Text(
        //                   "Close Price",
        //                   style: stylePTSansRegular(fontSize: 13),
        //                 ),
        //                 Text(
        //                   data?.closePrice ?? "",
        //                   style: stylePTSansRegular(
        //                     color: ThemeColors.greyText,
        //                     fontSize: 14,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Align(
        //           alignment: Alignment.centerRight,
        //           child: Visibility(
        //             visible: data?.closePriceAsOf != "" &&
        //                 data?.closePriceAsOf != null,
        //             child: Column(
        //               children: [
        //                 Text(
        //                   "Close price as of",
        //                   style: stylePTSansRegular(fontSize: 13),
        //                 ),
        //                 Text(
        //                   data?.closePriceAsOf ?? "N/A",
        //                   style: stylePTSansRegular(
        //                     color: ThemeColors.greyText,
        //                     fontSize: 14,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 5),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Visibility(
        //         visible: data?.closePrice != '' && data?.closePrice != null,
        //         child: Text(
        //           data?.closePrice ?? "",
        //           style: stylePTSansRegular(),
        //         ),
        //       ),
        //       Visibility(
        //         visible:
        //             data?.closePriceAsOf != "" && data?.closePriceAsOf != null,
        //         child: Text(
        //           "Close price as of: ${data?.closePriceAsOf ?? "N/A"}",
        //           style: stylePTSansRegular(
        //             color: ThemeColors.greyText,
        //             fontSize: 14,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
