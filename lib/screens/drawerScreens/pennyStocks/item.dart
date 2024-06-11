import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/penny_stocks.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class PennyStocksItem extends StatelessWidget {
  final PennyStocksRes data;
  // final int index;
  final bool isOpen;
  final Function() onTap;
//
  const PennyStocksItem({
    required this.data,
    // required this.index,
    required this.isOpen,
    required this.onTap,
    super.key,
  });

  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetails.path,
      arguments: {"slug": data.symbol},
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _onTap(context),
                    child: Text(
                      data.symbol,
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
            const SpacerHorizontal(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${data.price ?? "N?A"}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  "${data.change} (${data.changesPercentage}%)",
                  style: stylePTSansRegular(
                    fontSize: 12,
                    color: (data.changesPercentage ?? 0) < 0
                        ? Colors.red
                        : ThemeColors.accent,
                  ),
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
            height: isOpen ? null : 0,
            margin: EdgeInsets.only(
              top: isOpen ? 10.sp : 0,
              bottom: isOpen ? 10.sp : 0,
            ),
            child: Column(
              children: [
                Visibility(
                  visible: data.pe != null,
                  child: InnerRowItem(
                    lable: "PE Ratio",
                    value: "${data.pe}",
                  ),
                ),
                Visibility(
                  visible: data.watchlistandalertlistCount != null,
                  child: InnerRowItem(
                    lable: "Stock News Most Watchlist Or Alert",
                    value: "${data.watchlistandalertlistCount}",
                  ),
                ),
                Visibility(
                  visible: data.mktCap != null,
                  child: InnerRowItem(
                    lable: "Market Cap",
                    value: "${data.mktCap}",
                  ),
                ),
                Visibility(
                  visible: false,
                  child: InnerRowItem(
                    lable: "Exchange",
                    value: "${data.exchange}",
                  ),
                ),
                InnerRowItem(
                  lable: "Volume",
                  value: "${data.volume}",
                ),
                InnerRowItem(
                    lable: "Average Volume", value: "${data.avgVolume}"),
                Visibility(
                  visible: false,
                  child: InnerRowItem(
                    lable: "Dollar Volume",
                    value: data.dollarVolume,
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
