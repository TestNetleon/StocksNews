import 'package:flutter/material.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/overview/stock_score.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../utils/colors.dart';
import '../../../../widgets/disclaimer_widget.dart';

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
              paddingVerticle: 0,
              paddingHorizontal: 0,
              itemSpace: 10,
              length: 25,
              getChild: (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (index == 0)
                  //   // StateItemNEW(label: "Symbol", value: keyStats?.symbol),
                  //   stockDOverviewItem(
                  //       title: "Symbol", value: keyStats?.symbol),
                  // if (index == 1)
                  //   StateItemNEW(label: "Company Name", value: keyStats?.name),

                  if (index == 0)
                    // StateItemNEW(label: "Price", value: keyStats?.price),
                    SizedBox(
                        width: double.infinity,
                        child: stockDOverviewItem(
                            title: "Price", value: keyStats?.price)),

                  if (index == 1)
                    // Visibility(
                    //   visible: keyStats?.change != null,
                    //   child: StateItemNEW(
                    //       label: "Change",
                    //       value: keyStats?.changeWithCur ?? ""),
                    // ),
                    Visibility(
                      visible: keyStats?.change != null,
                      child: SizedBox(
                        width: double.infinity,
                        child: stockDOverviewItem(
                            title: "Change",
                            value: keyStats?.changeWithCur ?? ""),
                      ),
                    ),
                  if (index == 2)
                    // Visibility(
                    //   visible: keyStats?.changesPercentage != null,
                    //   child: StateItemNEW(
                    //     label: "Change Per.",
                    //     value: "${keyStats?.changesPercentage?.toCurrency()}%",
                    //   ),
                    // ),

                    Visibility(
                      visible: keyStats?.changesPercentage != null,
                      child: SizedBox(
                        width: double.infinity,
                        child: stockDOverviewItem(
                          title: "Change Per.",
                          value:
                              "${keyStats?.changesPercentage?.toCurrency()}%",
                        ),
                      ),
                    ),

                  if (index == 3)
                    // StateItemNEW(label: "Day Low", value: keyStats?.dayLow),
                    Container(
                        width: double.infinity,
                        child: stockDOverviewItem(
                            title: "Day Low", value: keyStats?.dayLow)),

                  if (index == 4)
                    // StateItemNEW(label: "Day High", value: keyStats?.dayHigh),
                    SizedBox(
                        width: double.infinity,
                        child: stockDOverviewItem(
                            title: "Day High", value: keyStats?.dayHigh)),

                  if (index == 5)
                    // StateItemNEW(label: "Year Low", value: keyStats?.yearLow),
                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Year Low", value: keyStats?.yearLow),
                    ),

                  if (index == 6)
                    // StateItemNEW(label: "Year High", value: keyStats?.yearHigh),
                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Year High", value: keyStats?.yearHigh),
                    ),

                  if (index == 7)
                    // StateItemNEW(label: "Volume", value: keyStats?.volume),
                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Volume", value: keyStats?.volume),
                    ),

                  if (index == 8)
                    // StateItemNEW(
                    //     label: "Avg. Volume (3m)", value: keyStats?.avgVolume),

                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Avg. Volume (3m)",
                          value: keyStats?.avgVolume),
                    ),

                  if (index == 9)
                    // StateItemNEW(
                    //     label: "Previous Close",
                    //     value: keyStats?.previousClose),
                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Previous Close",
                          value: keyStats?.previousClose),
                    ),

                  if (index == 10)
                    // StateItemNEW(label: "Open", value: keyStats?.open),
                    SizedBox(
                        width: double.infinity,
                        child: stockDOverviewItem(
                            title: "Open", value: keyStats?.open)),

                  if (index == 11)
                    // StateItemNEW(label: "EPS", value: "${keyStats?.eps ?? ""}"),
                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "EPS", value: "${keyStats?.eps ?? ""}"),
                    ),

                  if (index == 12)
                    // StateItemNEW(
                    //     label: "P/E ratio", value: "${keyStats?.pe ?? ""}"),

                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "P/E ratio", value: "${keyStats?.pe ?? ""}"),
                    ),

                  if (index == 13)
                    // StateItemNEW(
                    //     label: "Avg 50 EMA (D)", value: keyStats?.priceAvg50),
                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Avg 50 EMA (D)", value: keyStats?.priceAvg50),
                    ),
                  if (index == 14)
                    // StateItemNEW(
                    //     label: "Avg 200 EMA (D)", value: keyStats?.priceAvg200),
                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Avg 200 EMA (D)",
                          value: keyStats?.priceAvg200),
                    ),
                  // if (index == 10)
                  //   StateItemNEW(label: "Exchange", value: keyStats?.exchange),
                  if (index == 15)
                    // Visibility(
                    //     visible: keyStats?.revenue != null,
                    //     child: StateItemNEW(
                    //         label: "Revenue", value: keyStats?.revenue)),
                    Visibility(
                        visible: keyStats?.revenue != null,
                        child: SizedBox(
                          width: double.infinity,
                          child: stockDOverviewItem(
                              title: "Revenue", value: keyStats?.revenue),
                        )),
                  if (index == 16)
                    // Visibility(
                    //   visible: keyStats?.bookValuePerShare != null,
                    //   child: StateItemNEW(
                    //       label: "Book value/Share",
                    //       value: keyStats?.bookValuePerShare),
                    // ),

                    Visibility(
                      visible: keyStats?.bookValuePerShare != null,
                      child: SizedBox(
                        width: double.infinity,
                        child: stockDOverviewItem(
                            title: "Book value/Share",
                            value: keyStats?.bookValuePerShare),
                      ),
                    ),

                  if (index == 17)
                    // StateItemNEW(
                    //     label: "Dividend (yield)",
                    //     value: keyStats?.dividendYield),

                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Dividend (yield)",
                          value: keyStats?.dividendYield),
                    ),

                  if (index == 18)
                    // StateItemNEW(
                    //     label: "EV/Ebitda",
                    //     value: keyStats?.enterpriseValueOverEbitda),

                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "EV/Ebitda",
                          value: keyStats?.enterpriseValueOverEbitda),
                    ),
                  // if (index == 19)
                  //   // Visibility(
                  //   //   visible: (keyStats?.bid != null && keyStats?.bid != '') ||
                  //   //       keyStats?.ask != null && keyStats?.ask != '',
                  //   //   child: StateItemNEW(
                  //   //       label: "Bid/Ask",
                  //   //       value:
                  //   //           "${keyStats?.bid ?? "N/A"}/${keyStats?.ask ?? "N/A"}"),
                  //   // ),

                  //   Visibility(
                  //     visible: (keyStats?.bid != null && keyStats?.bid != '') ||
                  //         keyStats?.ask != null && keyStats?.ask != '',
                  //     child: SizedBox(
                  //       width: double.infinity,
                  //       child: stockDOverviewItem(
                  //           title: "Bid/Ask",
                  //           value:
                  //               "${keyStats?.bid ?? "N/A"}/${keyStats?.ask ?? "N/A"}"),
                  //     ),
                  //   ),

                  if (index == 19)
                    // StateItemNEW(
                    //     label: "Market Cap.", value: keyStats?.marketCap),

                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Market Cap.", value: keyStats?.marketCap),
                    ),
                  if (index == 20)
                    // StateItemNEW(
                    //     label: "Shares Outstanding",
                    //     value: keyStats?.sharesOutstanding),

                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Shares Outstanding",
                          value: keyStats?.sharesOutstanding),
                    ),

                  if (index == 21)
                    // StateItemNEW(
                    //     label: "Earnings Announcement",
                    //     value: keyStats?.earningsAnnouncement),

                    SizedBox(
                      width: double.infinity,
                      child: stockDOverviewItem(
                          title: "Earnings Announcement",
                          value: keyStats?.earningsAnnouncement),
                    ),
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
