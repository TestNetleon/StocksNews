import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/indices_res.dart';
import 'package:stocks_news_new/providers/indices_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class IndicesItem extends StatefulWidget {
  final IndicesRes data;
  final int index;
  final bool indices;
//
  const IndicesItem({
    required this.data,
    required this.index,
    this.indices = false,
    super.key,
  });

  @override
  State<IndicesItem> createState() => _IndicesItemState();
}

class _IndicesItemState extends State<IndicesItem> {
  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetails.path,
      arguments: {"slug": widget.data.symbol},
    );
  }

  @override
  Widget build(BuildContext context) {
    IndicesProvider provider = context.watch<IndicesProvider>();

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
                  child: ThemeImageView(url: widget.data.image ?? ""),
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
                      widget.data.symbol,
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    widget.data.name,
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
                  "${widget.data.price}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if ((widget.data.percentageChange ?? 0) > 0)
                      const Icon(
                        Icons.arrow_upward_outlined,
                        color: ThemeColors.accent,
                        size: 12,
                      ),
                    if ((widget.data.percentageChange ?? 0) < 0)
                      const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 12,
                      ),
                    Text(
                      "${widget.data.priceChange} (${widget.data.percentageChange}%)",
                      style: stylePTSansRegular(
                        fontSize: 12,
                        color: (widget.data.percentageChange ?? 0) > 0
                            ? ThemeColors.accent
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SpacerHorizontal(width: 10),
            InkWell(
              onTap: () {
                if (widget.indices) {
                  provider.setOpenIndexIndices(
                    provider.openIndexIndices == widget.index
                        ? -1
                        : widget.index,
                  );
                } else {
                  provider.setOpenIndex(
                    provider.openIndex == widget.index ? -1 : widget.index,
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
                  widget.indices
                      ? provider.openIndexIndices == widget.index
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded
                      : provider.openIndex == widget.index
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
            height: widget.indices
                ? provider.openIndexIndices == widget.index
                    ? null
                    : 0
                : provider.openIndex == widget.index
                    ? null
                    : 0,
            margin: EdgeInsets.only(
              top: widget.indices
                  ? provider.openIndexIndices == widget.index
                      ? 10.sp
                      : 0
                  : provider.openIndex == widget.index
                      ? 10.sp
                      : 0,
              bottom: widget.indices
                  ? provider.openIndexIndices == widget.index
                      ? 10.sp
                      : 0
                  : provider.openIndex == widget.index
                      ? 10.sp
                      : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "Sector",
                  value: "${widget.data.sector}",
                ),
                InnerRowItem(
                  lable: "P/E Ratio",
                  value: "${widget.data.peRatio}",
                ),
                InnerRowItem(
                  lable: "Market Cap",
                  value: "${widget.data.mktCap}",
                ),
                InnerRowItem(
                  lable: "Consensus Analyst Rating",
                  value: "${widget.data.consensusAnalystRating}",
                ),
                InnerRowItem(
                  lable: "Analyst Rating Consensus Price Target",
                  value: "${widget.data.analystRatingConsensusPriceTarget}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
