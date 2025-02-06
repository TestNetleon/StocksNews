import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/overview/morningstart_lock.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/pdfViewer/pdf_viewer_widget.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/economic.dart';

import 'package:stocks_news_new/screens/stockDetail/widgets/fair_value.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/valuable.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../auth/base/base_auth.dart';
import '../../morningstarTranscations/morningstar_txn.dart';

class StockDetailAnalystData extends StatefulWidget {
  final String symbol;
  const StockDetailAnalystData({super.key, required this.symbol});

  @override
  State<StockDetailAnalystData> createState() => _StockDetailAnalystDataState();
}

class _StockDetailAnalystDataState extends State<StockDetailAnalystData> {
  bool userPresent = false;

  void _onViewNewsClick(context) async {
    StockDetailProviderNew provider =
        Provider.of<StockDetailProviderNew>(context, listen: false);
    await provider.getOverviewData(symbol: widget.symbol, pointsDeducted: true);
  }

  Future _onReferClick(BuildContext context) async {
    UserProvider userProvider = context.read<UserProvider>();
    // if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
    if (userProvider.user?.affiliateStatus != 1) {
      await referLogin();
    } else {
      if (userProvider.user != null) {
        await Share.share(
          "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
        );
      }
    }
  }

  void _onLoginClick(context) async {
    // await loginSheet();
    await loginFirstSheet();

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    StockDetailProviderNew provider =
        Provider.of<StockDetailProviderNew>(context, listen: false);

    if (userProvider.user != null) {
      provider.getOverviewData(symbol: widget.symbol);
    }
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    MorningStar? morningStar =
        context.watch<StockDetailProviderNew>().overviewRes?.morningStart;
    // int value = morningStar?.quantEconomicMoatLabel == "Narrow"
    //     ? 70
    //     : morningStar?.quantEconomicMoatLabel == "Wide"
    //         ? 99
    //         : 0;

    String? healthLabel = morningStar?.quantFinancialHealthLabel;
    String? unCerLabel = morningStar?.quantFairValueUncertaintyLabel;
    double radialValue = unCerLabel == "Low"
        ? 10
        : unCerLabel == "Medium"
            ? 30
            : unCerLabel == "High"
                ? 50
                : unCerLabel == "Very High"
                    ? 70
                    : unCerLabel == "Extreme"
                        ? 90
                        : 0;

    double minValue = 0;
    double maxValue = 100;

    return LayoutBuilder(
      builder: (context, constraints) {
        return provider.isLoadingOverview
            ? const Loading()
            : provider.overviewRes != null && !provider.isLoadingOverview
                ? ((provider.overviewRes!.morningStart!.lockInformation
                                ?.readingStatus ==
                            false) &&
                        !provider.isLoadingOverview)
                    ? SdMorningStarLock(symbol: widget.symbol)
                    : CommonRefreshIndicator(
                        onRefresh: () async {
                          provider.getOverviewData(
                            symbol: widget.symbol,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            color: ThemeColors.greyBorder.withOpacity(0.2),
                            border:
                                Border.all(color: ThemeColors.sos, width: 3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 60.0, right: 60.0),
                                    child: Image.asset(
                                      Images.morningStarLogo,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.4,
                                    ),
                                  ),
                                  const SpacerVertical(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(
                                          "Quantitative Equity Research Report",
                                          style: styleGeorgiaBold(fontSize: 18),
                                          maxLines: 1,
                                        ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     // log("&&&&&&&&&&&&&&");
                                      //     morningStarInfoSheet(
                                      //         data: morningStar?.description);
                                      //   },
                                      //   // constraints: BoxConstraints.loose(Size.zero),
                                      //   child: const Padding(
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 8.0),
                                      //     child: Icon(
                                      //       Icons.info_outline,
                                      //       size: 18,
                                      //       color: ThemeColors.greyText,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SpacerVertical(height: 5),
                                  Text(
                                    "Powered by MORNINGSTAR",
                                    textAlign: TextAlign.center,
                                    style: stylePTSansRegular(
                                      fontSize: 12,
                                      color: ThemeColors.greyText,
                                    ),
                                  ),
                                  const SpacerVertical(height: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RatingBar.builder(
                                        initialRating: double.tryParse(
                                                "${morningStar?.quantStarRating}") ??
                                            0.0,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        itemSize: 40,
                                        unratedColor: ThemeColors.greyBorder,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: ThemeColors.ratingIconColor,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ],
                                  ),
                                  const SpacerVertical(height: 15),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 390,
                                        decoration: BoxDecoration(
                                          // color: Colors.amber,
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.2, 0.65],
                                            colors: [
                                              Color.fromARGB(255, 32, 128, 65),
                                              Color.fromARGB(255, 39, 37, 37),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 14, 41, 0),
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        top:
                                            0, // Adjust the top position as needed
                                        left: 0,
                                        right: 0,
                                        child: EconomicMoat(),
                                      ),
                                      const Positioned(
                                        top:
                                            130, // Adjust the top position based on EconomicMoat's height
                                        left: 0,
                                        right: 0,
                                        child: Valuable(),
                                      ),
                                      const Positioned(
                                        top:
                                            250, // Adjust the top position based on Valuable's height
                                        left: 0,
                                        right: 0,
                                        child: FairValue(),
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   "Economic Moat",
                                  //   style: styleGeorgiaBold(),
                                  // ),
                                  // const SpacerVertical(height: 5),
                                  // Text(
                                  //   "As on - ${morningStar?.updated ?? "N/A"}",
                                  //   style: stylePTSansRegular(
                                  //     fontSize: 12,
                                  //     color: ThemeColors.greyText,
                                  //   ),
                                  // ),
                                  // const SpacerVertical(height: 10),
                                  // LayoutBuilder(
                                  //   builder: (context, constraints) {
                                  //     return Stack(
                                  //       // alignment: Alignment.center,
                                  //       children: [
                                  //         Container(
                                  //           height: 40,
                                  //           decoration: const BoxDecoration(
                                  //             color: ThemeColors.gradientLight,
                                  //             borderRadius: BorderRadius.all(
                                  //               Radius.circular(30),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           width: constraints.maxWidth *
                                  //               (value / 100),
                                  //           height: 40,
                                  //           decoration: const BoxDecoration(
                                  //             color: ThemeColors.accent,
                                  //             borderRadius: BorderRadius.all(
                                  //               Radius.circular(30),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Positioned(
                                  //           right: 0,
                                  //           left: 0,
                                  //           bottom: 0,
                                  //           top: 10,
                                  //           child: Text(
                                  //             "${morningStar?.quantEconomicMoatLabel}"
                                  //                 .toUpperCase(),
                                  //             style: stylePTSansBold(),
                                  //             textAlign: TextAlign.center,
                                  //           ),
                                  //         )
                                  //       ],
                                  //     );
                                  //   },
                                  // ),
                                  // const SpacerVertical(height: 15),
                                  // Text(
                                  //   " Fair Value Estimate",
                                  //   style: styleGeorgiaBold(),
                                  // ),
                                  // const SpacerVertical(height: 5),
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 10,
                                  //     vertical: 10,
                                  //   ),
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(5),
                                  //     color: ThemeColors.themeGreen,
                                  //   ),
                                  //   child: Column(
                                  //     children: [
                                  //       ItemRow(
                                  //         label: "Fair Value",
                                  //         value:
                                  //             "${morningStar?.quantFairValue}",
                                  //       ),
                                  //       const SpacerVertical(height: 5),
                                  //       Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.end,
                                  //         children: [
                                  //           Flexible(
                                  //             child: Text(
                                  //               "As on - ${morningStar?.quantFairValueDate ?? "N/A"}",
                                  //               style: stylePTSansRegular(
                                  //                   fontSize: 12),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  const SpacerVertical(height: 15),
                                  // Text("Valuation", style: styleGeorgiaBold()),
                                  // const SpacerVertical(height: 5),
                                  // Container(
                                  //   width: constraints.maxWidth * (value / 100),
                                  //   height: 40,
                                  //   decoration: BoxDecoration(
                                  //     // color: ThemeColors.accent,
                                  //     borderRadius: const BorderRadius.all(
                                  //       Radius.circular(30),
                                  //     ),
                                  //     gradient: LinearGradient(
                                  //       begin: Alignment.centerLeft,
                                  //       end: Alignment.centerRight,
                                  //       colors: morningStar?.quantValuation ==
                                  //               "Undervalued"
                                  //           ? [
                                  //               const Color.fromARGB(
                                  //                   255, 242, 150, 37),
                                  //               const Color.fromARGB(
                                  //                   255, 144, 87, 17),
                                  //             ]
                                  //           : morningStar?.quantValuation ==
                                  //                   "Fairly Valued"
                                  //               ? [
                                  //                   const Color.fromARGB(
                                  //                       255, 14, 173, 5),
                                  //                   const Color.fromARGB(
                                  //                       255, 11, 95, 13),
                                  //                 ]
                                  //               // Overvalued
                                  //               : [
                                  //                   Colors.red,
                                  //                   const Color.fromARGB(
                                  //                       255, 140, 47, 40),
                                  //                 ],
                                  //     ),
                                  //   ),
                                  //   child: Center(
                                  //     child: Text(
                                  //       "${morningStar?.quantValuation}"
                                  //           .toUpperCase(),
                                  //       style: stylePTSansBold(),
                                  //       textAlign: TextAlign.center,
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SpacerVertical(height: 12),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SizedBox(
                                        height: 200,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: -150,
                                              child: SizedBox(
                                                width: constraints.maxWidth,
                                                child: SfRadialGauge(
                                                  animationDuration: 3000,
                                                  axes: <RadialAxis>[
                                                    RadialAxis(
                                                      showLabels: false,
                                                      showAxisLine: false,
                                                      showTicks: false,
                                                      minimum: minValue,
                                                      maximum: maxValue,
                                                      startAngle: 180,
                                                      endAngle: 0,
                                                      ranges: <GaugeRange>[
                                                        GaugeRange(
                                                          startValue: 0,
                                                          endValue: 20,
                                                          color: const Color(
                                                              0xFFFE2A25),
                                                          label: 'Low',
                                                          sizeUnit:
                                                              GaugeSizeUnit
                                                                  .factor,
                                                          labelStyle:
                                                              const GaugeTextStyle(
                                                            fontFamily:
                                                                Fonts.ptSans,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          startWidth: 0.5,
                                                          endWidth: 0.5,
                                                        ),
                                                        GaugeRange(
                                                          startValue: 20,
                                                          endValue: 40,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 255, 192, 4),
                                                          label: 'Medium',
                                                          sizeUnit:
                                                              GaugeSizeUnit
                                                                  .factor,
                                                          labelStyle:
                                                              const GaugeTextStyle(
                                                            fontFamily:
                                                                Fonts.ptSans,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          startWidth: 0.5,
                                                          endWidth: 0.5,
                                                        ),
                                                        GaugeRange(
                                                          startValue: 40,
                                                          endValue: 60,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              255, 243, 25),
                                                          label: 'High',
                                                          sizeUnit:
                                                              GaugeSizeUnit
                                                                  .factor,
                                                          labelStyle:
                                                              const GaugeTextStyle(
                                                            fontFamily:
                                                                Fonts.ptSans,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          startWidth: 0.5,
                                                          endWidth: 0.5,
                                                        ),
                                                        GaugeRange(
                                                          startValue: 60,
                                                          endValue: 80,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              157, 237, 146),
                                                          label: 'Very High',
                                                          sizeUnit:
                                                              GaugeSizeUnit
                                                                  .factor,
                                                          labelStyle:
                                                              const GaugeTextStyle(
                                                            fontFamily:
                                                                Fonts.ptSans,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          startWidth: 0.5,
                                                          endWidth: 0.5,
                                                        ),
                                                        GaugeRange(
                                                          startValue: 80,
                                                          endValue: maxValue,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 23, 196, 0),
                                                          label: 'Extreme',
                                                          sizeUnit:
                                                              GaugeSizeUnit
                                                                  .factor,
                                                          labelStyle:
                                                              const GaugeTextStyle(
                                                            fontFamily:
                                                                Fonts.ptSans,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          startWidth: 0.5,
                                                          endWidth: 0.5,
                                                        ),
                                                      ],
                                                      pointers: [
                                                        NeedlePointer(
                                                          value: radialValue,
                                                          needleColor:
                                                              ThemeColors
                                                                  .accent,
                                                          knobStyle:
                                                              const KnobStyle(
                                                            color: ThemeColors
                                                                .accent,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Quantitative Uncertainty",
                                        style: styleGeorgiaBold(),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SpacerVertical(height: 5),
                                      Text(
                                        "As on - ${morningStar?.quantFairValueUncertaintyDate}",
                                        style: stylePTSansRegular(
                                          fontSize: 12,
                                          color: ThemeColors.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SpacerVertical(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ClipPath(
                                          // clipper: CustomClipPathTopContainerOne(),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              //color:
                                              // Color.fromARGB(255, 85, 1, 8),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: [0.40, 0.9],
                                                colors: [
                                                  Color.fromARGB(
                                                      226, 238, 55, 42),
                                                  Color.fromARGB(
                                                      255, 93, 19, 0),
                                                ],
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "One star price",
                                                  style: stylePTSansRegular(),
                                                ),
                                                const SpacerVertical(height: 5),
                                                Text(
                                                  "${morningStar?.oneStarPrice}",
                                                  style: stylePTSansBold(
                                                      fontSize: 24),
                                                ),
                                                const SpacerVertical(height: 5),
                                                Text(
                                                  "${morningStar?.oneStarPriceDate}",
                                                  style: stylePTSansRegular(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ClipPath(
                                          // clipper: CustomClipPathTopContainerOne(),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              // color: Color.fromARGB(255, 2, 75, 2),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: [0.40, 0.9],
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 45, 161, 30),
                                                  Color.fromARGB(
                                                      255, 0, 93, 12),
                                                ],
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Five star price",
                                                  style: stylePTSansRegular(),
                                                ),
                                                const SpacerVertical(height: 5),
                                                Text(
                                                  "${morningStar?.fiveStarPrice}",
                                                  style: stylePTSansBold(
                                                      fontSize: 24),
                                                ),
                                                const SpacerVertical(height: 5),
                                                Text(
                                                  "${morningStar?.fiveStarPriceDate}",
                                                  style: stylePTSansRegular(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SpacerVertical(height: 15),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: ThemeColors.tabBack
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(255, 63, 63, 63),
                                          Color.fromARGB(255, 23, 23, 23),
                                          Color.fromARGB(255, 63, 63, 63),
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            margin: const EdgeInsets.only(
                                              top: 2,
                                              left: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Financial Health",
                                                  style: styleGeorgiaBold(
                                                    fontSize: 18,
                                                  ).copyWith(height: 1),
                                                ),
                                                const SpacerVertical(height: 3),
                                                Text(
                                                  "As on - ${morningStar?.quantFinancialHealthDate}",
                                                  style: stylePTSansRegular(
                                                    fontSize: 12,
                                                    color: ThemeColors.greyText,
                                                  ),
                                                ),
                                                const SpacerVertical(height: 6),
                                                Image.asset(
                                                  Images.financialHealth,
                                                  width: 50,
                                                  height: 50,
                                                  opacity:
                                                      const AlwaysStoppedAnimation(
                                                          .8),
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SpacerHorizontal(width: 40),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                            vertical: 3,
                                          ),
                                          width: 120,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: healthLabel == "Weak"
                                                ? const Color(0xFFF44336)
                                                : healthLabel == "Moderate"
                                                    ? const Color(0xFFFDEF2D)
                                                    : const Color(0xFF2BFF75),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${morningStar?.quantFinancialHealthLabel}",
                                              style: styleGeorgiaBold(
                                                fontSize: 16,
                                                color: healthLabel == "Weak"
                                                    ? Colors.white
                                                    : healthLabel == "Moderate"
                                                        ? Colors.black
                                                        : Colors.black,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SpacerVertical(height: 15),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PdfViewerWidget(
                                            url: morningStar?.pdfUrl,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: ThemeColors.themeGreen,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.40, 0.9],
                                          colors: [
                                            Color.fromARGB(255, 45, 161, 30),
                                            Color.fromARGB(255, 1, 107, 15),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // const Icon(Icons.picture_as_pdf_outlined, size: 30),
                                          const SpacerHorizontal(width: 6),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "View Research Report",
                                                  style: stylePTSansBold(),
                                                ),
                                                const SpacerVertical(height: 5),
                                                Text(
                                                  "Powered by MORNINGSTAR",
                                                  style: stylePTSansRegular(
                                                      fontSize: 12),
                                                ),
                                                const SpacerVertical(height: 5),
                                                Text(
                                                  "As on - ${morningStar?.updated}",
                                                  style: stylePTSansRegular(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SpacerHorizontal(width: 70),

                                          Image.asset(
                                            Images.viewReport,
                                            color: Colors.white,
                                            width: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SpacerVertical(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        navigatorKey.currentContext!,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const MorningStarTransaction()),
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        "${morningStar?.viewAllText}",
                                        style: stylePTSansBold(
                                            color: ThemeColors.accent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                : !provider.isLoadingOverview && provider.overviewRes == null
                    ? Center(
                        child: ErrorDisplayWidget(
                          error: provider.error,
                          onRefresh: () => provider.getOverviewData(
                            symbol: widget.symbol,
                          ),
                        ),
                      )
                    : provider.isLoadingOverview
                        ? const Loading()
                        : const SizedBox();
      },
    );
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String? value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: styleGeorgiaBold(fontSize: 18),
        ),
        const SpacerVertical(height: 10),
        Text(
          value ?? "",
          style: styleGeorgiaBold(color: valueColor, fontSize: 25),
        )
      ],
    );
  }
}
