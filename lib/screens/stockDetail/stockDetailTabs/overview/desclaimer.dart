import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

//
class SdTopDisclaimer extends StatelessWidget {
  const SdTopDisclaimer({super.key});
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;

    if (keyStats?.exchange == null || keyStats?.marketStatus == null) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: provider.tabRes?.marketType != null &&
              provider.tabRes?.marketType != ''
          ? Text(
              provider.tabRes?.marketType == 'PreMarket'
                  ? 'Pre-Market: ${provider.tabRes?.marketTime}'
                  : 'Post-Market: ${provider.tabRes?.marketTime}',
              style: styleGeorgiaRegular(
                color: ThemeColors.greyText,
                fontSize: 12,
              ),
            )
          : Visibility(
              visible: keyStats?.marketStatus != null,
              child: Row(
                children: [
                  const Icon(
                    Icons.watch_later,
                    size: 15,
                    color: ThemeColors.greyText,
                  ),
                  const SpacerHorizontal(width: 5),
                  Text(
                    keyStats?.marketStatus ?? "",
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
