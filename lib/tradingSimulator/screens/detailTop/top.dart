import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../utils/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../modals/ts_topbar.dart';
import '../../providers/trade_provider.dart';

//MARK: Simulator Top
class TsTopWidget extends StatelessWidget {
  const TsTopWidget({this.showRating = false, super.key});
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TsTopWidgetDetail(),
          const SdTopDisclaimer(),
        ],
      ),
    );
  }
}

//MARK: Simulator Top Detail
class TsTopWidgetDetail extends StatelessWidget {
  const TsTopWidgetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    TsStockDetailRes? data = provider.detailRes;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            SpacerVertical(height: 10),
            Text(
              data?.currentPrice?.toFormattedPrice() ?? '\$0',
              style: stylePTSansBold(fontSize: 26),
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
                        ? ThemeColors.accent
                        : Colors.red,
                    size: 20,
                  ),
                  Text(
                    "${data?.change?.toFormattedPrice() ?? '\$0'} (${data?.changePercentage?.toCurrency() ?? 0}%)",
                    style: stylePTSansBold(
                      fontSize: 12,
                      color: (data?.change ?? 0) >= 0
                          ? ThemeColors.accent
                          : Colors.red,
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
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.greyBorder,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  margin: EdgeInsets.only(right: 0),
                  child: Text(
                    "MKT Cap",
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ),
                SpacerVertical(height: 10),
                AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  data?.marketCap ?? "",
                  style: stylePTSansBold(fontSize: 26),
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
class SdTopDisclaimer extends StatelessWidget {
  const SdTopDisclaimer({super.key});
  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    TsStockDetailRes? data = provider.detailRes;
    if (data?.marketType == null || data?.marketType == '') {
      return const SizedBox();
    }
    return Padding(
        padding: EdgeInsets.only(left: 5),
        child: Text(
          data?.marketType == 'PreMarket'
              ? 'Pre-Market: ${data?.marketTime}'
              : 'Post-Market: ${data?.marketTime}',
          style: styleGeorgiaRegular(
            color: ThemeColors.greyText,
            fontSize: 12,
          ),
        ));
  }
}
