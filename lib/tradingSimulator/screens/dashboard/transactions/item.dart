import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class TsTransactionListItem extends StatelessWidget {
  final TsPendingListRes? item;
  final Function()? onTap;
  const TsTransactionListItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
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
                            visible:
                                item?.company != null && item?.company != '',
                            child: Text(
                              "${item?.company}",
                              style: styleGeorgiaBold(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Visibility(
                            visible: item?.currentPrice != null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Price: ${item?.currentPrice?.toFormattedPrice()}",
                                style: styleGeorgiaRegular(
                                  // color: ThemeColors.greyText,
                                  fontSize: 14,
                                ),
                                // maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
                            "${item?.quantity} Qty",
                            style: stylePTSansBold(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            item?.tradeStatus == 'PENDING'
                                ? "Price at Market"
                                : 'Executed at: ${item?.price ?? '0'}',
                            style: stylePTSansRegular(fontSize: 14),
                          ),
                        ),
                        Visibility(
                          visible: item?.tradeStatus != 'PENDING' &&
                              item?.investedValue != null &&
                              item?.investedValue != '',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Order value: ${item?.investedValue}',
                              style: stylePTSansRegular(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: item?.tradeType == "Buy"
                  ? ThemeColors.themeGreen
                  : ThemeColors.darkRed,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
