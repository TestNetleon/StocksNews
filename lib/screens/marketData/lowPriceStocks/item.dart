import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/low_price_stocks_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';

import '../../../utils/colors.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/theme.dart';
import '../../../widgets/cache_network_image.dart';
import '../../../widgets/spacer_horizontal.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../stockDetail/index.dart';

class LowPriceStocksItem extends StatelessWidget {
  final LowPriceStocksRes data;
  const LowPriceStocksItem({super.key, required this.data});

  void _openBottomSheet() {
    showPlatformBottomSheet(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      context: navigatorKey.currentContext!,
      showClose: false,
      enableDrag: true,
      content: Container(
        padding: EdgeInsets.all(18.sp),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              // ThemeColors.greyBorder,
              Color.fromARGB(255, 48, 48, 48),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "P/E Ratio: ",
                  style: stylePTSansRegular(),
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.end,
                    "${data.pe ?? "N/A"}",
                    style: stylePTSansRegular(),
                  ),
                ),
              ],
            ),
            const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Market Cap: ",
                  style: stylePTSansRegular(),
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.end,
                    data.mktCap ?? "N/A",
                    style: stylePTSansRegular(),
                  ),
                ),
              ],
            ),
            const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Avg. Trading Volume: ",
                  style: stylePTSansRegular(),
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.end,
                    data.avgVolume ?? "N/A",
                    style: stylePTSansRegular(),
                  ),
                ),
              ],
            ),
            const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Consensus Rating: ",
                  style: stylePTSansRegular(),
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.end,
                    data.consensusRating ?? "N/A",
                    style: stylePTSansRegular(),
                  ),
                ),
              ],
            ),
            const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Consensus Price Target: ",
                  style: stylePTSansRegular(),
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.end,
                    "${data.priceTarget ?? "N/A"}",
                    style: stylePTSansRegular(),
                  ),
                ),
              ],
            ),
            const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            ),
            CustomReadMoreText(
              text: data.description ?? "",
            )
            // ReadMoreText(
            //   textAlign: TextAlign.start,
            //   data.description ?? "",
            //   trimLines: 5,
            //   colorClickableText: ThemeColors.accent,
            //   trimMode: TrimMode.Line,
            //   trimCollapsedText: 'Read more',
            //   trimExpandedText: 'Read less',
            //   moreStyle: stylePTSansRegular(color: ThemeColors.accent),
            //   style: stylePTSansRegular(height: 1.4),
            // ),
          ],
        ),
      ),
    );
  }

  void _onTap(context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => StockDetail(symbol: data.symbol)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openBottomSheet();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _onTap(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 48,
                  height: 48,
                  // child: ThemeImageView(
                  //   url: "${data?.image}",
                  // ),
                  child: CachedNetworkImagesWidget(
                    data.image,
                    placeHolder: Images.placeholder,
                  ),
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
                    InkWell(
                      onTap: () => _onTap(context),
                      child: Text(
                        data.symbol ?? "",
                        style: stylePTSansBold(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SpacerVertical(height: 5),
                    Text(
                      data.name ?? "",
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${data.price ?? ""}",
                    style: stylePTSansBold(fontSize: 18),
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
                              text:
                                  "${data.change} (${data.changesPercentage}%)",
                              style: stylePTSansRegular(
                                fontSize: 14,
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
            ),
          ],
        ),
      ),
    );
  }
}
