import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/overview/bottomsheet_morningstar_info.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StockDetailAnalystData extends StatefulWidget {
  final String symbol;
  const StockDetailAnalystData({
    super.key,
    required this.symbol,
  });

  @override
  State<StockDetailAnalystData> createState() => _StockDetailAnalystDataState();
}

class _StockDetailAnalystDataState extends State<StockDetailAnalystData> {
  bool userPresent = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _getInitialData();
    // });
  }

  // void _getInitialData() async {
  //   DateTime today = DateTime.now();

  //   log("Today ==>   ${today.toString()}");

  //   StockDetailProviderNew stockProvider =
  //       context.read<StockDetailProviderNew>();
  //   UserProvider userProvider = context.read<UserProvider>();
  //   await stockProvider.getOverviewData(
  //     symbol: widget.symbol,
  //   );

  //   if (userProvider.user == null) {
  //     DatabaseHelper helper = DatabaseHelper();
  //     bool visible = await helper.fetchLoginDialogData(SdOverview.path);
  //     if (visible) {
  //       Timer(const Duration(seconds: 3), () {
  //         loginSheet();
  //       });
  //     }
  //   }
  // }

  void _onViewNewsClick(context) async {
    StockDetailProviderNew provider =
        Provider.of<StockDetailProviderNew>(context, listen: false);
    await provider.getOverviewData(
        symbol: widget.symbol,
        pointsDeducted:
            true); // need slug and pointDetected = true (add into api)
  }

  Future _onReferClick(BuildContext context) async {
    UserProvider userProvider = context.read<UserProvider>();
    if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
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
    await loginSheet();

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
    Utils().showLog('is user logged in ${userPresent}');
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    MorningStar? morningStar =
        context.watch<StockDetailProviderNew>().overviewRes?.morningStart;
    //NewsDetailProvider provider = context.watch<NewsDetailProvider>();
    int value = morningStar?.quantEconomicMoatLabel == "Narrow"
        ? 70
        : morningStar?.quantEconomicMoatLabel == "Wide"
            ? 99
            : 0;

    double height = (ScreenUtil().screenHeight -
            ScreenUtil().bottomBarHeight -
            ScreenUtil().statusBarHeight) /
        2.2;

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
            ? Loading()
            : provider.overviewRes != null && !provider.isLoadingOverview
                ? CommonRefreshIndicator(
                    onRefresh: () async {
                      provider.getOverviewData(
                        symbol: widget.symbol,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: ThemeColors.greyBorder.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      "Quantitative Equity Research Report ",
                                      style: styleGeorgiaBold(fontSize: 18),
                                      maxLines: 1,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // log("&&&&&&&&&&&&&&");
                                      morningStarInfoSheet(
                                          data: morningStar?.description);
                                    },
                                    // constraints: BoxConstraints.loose(Size.zero),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 18,
                                        color: ThemeColors.greyText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                "Powered by Morningstar",
                                style: stylePTSansRegular(
                                  fontSize: 12,
                                  color: ThemeColors.greyText,
                                ),
                              ),
                              const SpacerVertical(height: 15),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: ThemeColors.accent.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Text(
                                        //   "Star Rating ",
                                        //   style: stylePTSansBold(
                                        //     color: ThemeColors.accent,
                                        //     fontSize: 18,
                                        //   ),
                                        // ),
                                        RatingBar.builder(
                                          initialRating: double.tryParse(
                                                  "${morningStar?.quantStarRating}") ??
                                              0.0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ignoreGestures: true,
                                          itemSize: 30,
                                          unratedColor: ThemeColors.greyBorder,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: ThemeColors.accent,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    ),
                                    // const SpacerVertical(height: 5),
                                    // Text(
                                    //   "Expected target price: 585.00 - 800.00",
                                    //   style: stylePTSansRegular(color: ThemeColors.greyText),
                                    // ),
                                  ],
                                ),
                              ),
                              const SpacerVertical(height: 15),
                              Text(
                                "Economic Moat",
                                style: styleGeorgiaBold(),
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                "As on - ${morningStar?.updated ?? "N/A"}",
                                style: stylePTSansRegular(
                                  fontSize: 12,
                                  color: ThemeColors.greyText,
                                ),
                              ),
                              const SpacerVertical(height: 10),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    // alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: ThemeColors.gradientLight,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: constraints.maxWidth *
                                            (value / 100),
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: ThemeColors.accent,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        left: 0,
                                        bottom: 0,
                                        top: 10,
                                        child: Text(
                                          "${morningStar?.quantEconomicMoatLabel}"
                                              .toUpperCase(),
                                          style: stylePTSansBold(),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                              const SpacerVertical(height: 15),
                              Text(
                                " Fair Value Estimate",
                                style: styleGeorgiaBold(),
                              ),
                              const SpacerVertical(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ThemeColors.themeGreen,
                                ),
                                child: Column(
                                  children: [
                                    ItemRow(
                                      label: "Fair Value",
                                      value: "${morningStar?.quantFairValue}",
                                    ),
                                    const SpacerVertical(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "As on - ${morningStar?.quantFairValueDate ?? "N/A"}",
                                            style: stylePTSansRegular(
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SpacerVertical(height: 15),
                              Text("Valuation", style: styleGeorgiaBold()),
                              const SpacerVertical(height: 5),
                              Container(
                                width: constraints.maxWidth * (value / 100),
                                height: 40,
                                decoration: BoxDecoration(
                                  // color: ThemeColors.accent,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: morningStar?.quantValuation ==
                                            "Undervalued"
                                        ? [
                                            const Color.fromARGB(
                                                255, 242, 150, 37),
                                            const Color.fromARGB(
                                                255, 144, 87, 17),
                                          ]
                                        : morningStar?.quantValuation ==
                                                "Fairly Valued"
                                            ? [
                                                const Color.fromARGB(
                                                    255, 14, 173, 5),
                                                const Color.fromARGB(
                                                    255, 11, 95, 13),
                                              ]
                                            // Overvalued
                                            : [
                                                Colors.red,
                                                const Color.fromARGB(
                                                    255, 140, 47, 40),
                                              ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${morningStar?.quantValuation}"
                                        .toUpperCase(),
                                    style: stylePTSansBold(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SpacerVertical(height: 12),
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
                                                          GaugeSizeUnit.factor,
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 255, 192, 4),
                                                      label: 'Medium',
                                                      sizeUnit:
                                                          GaugeSizeUnit.factor,
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              243,
                                                              25),
                                                      label: 'High',
                                                      sizeUnit:
                                                          GaugeSizeUnit.factor,
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              157,
                                                              237,
                                                              146),
                                                      label: 'Very High',
                                                      sizeUnit:
                                                          GaugeSizeUnit.factor,
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 23, 196, 0),
                                                      label: 'Extreme',
                                                      sizeUnit:
                                                          GaugeSizeUnit.factor,
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
                                                          ThemeColors.accent,
                                                      knobStyle:
                                                          const KnobStyle(
                                                        color:
                                                            ThemeColors.accent,
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
                                          color: Color.fromARGB(255, 85, 1, 8),
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
                                              style:
                                                  stylePTSansBold(fontSize: 24),
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
                                          color: Color.fromARGB(255, 2, 75, 2),
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
                                              style:
                                                  stylePTSansBold(fontSize: 24),
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
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ThemeColors.tabBack),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      margin: const EdgeInsets.only(
                                          top: 2, left: 2),
                                      child: Image.asset(
                                        Images.health,
                                        width: 40,
                                        height: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SpacerHorizontal(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                "Financial Health",
                                                style: styleGeorgiaBold(
                                                    fontSize: 18),
                                              ),
                                              const SpacerHorizontal(width: 10),
                                            ],
                                          ),
                                          const SpacerVertical(height: 3),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: healthLabel == "Weak"
                                                    ? const Color.fromARGB(
                                                        255, 244, 67, 54)
                                                    : healthLabel == "Moderate"
                                                        ? const Color.fromARGB(
                                                            255, 253, 239, 45)
                                                        : const Color.fromARGB(
                                                            255, 43, 255, 117),
                                              ),
                                              child: Text(
                                                "${morningStar?.quantFinancialHealthLabel}",
                                                style: styleGeorgiaBold(
                                                  fontSize: 12,
                                                  color: healthLabel == "Weak"
                                                      ? Colors.white
                                                      : healthLabel ==
                                                              "Moderate"
                                                          ? Colors.black
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Text(
                                          //   "Intended to reflect the probability that a firm will face financial distress in the near future",
                                          //   style: styleGeorgiaRegular(
                                          //     color: ThemeColors.greyText,
                                          //   ),
                                          // ),
                                          const SpacerVertical(height: 3),
                                          Text(
                                            "As on - ${morningStar?.quantFinancialHealthDate}",
                                            style: stylePTSansRegular(
                                              fontSize: 12,
                                              color: ThemeColors.greyText,
                                            ),
                                          ),
                                        ],
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
                                      builder: (_) => WebviewLink(
                                          stringURL: morningStar?.pdfUrl),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ThemeColors.themeGreen,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
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
                                              "Powered by Morningstar",
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
                                      const SpacerHorizontal(width: 12),
                                      // const Icon(Icons.picture_as_pdf_outlined, size: 30),
                                      Image.asset(
                                        Images.viewFile,
                                        width: 36,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Positioned(
                          //   bottom: -8,
                          //   right: 8,
                          //   // child: FloatingActionButton(
                          //   //   backgroundColor: ThemeColors.accent,
                          //   //   child: const Icon(Icons.share),
                          //   //   onPressed: () {
                          //   //     commonShare(
                          //   //       title: provider.data?.postDetail?.title ?? "",
                          //   //       url: provider.data?.postDetail?.slug ?? "",
                          //   //     );
                          //   //   },
                          //   // ),
                          //   child: ThemeButtonSmall(
                          //     onPressed: () {
                          //       commonShare(
                          //         title: provider.overviewRes!.morningStart!
                          //                 .lockInformation?.title ??
                          //             "",
                          //         url: provider.overviewRes!.morningStart!
                          //                 .lockInformation?.readingSubtitle ??
                          //             "",
                          //       );
                          //     },
                          //     text: "Share Story",
                          //     fontBold: true,
                          //     icon: Icons.share,
                          //   ),
                          // ),
                          if ((provider.overviewRes!.morningStart!
                                      .lockInformation?.readingStatus ==
                                  false) &&
                              !provider.isLoadingOverview)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: height / 1.2,
                                  // height: MediaQuery.of(context).size.height / 2,
                                  // height: double.infinity,
                                  // width: double.infinity,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        ThemeColors.tabBack,
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  // height: height / 1.2,
                                  height: MediaQuery.of(context).size.height,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: ThemeColors.tabBack,
                                  ),
                                  child: context.watch<UserProvider>().user ==
                                          null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.lock, size: 40),
                                              const SpacerVertical(),
                                              Text(
                                                "${provider.overviewRes?.morningStart?.lockInformation?.readingTitle}",
                                                style: stylePTSansBold(
                                                    fontSize: 18),
                                              ),
                                              const SpacerVertical(height: 10),
                                              Text(
                                                "${provider.overviewRes?.morningStart?.lockInformation?.readingSubtitle}",
                                                style: stylePTSansRegular(
                                                  fontSize: 14,
                                                  height: 1.3,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SpacerVertical(height: 10),
                                              // if (context.watch<UserProvider>().user == null)
                                              ThemeButtonSmall(
                                                onPressed: () {
                                                  _onLoginClick(context);
                                                },
                                                text: "Login to continue",
                                                showArrow: false,
                                              ),
                                              const SpacerVertical(),
                                            ],
                                          ),
                                        )
                                      : provider
                                                      .overviewRes
                                                      ?.morningStart
                                                      ?.lockInformation
                                                      ?.balanceStatus ==
                                                  null ||
                                              provider
                                                      .overviewRes
                                                      ?.morningStart
                                                      ?.lockInformation
                                                      ?.balanceStatus ==
                                                  false
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.lock,
                                                      size: 40),
                                                  const SpacerVertical(),
                                                  Text(
                                                    "${provider.overviewRes?.morningStart?.lockInformation?.readingTitle}",
                                                    style: stylePTSansBold(
                                                        fontSize: 18),
                                                  ),
                                                  const SpacerVertical(
                                                      height: 10),
                                                  Text(
                                                    "${provider.overviewRes?.morningStart?.lockInformation?.readingSubtitle}",
                                                    style: stylePTSansRegular(
                                                      fontSize: 14,
                                                      height: 1.3,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SpacerVertical(
                                                      height: 10),
                                                  ThemeButtonSmall(
                                                    onPressed: () async {
                                                      // Share.share(
                                                      //   "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                                                      // );

                                                      await _onReferClick(
                                                          context);
                                                    },
                                                    text: "Refer Now",
                                                    showArrow: false,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.lock,
                                                      size: 40),
                                                  const SpacerVertical(),
                                                  Text(
                                                    "${provider.overviewRes?.morningStart?.lockInformation?.readingTitle}",
                                                    style: stylePTSansBold(
                                                        fontSize: 18),
                                                  ),
                                                  const SpacerVertical(
                                                      height: 10),
                                                  Text(
                                                    "${provider.overviewRes?.morningStart?.lockInformation?.readingSubtitle}",
                                                    style: stylePTSansRegular(
                                                      fontSize: 14,
                                                      height: 1.3,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SpacerVertical(
                                                      height: 10),
                                                  ThemeButtonSmall(
                                                    // onPressed: () =>
                                                    //     _onViewBlogClick(context),
                                                    onPressed: () =>
                                                        _onViewNewsClick(
                                                            context),
                                                    text: "View News",
                                                    showArrow: false,
                                                  ),
                                                ],
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
                                )),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: styleGeorgiaBold(),
            ),
          ),
          const SpacerHorizontal(width: 10),
          Text(
            value ?? "",
            style: styleGeorgiaBold(color: valueColor, fontSize: 20),
          )
        ],
      ),
    );
  }
}
