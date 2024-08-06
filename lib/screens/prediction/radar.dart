import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/prediction/Widget/header.dart';
import 'package:stocks_news_new/screens/prediction/Widget/stocks_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/spacer_horizontal.dart';

// ignore: camel_case_types
class RadarIndex extends StatefulWidget {
  const RadarIndex({super.key});

  @override
  State<RadarIndex> createState() => _RadarIndexState();
}

class _RadarIndexState extends State<RadarIndex> {
  List<String> Qualitative = [
    "Qualitative0",
    "Economic Indicators",
    "Industry Trends"
  ];

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: AppBarHome(
        isPopback: true,
        showTrailing: false,
        canSearch: false,
        title: "Microsoft Corporation",
        subTitle: "",
        widget: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.white,
                color: Colors.transparent,
                // border: Border.all(color: ThemeColors.white),
                border: Border.all(color: ThemeColors.accent),
              ),
              padding: const EdgeInsets.all(8),
              width: 48,
              height: 48,
              child: Image.asset("assets/images/msft.png"),
            ),
            SpacerHorizontal(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Microsoft Corporation",
                        style: stylePTSansBold(fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeColors.greyBorder,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          "NSDQ",
                          style: stylePTSansRegular(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   "Microsoft",
                  //   style: stylePTSansRegular(
                  //     fontSize: 14,
                  //     color: ThemeColors.greyText,
                  //   ),
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  Visibility(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.watch_later,
                          size: 15,
                          color: ThemeColors.greyText,
                        ),
                        const SpacerHorizontal(width: 5),
                        Text(
                          "Open 08/06/2024",
                          style: stylePTSansRegular(
                            color: ThemeColors.greyText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const PreditionHeader(),
                SizedBox(
                  width: 450,
                  height: 320,
                  //Radar Chart
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 20.0),
                    child: RadarChart(
                      labelColor: Colors.white,
                      fillColor: Colors.greenAccent,
                      curve: Curves.linear,
                      animate: true,
                      textScaleFactor: 0.03,
                      strokeColor: Colors.white,
                      values: const [40, 35, 54, 27, 12],
                      labels: const [
                        "Price-to-Earnings Ratio (P/E Ratio)",
                        "Price-to-Earnings Growth Ratio (PEG Ratio)"
                            "Price-to-Book Ratio (P/B Ratio)",
                        "Dividend Yield",
                        "Return on Equity (ROE)",
                        "Debt-to-Equity Ratio",
                      ],
                      maxValue: 54,
                      chartRadiusFactor: 0.6,
                    ),
                  ),
                ),
                ScreenTitle(
                  title: "Your other stocks",
                  style: styleSansBold(color: ThemeColors.white, fontSize: 18),
                  dividerPadding: EdgeInsets.only(bottom: 5),
                ),
                const StocksList(),

                const SizedBox(
                  height: 20.0,
                ),
                // const FundamentalAnalaysis(),
                // const SizedBox(
                //   height: 10.0,
                // ),
                // const TechnicalAnalaysis(),
                // const ForcastingChart(),
                // const SizedBox(
                //   height: 10.0,
                // ),
                // const Faq(),
                // const SizedBox(
                //   height: 10.0,
                // ),
              ]),
        ),
      ),
    );
  }
}
