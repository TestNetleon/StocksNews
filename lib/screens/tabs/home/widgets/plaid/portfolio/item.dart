import 'package:flutter/material.dart';
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
                        Row(
                          children: [
                            Text(
                              "${data?.tickerSymbol}",
                              style: stylePTSansBold(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpacerHorizontal(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: ThemeColors.accent,
                              ),
                              child: Text(
                                "${data?.type}",
                                style: styleGeorgiaBold(fontSize: 10),
                              ),
                            ),
                          ],
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
                  "${data?.change} (${data?.changesPercentage}%)",
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Investment type",
        //       style: stylePTSansRegular(fontSize: 13),
        //     ),
        //     Flexible(
        //       child: Text(
        //         "${data?.type}",
        //         style:
        //             styleGeorgiaBold(fontSize: 13, color: ThemeColors.accent),
        //       ),
        //     ),
        //   ],
        // ),
        const SpacerVertical(height: 5),

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
      ],
    );
  }
}
