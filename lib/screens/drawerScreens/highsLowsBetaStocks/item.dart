import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/high_low_beta_stocks_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../stockDetail/index.dart';

class HighLowBetaStocksItem extends StatelessWidget {
  final HighLowBetaStocksRes data;
  // final int index;
  final bool isOpen;
  final Function() onTap;
//
  const HighLowBetaStocksItem({
    required this.data,
    // required this.index,
    required this.isOpen,
    required this.onTap,
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
    // GapUpDownProvider provider = context.watch<GapUpDownProvider>();

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
                  child: ThemeImageView(url: data.image),
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
                  ],
                ),
              ),
            ),
            const SpacerHorizontal(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.price,
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    data.changesPercentage > 0
                        ? Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: data.changesPercentage > 0
                                ? Colors.green
                                : Colors.red,
                          )
                        : Icon(
                            Icons.arrow_downward_rounded,
                            size: 14,
                            color: data.changesPercentage > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${data.change} (${data.changesPercentage}%)",
                            style: stylePTSansRegular(
                              fontSize: 11,
                              color: data.changesPercentage > 0
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
            const SpacerHorizontal(width: 10),
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
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            // height: provider.openIndex == index ? null : 0,
            height: isOpen ? null : 0,
            margin: EdgeInsets.only(
              // top: provider.openIndex == index ? 10.sp : 0,
              top: isOpen ? 10.sp : 0,
              // bottom: provider.openIndex == index ? 10.sp : 0,
              bottom: isOpen ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "Beta",
                  value: "${data.beta}",
                ),
                InnerRowItem(
                  lable: "PE Ratio (TTM)",
                  value: "${data.pe}",
                ),
                InnerRowItem(
                  lable: "Market Cap",
                  value: data.marketCap,
                ),
                InnerRowItem(lable: "Volume", value: "${data.volume}"),
                InnerRowItem(
                  lable: "Average Volume",
                  value: "${data.avgVolume}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
