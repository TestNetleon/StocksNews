import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/index.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/index.dart';
import 'package:stocks_news_new/stocksScanner/screens/topLosers/index.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ScannerContainer extends StatelessWidget {
  const ScannerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ["SCANNER", "GAINERS", "LOSERS"];
    List<IconData> tabIcons = [
      FontAwesomeIcons.magnifyingGlassChart,
      FontAwesomeIcons.arrowTrendUp,
      FontAwesomeIcons.arrowTrendDown,
    ];
    return CustomTabContainer(
      tabs: List.generate(
        tabs.length,
        (index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  tabIcons[index],
                  size: 14,
                ),
                SpacerHorizontal(width: 5),
                Text(
                  tabs[index],
                  style: styleGeorgiaBold(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
      widgets: [
        MarketScanner(),
        ScannerTopGainer(),
        ScannerTopLosers(),
      ],
    );

    // return const CommonTabContainer(
    //   physics: NeverScrollableScrollPhysics(),
    //   scrollable: true,
    //   tabs: ["MARKET SCANNER", "TOP GAINERS", "TOP LOSERS"],
    //   widgets: [
    //     MarketScanner(),
    //     ScannerTopGainer(),
    //     ScannerTopLosers(),
    //   ],
    // );
  }
}
