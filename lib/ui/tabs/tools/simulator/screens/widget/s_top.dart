import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


//MARK: Simulator Top
class STopWidget extends StatelessWidget {
  const STopWidget({this.showRating = false, super.key});
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const STopWidgetDetail(),
          const STopDisclaimer(),
        ],
      ),
    );
  }
}

//MARK: Simulator Top Detail
class STopWidgetDetail extends StatelessWidget {
  const STopWidgetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    TradeManager manager = context.watch<TradeManager>();
    BaseTickerRes? data = manager.detailRes;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.greyBorder,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    "Stock Price",
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ),
                Text(
                  "\$ USD",
                  style: stylePTSansRegular(fontSize: 12),
                ),
              ],
            ),
            SpacerVertical(height: 10),*/
            Text(
              data?.price?.toFormattedPrice() ?? '\$0',
              style: stylePTSansBold(fontSize: 28,color: ThemeColors.splashBG),
            ),
            Visibility(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    (data?.change ?? 0) >= 0
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: (data?.change ?? 0) >= 0
                        ? ThemeColors.success120
                        : ThemeColors.error120,
                    size: 20,
                  ),
                  Text(
                    "${data?.change?.toFormattedPrice() ?? '\$0'} (${data?.changesPercentage?.toCurrency() ?? 0}%)",
                    style: stylePTSansBold(
                      fontSize: 12,
                      color: (data?.change ?? 0) >= 0
                          ? ThemeColors.success120
                          : ThemeColors.error120,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SpacerHorizontal(width: 20),
        Visibility(
          visible: data?.marketCap != null && data?.marketCap != '',
          child: Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  data?.marketCap ?? "",
                  style: stylePTSansBold(fontSize: 28,color: ThemeColors.splashBG),
                ),
                SpacerVertical(height: Pad.pad5),
                Text(
                  "MKT Cap",
                  style: stylePTSansRegular(fontSize: 12,color: ThemeColors.neutral40),
                ),


              ],
            ),
          ),
        ),
      ],
    );
  }
}

//MARK: Simulator Top Disclaimer
class STopDisclaimer extends StatelessWidget {
  const STopDisclaimer({super.key});
  @override
  Widget build(BuildContext context) {
    TradeManager manager = context.watch<TradeManager>();
    BaseTickerRes? data = manager.detailRes;
    if (data?.marketType == null || data?.marketType == '') {
      return const SizedBox();
    }
    return Padding(
        padding: EdgeInsets.only(left: Pad.pad5),
        child: Text(
          data?.marketType == 'PreMarket'
              ? 'Pre-Market: ${data?.marketTime ?? ''}'
              : 'Post-Market: ${data?.marketTime ?? ''}',
          style: styleGeorgiaRegular(
            color: ThemeColors.neutral40,
            fontSize: 12,
          ),
        ));
  }
}
