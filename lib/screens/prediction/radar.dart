import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/prediction/Widget/forecast_chart.dart';
import 'package:stocks_news_new/screens/prediction/Widget/fundamental.dart';
import 'package:stocks_news_new/screens/prediction/Widget/header.dart';
import 'package:stocks_news_new/screens/prediction/Widget/stocks_list.dart';
import 'package:stocks_news_new/screens/prediction/Widget/technical.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

// ignore: camel_case_types
class radar extends StatefulWidget {
  const radar({super.key});

  @override
  State<radar> createState() => _radarState();
}

class _radarState extends State<radar> {
  List<String> Qualitative = [
    "Qualitative0",
    "Economic Indicators",
    "Industry Trends"
  ];

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: true,
        canSearch: true,
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
                  height: 300,
                  //Radar Chart
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                      chartRadiusFactor: 0.7,
                    ),
                  ),
                ),
                const StocksList(),
                const SizedBox(
                  height: 20.0,
                ),
                const FundamentalAnalaysis(),
                const SizedBox(
                  height: 10.0,
                ),

                const SizedBox(
                  height: 8.0,
                ),
                const TechnicalAnalaysis(),
                ForcastingChart(),
                // SizedBox(
                //     height: MediaQuery.of(context).size.height * 0.20,
                //     child: ListView.builder(
                //         itemCount: Technical.length,
                //         shrinkWrap: true,
                //         scrollDirection: Axis.horizontal,
                //         physics: const AlwaysScrollableScrollPhysics(),
                //         itemBuilder: (context, index) {
                //           return Stack(
                //             children: [
                //               Container(
                //                 width: MediaQuery.of(context).size.width * 0.50,
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   border: Border.all(color: Colors.white),
                //                 ),
                //                 margin: const EdgeInsets.all(8.0),
                //               ),
                //               Positioned(
                //                 left: 75,
                //                 child: Container(
                //                     height: 40,
                //                     width: 50,
                //                     decoration: BoxDecoration(
                //                         color: Colors.white,
                //                         border: Border.all(color: Colors.grey),
                //                         shape: BoxShape.circle),
                //                     child: const Icon(Icons.person)),
                //               ),
                //               const SizedBox(
                //                 height: 10.0,
                //               ),
                //               Positioned(
                //                 top: 50,
                //                 left: 25,
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Text(
                //                       Technical[index],
                //                       style: GoogleFonts.lato(
                //                         textStyle: Theme.of(context)
                //                             .textTheme
                //                             .labelSmall,
                //                         fontSize: 14,
                //                         fontWeight: FontWeight.w700,
                //                         fontStyle: FontStyle.normal,
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       height: 5.0,
                //                     ),
                //                     Text(
                //                       '\$93,48584',
                //                       style: GoogleFonts.lato(
                //                         textStyle: Theme.of(context)
                //                             .textTheme
                //                             .labelSmall,
                //                         fontSize: 12,
                //                         fontWeight: FontWeight.w700,
                //                         fontStyle: FontStyle.normal,
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       height: 5.0,
                //                     ),
                //                     Text(
                //                       '\$93,48584',
                //                       style: GoogleFonts.lato(
                //                         textStyle: Theme.of(context)
                //                             .textTheme
                //                             .labelSmall,
                //                         fontSize: 12,
                //                         fontWeight: FontWeight.w700,
                //                         fontStyle: FontStyle.normal,
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               )
                //             ],
                //           );
                //         })),
                // const SizedBox(
                //   height: 10.0,
                // ),
                // Text(
                //   'Qualitative Factors',
                //   style: GoogleFonts.lato(
                //     textStyle: Theme.of(context).textTheme.bodyMedium,
                //     fontSize: 20,
                //     color: Colors.white,
                //     fontWeight: FontWeight.w700,
                //     fontStyle: FontStyle.normal,
                //   ),
                // ),
                // const SizedBox(
                //   height: 8.0,
                // ),
                // Container(
                //     height: MediaQuery.of(context).size.height * 0.25,
                //     color: Colors.amber,
                //     child: ListView.builder(
                //         itemCount: Qualitative.length,
                //         shrinkWrap: true,
                //         scrollDirection: Axis.vertical,
                //         physics: const AlwaysScrollableScrollPhysics(),
                //         itemBuilder: (context, index) {
                //           return Column(
                //             children: [
                //               Text(
                //                 Qualitative[index],
                //                 style: GoogleFonts.lato(
                //                   textStyle:
                //                       Theme.of(context).textTheme.labelSmall,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w700,
                //                   fontStyle: FontStyle.normal,
                //                 ),
                //               ),
                //               const SizedBox(
                //                 height: 5.0,
                //               ),
                //               Text(
                //                 '\$93,48584',
                //                 style: GoogleFonts.lato(
                //                   textStyle:
                //                       Theme.of(context).textTheme.labelSmall,
                //                   fontSize: 12,
                //                   fontWeight: FontWeight.w700,
                //                   fontStyle: FontStyle.normal,
                //                 ),
                //               ),
                //               const SizedBox(
                //                 height: 5.0,
                //               ),
                //               Text(
                //                 '\$93,48584',
                //                 style: GoogleFonts.lato(
                //                   textStyle:
                //                       Theme.of(context).textTheme.labelSmall,
                //                   fontSize: 12,
                //                   fontWeight: FontWeight.w700,
                //                   fontStyle: FontStyle.normal,
                //                 ),
                //               )
                //             ],
                //           );
                //         })),
              ]),
        ),
      ),
    );
  }
}
