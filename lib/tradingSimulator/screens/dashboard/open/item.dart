import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_open_list_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class TsOpenListItem extends StatelessWidget {
  final TsOpenListRes? item;
  final Function()? onTap;
  const TsOpenListItem({super.key, this.item, this.onTap});

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
                      Visibility(
                        visible: item?.company != null && item?.company != '',
                        child: Text(
                          "${item?.company}",
                          style: styleGeorgiaBold(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SpacerVertical(height: 5),
                      Row(
                        children: [
                          Visibility(
                            visible: item?.currentPrice != null,
                            child: Flexible(
                              child: Text(
                                "${item?.currentPrice?.toFormattedPrice()}",
                                style: styleGeorgiaRegular(
                                  // color: ThemeColors.greyText,
                                  fontSize: 14,
                                ),
                                // maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: item?.change != null,
                            child: Flexible(
                              child: Text(
                                "  ${item?.change?.toFormattedPrice()}",
                                style: styleGeorgiaRegular(
                                  color: (item?.change ?? 0) < 0
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 14,
                                ),
                                // maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: item?.quantity != null,
                      child: Text(
                        "${item?.quantity} QTY",
                        style: stylePTSansBold(fontSize: 18),
                      ),
                    ),
                    Visibility(
                      visible: item?.avgPrice != null && item?.avgPrice != '',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Avg. ${item?.avgPrice?.toFormattedPrice()}",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Divider(color: ThemeColors.greyBorder, height: 10),
            const SpacerVertical(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: item?.invested != null,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(right: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invested",
                            style: stylePTSansRegular(
                              color: ThemeColors.greyText,
                              fontSize: 13,
                            ),
                          ),
                          const SpacerVertical(height: 3),
                          Text(
                            textAlign: TextAlign.start,
                            "${item?.invested?.toFormattedPrice()}",
                            style: stylePTSansBold(
                                color: ThemeColors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: item?.currentInvested != null,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Current",
                            style: stylePTSansRegular(
                              color: ThemeColors.greyText,
                              fontSize: 13,
                            ),
                          ),
                          const SpacerVertical(height: 3),
                          Text(
                            textAlign: TextAlign.center,
                            "${item?.currentInvested?.toFormattedPrice() ?? 0}",
                            style: stylePTSansBold(
                                color: ThemeColors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: item?.investedChange != null,
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Change",
                            style: stylePTSansRegular(
                              color: ThemeColors.greyText,
                              fontSize: 13,
                            ),
                          ),
                          const SpacerVertical(height: 3),
                          Text(
                            textAlign: TextAlign.end,
                            item?.investedChange == 0
                                ? '0'
                                : "${item?.investedChange?.toFormattedPrice() ?? 0} (${item?.investedChangePercentage?.toCurrency() ?? 0}%)",
                            style: stylePTSansBold(
                              color: (item?.investedChange ?? 0) < 0
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
