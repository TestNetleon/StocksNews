// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class PlaidHomeInvestmentOverview extends StatelessWidget {
//   const PlaidHomeInvestmentOverview({super.key});

//   @override
//   Widget build(BuildContext context) {
//     HomeProvider provider = context.watch<HomeProvider>();
//     return InkWell(
//       borderRadius: const BorderRadius.all(Radius.circular(8)),
//       onTap: () {
//         Navigator.pushNamed(context, HomePlaidAdded.path);
//       },
//       child: Ink(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color.fromARGB(255, 23, 23, 23),
//               Color.fromARGB(255, 48, 48, 48),
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Investment Overview",
//               style: stylePTSansBold(),
//             ),
//             const SpacerVertical(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         "Total Close Price",
//                         style: stylePTSansRegular(color: ThemeColors.greyText),
//                       ),
//                       const SpacerVertical(height: 5),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               provider.homePortfolio?.bottom?.closePrice ?? "",
//                           style: stylePTSansRegular(
//                             fontSize: 18,
//                           ),
//                           // children: [
//                           //   TextSpan(
//                           //     text: "0.18%",
//                           //     style: stylePTSansRegular(
//                           //       fontSize: 13,
//                           //       color: ThemeColors.accent,
//                           //     ),
//                           //   ),
//                           // ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 10),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "Current Balance",
//                         style: stylePTSansRegular(color: ThemeColors.greyText),
//                       ),
//                       const SpacerVertical(height: 5),
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               provider.homePortfolio?.bottom?.currentBalance ??
//                                   "",
//                           style: stylePTSansRegular(
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class PlaidHomeInvestmentOverview extends StatelessWidget {
  const PlaidHomeInvestmentOverview({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: () {
        Navigator.pushNamed(context, HomePlaidAdded.path);
      },
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              Color.fromARGB(255, 48, 48, 48),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(Images.stockIcon)),
                ),
                const SpacerHorizontal(width: 10),
                Text(
                  "Portfolio Valuation",
                  style: stylePTSansBold(fontSize: 20),
                ),
              ],
            ),
            const SpacerHorizontal(width: 10),
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ThemeColors.accent,
                ),
                child: Text(
                  provider.homePortfolio?.bottom?.currentBalance ?? "",
                  style: stylePTSansRegular(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
