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

class IndicesItem extends StatelessWidget {
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

  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetails.path,
      arguments: {"slug": data.symbol},
    );
  }

  @override
  Widget build(BuildContext context) {
    IndicesProvider provider = context.watch<IndicesProvider>();

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          StockDetails.path,
          // arguments: data.symbol,
          arguments: {"slug": data.symbol},
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _onTap(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.sp),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 43,
                    height: 43,
                    child: ThemeImageView(url: data.image ?? ""),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: GestureDetector(
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
                    "${data.price}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if ((data.percentageChange ?? 0) > 0)
                        const Icon(
                          Icons.arrow_upward_outlined,
                          color: ThemeColors.accent,
                          size: 12,
                        ),
                      if ((data.percentageChange ?? 0) < 0)
                        const Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                          size: 12,
                        ),
                      Text(
                        "${data.priceChange} (${data.percentageChange}%)",
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: (data.percentageChange ?? 0) > 0
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
                  if (indices) {
                    provider.setOpenIndexIndices(
                      provider.openIndexIndices == index ? -1 : index,
                    );
                  } else {
                    provider.setOpenIndex(
                      provider.openIndex == index ? -1 : index,
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
                    indices
                        ? provider.openIndexIndices == index
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded
                        : provider.openIndex == index
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
              height: indices
                  ? provider.openIndexIndices == index
                      ? null
                      : 0
                  : provider.openIndex == index
                      ? null
                      : 0,
              margin: EdgeInsets.only(
                top: indices
                    ? provider.openIndexIndices == index
                        ? 10.sp
                        : 0
                    : provider.openIndex == index
                        ? 10.sp
                        : 0,
                bottom: indices
                    ? provider.openIndexIndices == index
                        ? 10.sp
                        : 0
                    : provider.openIndex == index
                        ? 10.sp
                        : 0,
              ),
              child: Column(
                children: [
                  InnerRowItem(
                    lable: "Sector",
                    value: "${data.sector}",
                  ),
                  InnerRowItem(
                    lable: "P/E Ratio",
                    value: "${data.peRatio}",
                  ),
                  InnerRowItem(
                    lable: "Market Cap",
                    value: "${data.mktCap}",
                  ),
                  InnerRowItem(
                    lable: "Consensus Analyst Rating",
                    value: "${data.consensusAnalystRating}",
                  ),
                  InnerRowItem(
                    lable: "Analyst Rating Consensus Price Target",
                    value: "${data.analystRatingConsensusPriceTarget}",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
