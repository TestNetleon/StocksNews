import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TournamentDefaultItem extends StatelessWidget {
  final TradingSearchTickerRes data;
  const TournamentDefaultItem({
    required this.data,
    super.key,
  });

  Future _onTap({String? symbol}) async {
    Navigator.pop(navigatorKey.currentContext!, symbol);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _onTap(symbol: data.symbol);
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0.sp),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 48,
                    height: 48,
                    child: CachedNetworkImagesWidget(data.image ?? ""),
                  ),
                ),
                const SpacerHorizontal(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.symbol ?? "",
                        style: styleGeorgiaBold(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        data.name ?? "",
                        style: styleGeorgiaRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Row(
                        children: const [
                          // RichText(
                          //   text: TextSpan(
                          //     children: [
                          //       TextSpan(
                          //         text: "Mentions: ${data.mention?.toInt()} ",
                          //         style: stylePTSansRegular(fontSize: 12),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Flexible(
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: [
                          //         TextSpan(
                          //           text:
                          //               "(${data.mentionChange.toCurrency()}%)",
                          //           style: stylePTSansRegular(
                          //             fontSize: 12,
                          //             color: data.mentionChange >= 0
                          //                 ? ThemeColors.accent
                          //                 : ThemeColors.sos,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${data.currentPrice?.toFormattedPrice()}',
                      style: stylePTSansBold(fontSize: 18),
                    ),
                    const SpacerVertical(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${data.change?.toFormattedPrice()} (${data.changesPercentage}%)",
                            style: stylePTSansRegular(
                              fontSize: 14,
                              color: (data.changesPercentage ?? 0) >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
