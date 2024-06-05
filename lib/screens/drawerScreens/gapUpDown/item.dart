import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/gap_up_down_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class UpDownStocksItem extends StatelessWidget {
  final GapUpRes data;
  final int index;
//
  const UpDownStocksItem({
    required this.data,
    required this.index,
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
    GapUpDownProvider provider = context.watch<GapUpDownProvider>();

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
                  data.price,
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  "${data.priceChangeSinceOpen}%",
                  style: stylePTSansRegular(
                    fontSize: 12,
                    color: "${data.priceChangeSinceOpen}".contains("-")
                        ? Colors.red
                        : ThemeColors.accent,
                  ),
                ),
              ],
            ),
            const SpacerHorizontal(width: 10),
            InkWell(
              onTap: () {
                provider.setOpenIndex(
                  provider.openIndex == index ? -1 : index,
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: ThemeColors.accent,
                ),
                margin: EdgeInsets.only(left: 8.sp),
                padding: const EdgeInsets.all(3),
                child: Icon(
                  provider.openIndex == index
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
            height: provider.openIndex == index ? null : 0,
            margin: EdgeInsets.only(
              top: provider.openIndex == index ? 10.sp : 0,
              bottom: provider.openIndex == index ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "Gap Up%",
                  value: "${data.gapPer}%",
                  valueColor: "${data.gapPer}".contains("-")
                      ? Colors.red
                      : ThemeColors.accent,
                ),
                InnerRowItem(
                  lable: "Opening Price",
                  value: "${data.open}",
                ),
                InnerRowItem(
                  lable: "Previous Close",
                  value: "${data.previousClose}",
                ),
                InnerRowItem(
                    lable: "Price Change Since Open",
                    value: "${data.priceChangeSinceOpen}"),
                InnerRowItem(
                  lable: "Daily Volume",
                  value: data.volume,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
