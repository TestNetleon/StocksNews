import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/open/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/ts_dashboard_header.dart';
import 'package:stocks_news_new/tradingSimulator/widgets/ts_error_widget.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

class TsDashboard extends StatelessWidget {
  const TsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = context.watch<UserProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: false,
        showTrailing: false,
        showPortfolio: true,
        title: "Virtual Trading Account",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
        child: const Column(
          children: [
            TsDashboardHeader(),
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   margin: EdgeInsets.only(bottom: 20),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     gradient: const LinearGradient(
            //       begin: Alignment.bottomLeft,
            //       end: Alignment.topRight,
            //       colors: [
            //         ThemeColors.accent,
            //         Color.fromARGB(255, 222, 215, 7),
            //       ],
            //     ),
            //   ),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: ThemeColors.background,
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 15,
            //         vertical: 15,
            //       ),
            //       child: Column(
            //         children: [
            //           Row(
            //             crossAxisAlignment: CrossAxisAlignment.end,
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Flexible(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       // "\$${formatBalance(num.parse(provider.data.availableBalance.toCurrency()))}",
            //                       "\$${formatBalance(userProvider.user?.trade?.amount ?? 0)}",
            //                       style: styleGeorgiaBold(fontSize: 25),
            //                     ),
            //                     const SpacerVertical(height: 5),
            //                     Text(
            //                       "Total Portfolio",
            //                       style: stylePTSansRegular(
            //                         fontSize: 15,
            //                         color: ThemeColors.greyText,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               const SpacerHorizontal(width: 10),
            //               Flexible(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.end,
            //                   children: [
            //                     Text(
            //                       // "\$${provider.data.invested.toCurrency()}",
            //                       "\$${formatBalance(userProvider.user?.trade?.paid ?? 0)}",
            //                       style: styleGeorgiaBold(fontSize: 25),
            //                     ),
            //                     const SpacerVertical(height: 5),
            //                     Text(
            //                       "Positions P&L",
            //                       style: stylePTSansRegular(
            //                           fontSize: 15,
            //                           color: ThemeColors.greyText),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //           const SpacerVertical(height: 30),
            //           ThemeButtonSmall(
            //             textSize: 17,
            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 15,
            //               vertical: 5,
            //             ),
            //             onPressed: tradeSheet,
            //             text: "Place New Virtual Trade",
            //             color: const Color.fromARGB(255, 194, 216, 51),
            //             icon: Icons.arrow_outward_outlined,
            //             textColor: ThemeColors.background,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: CommonTabContainer(
                scrollable: false,
                tabPaddingNew: false,
                tabs: [
                  "Open",
                  "Pending",
                  "Closed",
                ],
                widgets: [
                  TsOpenList(),
                  // provider.orders.isEmpty
                  //     ? const SummaryErrorWidget(
                  //         title: "No open orders",
                  //       )

                  SummaryErrorWidget(title: "No pending orders"),
                  SummaryErrorWidget(title: "No closed orders"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
