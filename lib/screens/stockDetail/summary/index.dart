import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trade_provider.dart';
import 'package:stocks_news_new/screens/stockDetail/summary/item.dart';
import 'package:stocks_news_new/screens/stockDetail/summary/searchTicker/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class SdSummaryOrders extends StatelessWidget {
  const SdSummaryOrders({super.key});

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimen.padding, Dimen.padding, Dimen.padding, 0),
        child: Column(
          children: [
            const ScreenTitle(
              title: "Virtual Trading Account",
              dividerPadding: EdgeInsets.only(bottom: 10),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     boxShadow: const [
            //       BoxShadow(
            //         blurStyle: BlurStyle.solid,
            //         spreadRadius: 2,
            //         color: Color.fromARGB(255, 27, 27, 27),
            //         blurRadius: 0.1,
            //         offset: Offset(0, 2.5),
            //       ),
            //     ],
            //     color: ThemeColors.background,
            //     borderRadius: BorderRadius.circular(5),
            //     // border: Border.all(
            //     //   color: ThemeColors.greyBorder.withOpacity(0.4),
            //     // ),
            //   ),
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //   child: Column(
            //     children: [
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Flexible(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "\$${provider.data.availableBalance.toCurrency()}",
            //                   style: styleGeorgiaBold(fontSize: 25),
            //                 ),
            //                 const SpacerVertical(height: 5),
            //                 Text(
            //                   "Total Portfolio",
            //                   style: stylePTSansRegular(
            //                       fontSize: 15, color: ThemeColors.greyText),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           const SpacerHorizontal(width: 10),
            //           Flexible(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.end,
            //               children: [
            //                 Text(
            //                   "\$${provider.data.invested.toCurrency()}",
            //                   style: styleGeorgiaBold(fontSize: 25),
            //                 ),
            //                 const SpacerVertical(height: 5),
            //                 Text(
            //                   "Positions P&L",
            //                   style: stylePTSansRegular(
            //                       fontSize: 15, color: ThemeColors.greyText),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SpacerVertical(height: 30),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Column(
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.all(8),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: ThemeColors.greyBorder.withOpacity(0.6),
            //                 ),
            //                 child: const Icon(
            //                   Icons.arrow_circle_down,
            //                 ),
            //               ),
            //               const SpacerVertical(height: 5),
            //               Text(
            //                 "Deposit",
            //                 style: stylePTSansRegular(fontSize: 12),
            //               ),
            //             ],
            //           ),
            //           const SpacerHorizontal(width: 30),
            //           Column(
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.all(8),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: ThemeColors.greyBorder.withOpacity(0.6),
            //                 ),
            //                 child: const Icon(Icons.arrow_circle_up),
            //               ),
            //               const SpacerVertical(height: 5),
            //               Text(
            //                 "Withdraw",
            //                 style: stylePTSansRegular(fontSize: 12),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Card(
              color: ThemeColors.background,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              shadowColor: ThemeColors.greyBorder,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\$${provider.data.availableBalance.toCurrency()}",
                                style: styleGeorgiaBold(fontSize: 25),
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                "Total Portfolio",
                                style: stylePTSansRegular(
                                    fontSize: 15, color: ThemeColors.greyText),
                              ),
                            ],
                          ),
                        ),
                        const SpacerHorizontal(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${provider.data.invested.toCurrency()}",
                                style: styleGeorgiaBold(fontSize: 25),
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                "Positions P&L",
                                style: stylePTSansRegular(
                                    fontSize: 15, color: ThemeColors.greyText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SpacerVertical(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ThemeButtonSmall(
                            textSize: 17,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            onPressed: () {},
                            text: "Deposit",
                            icon: Icons.arrow_circle_down_outlined,
                          ),
                        ),
                        const SpacerHorizontal(width: 10),
                        Expanded(
                          child: ThemeButtonSmall(
                            textSize: 17,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            onPressed: () {
                              tradeSheet();
                              // Navigator.push(
                              //     context, createRoute(const SdSearchTicker()));
                            },
                            text: "Trade",
                            color: const Color.fromARGB(255, 194, 216, 51),
                            icon: Icons.arrow_outward_outlined,
                            textColor: ThemeColors.background,
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     Container(
                        //       padding: const EdgeInsets.all(8),
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: ThemeColors.greyBorder.withOpacity(0.6),
                        //       ),
                        //       child: const Icon(Icons.arrow_circle_up),
                        //     ),
                        //     const SpacerVertical(height: 5),
                        //     Text(
                        //       "Withdraw",
                        //       style: stylePTSansRegular(fontSize: 12),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SpacerVertical(height: 20),
            Expanded(
              child: CommonTabContainer(
                scrollable: false,
                tabPaddingNew: false,
                tabs: const [
                  "Open",
                  "Pending",
                  "Closed",
                ],
                widgets: [
                  provider.orders.isEmpty
                      ? const SummaryErrorWidget(
                          title: "No open orders",
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            SummaryOrderNew? order = provider.orders[index];
                            return SdSummaryItem(order: order);
                          },
                          separatorBuilder: (context, index) {
                            return const SpacerVertical();
                          },
                          itemCount: provider.orders.length,
                        ),
                  const SummaryErrorWidget(
                    title: "No pending orders",
                  ),
                  const SummaryErrorWidget(
                    title: "No closed orders",
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

class SummaryErrorWidget extends StatelessWidget {
  final String title;
  final String? error;

  const SummaryErrorWidget({
    super.key,
    this.title = "Title",
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              title,
              style: stylePTSansBold(fontSize: 20),
            ),
            const SpacerVertical(height: 15),
            Text(
              error ??
                  "Use the opportunity to trade on the world's major financial markets",
              style: stylePTSansRegular(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
