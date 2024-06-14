import 'package:flutter/material.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../utils/colors.dart';
import '../../../../widgets/disclaimer_widget.dart';
import 'item.dart';

//
class SdKeyStats extends StatefulWidget {
  const SdKeyStats({super.key});

  @override
  State<SdKeyStats> createState() => _SdKeyStatsState();
}

class _SdKeyStatsState extends State<SdKeyStats> {
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimen.padding, Dimen.padding, Dimen.padding, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SdCommonHeading(),
            const Divider(
              color: ThemeColors.white,
              thickness: 2,
              height: 20,
            ),
            CustomGridView(
              paddingVerticle: 8,
              paddingHorizontal: 0,
              length: 25,
              getChild: (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0)
                    StateItemNEW(label: "Symbol", value: keyStats?.symbol),
                  if (index == 1)
                    StateItemNEW(label: "Name", value: keyStats?.name),

                  if (index == 2)
                    StateItemNEW(label: "Price", value: keyStats?.price),
                  if (index == 3)
                    Visibility(
                      visible: keyStats?.change != null,
                      child: StateItemNEW(
                          label: "Change",
                          value: "\$${keyStats?.change ?? ""}"),
                    ),
                  if (index == 4)
                    Visibility(
                      visible: keyStats?.changesPercentage != null,
                      child: StateItemNEW(
                        label: "Change Per.",
                        value: "${keyStats?.changesPercentage?.toCurrency()}%",
                      ),
                    ),
                  if (index == 5)
                    StateItemNEW(label: "Day Low", value: keyStats?.dayLow),
                  if (index == 6)
                    StateItemNEW(label: "Day High", value: keyStats?.dayHigh),
                  if (index == 7)
                    StateItemNEW(label: "Year Low", value: keyStats?.yearLow),
                  if (index == 8)
                    StateItemNEW(label: "Year High", value: keyStats?.yearHigh),
                  if (index == 9)
                    StateItemNEW(label: "Volume", value: keyStats?.volume),
                  if (index == 10)
                    StateItemNEW(
                        label: "Avg. Volume (3m)", value: keyStats?.avgVolume),

                  if (index == 11)
                    StateItemNEW(
                        label: "Previous Close",
                        value: keyStats?.previousClose),

                  if (index == 12)
                    StateItemNEW(label: "Open", value: keyStats?.open),
                  if (index == 13)
                    StateItemNEW(label: "EPS", value: "${keyStats?.eps ?? ""}"),
                  if (index == 14)
                    StateItemNEW(
                        label: "P/E ratio", value: "${keyStats?.pe ?? ""}"),

                  if (index == 15)
                    StateItemNEW(
                        label: "Avg 50 EMA (D)", value: keyStats?.priceAvg50),
                  if (index == 16)
                    StateItemNEW(
                        label: "Avg 200 EMA (D)", value: keyStats?.priceAvg200),
                  // if (index == 10)
                  //   StateItemNEW(label: "Exchange", value: keyStats?.exchange),
                  if (index == 17)
                    Visibility(
                        visible: keyStats?.revenue != null,
                        child: StateItemNEW(
                            label: "Revenue", value: keyStats?.revenue)),
                  if (index == 18)
                    Visibility(
                      visible: keyStats?.bookValuePerShare != null,
                      child: StateItemNEW(
                          label: "Book value/Share",
                          value: keyStats?.bookValuePerShare),
                    ),
                  if (index == 19)
                    StateItemNEW(
                        label: "Dividend (yield)",
                        value: keyStats?.dividendYield),
                  if (index == 20)
                    StateItemNEW(
                        label: "EV/Ebitda",
                        value: keyStats?.enterpriseValueOverEbitda),
                  if (index == 21)
                    Visibility(
                      visible: (keyStats?.bid != null && keyStats?.bid != '') ||
                          keyStats?.ask != null && keyStats?.ask != '',
                      child: StateItemNEW(
                          label: "Bid/Ask",
                          value:
                              "${keyStats?.bid ?? "N/A"}/${keyStats?.ask ?? "N/A"}"),
                    ),

                  if (index == 22)
                    StateItemNEW(
                        label: "Market Cap.", value: keyStats?.marketCap),
                  if (index == 23)
                    StateItemNEW(
                        label: "Shares Outstanding",
                        value: keyStats?.sharesOutstanding),
                  if (index == 24)
                    StateItemNEW(
                        label: "Earnings Announcement",
                        value: keyStats?.earningsAnnouncement),
                  const SpacerVertical(height: Dimen.itemSpacing),
                ],
              ),
            ),
            if (provider.extra?.disclaimer != null &&
                (!provider.isLoadingTab && keyStats != null))
              DisclaimerWidget(
                data: provider.extra!.disclaimer!,
              ),
          ],
        ),
      ),
    );
  }
}
