import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/pdfViewer/pdf_viewer_widget.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../routes/my_app.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../tabs/more/morningstarReport/index.dart';
import 'economic.dart';
import 'fair.dart';
import 'lock.dart';
import 'valuable.dart';

class SDMorningStarView extends StatelessWidget {
  final MorningStarRes? data;
  const SDMorningStarView({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return SizedBox();
    }

    if (data?.lockInformation?.readingStatus == false) {
      return SDMorningStarLock();
    }

    String? healthLabel = data?.quantFinancialHealthLabel;
    String? unCerLabel = data?.quantFairValueUncertaintyLabel;
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

    Color radialColor = radialValue == 10
        ? ThemeColors.error120
        : radialValue == 30
            ? ThemeColors.orange
            : radialValue == 50
                ? Colors.yellow
                : radialValue == 70
                    ? ThemeColors.success
                    : radialValue == 90
                        ? ThemeColors.success120
                        : ThemeColors.error120;

    double minValue = 0;
    double maxValue = 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(Pad.pad16, 0, Pad.pad16, Pad.pad16),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.sos, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Image.asset(Images.morningStarLogo),
              ),
              const SpacerVertical(height: 10),
              AutoSizeText(
                "Quantitative Equity Research Report",
                textAlign: TextAlign.center,
                style: styleBaseBold(fontSize: 18),
                maxLines: 1,
              ),
              const SpacerVertical(height: 5),
              Text(
                "Powered by MORNINGSTAR",
                textAlign: TextAlign.center,
                style: styleBaseRegular(
                  fontSize: 12,
                  color: ThemeColors.greyText,
                ),
              ),
              const SpacerVertical(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: data?.quantStarRating?.toDouble() ?? 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemSize: 40,
                    unratedColor: ThemeColors.greyBorder,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 14, 41, 0),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: MorningStarEconomicMoat(),
                  ),
                  const Positioned(
                    top: 130,
                    left: 0,
                    right: 0,
                    child: MorningStarValuable(),
                  ),
                  const Positioned(
                    top: 250,
                    left: 0,
                    right: 0,
                    child: MorningStarFairValue(),
                  ),
                ],
              ),
              const SpacerVertical(height: 15),
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
                                      color: ThemeColors.error120,
                                      label: 'Low',
                                      sizeUnit: GaugeSizeUnit.factor,
                                      labelStyle: const GaugeTextStyle(
                                        fontFamily: Fonts.roboto,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColors.white,
                                      ),
                                      startWidth: 0.5,
                                      endWidth: 0.5,
                                    ),
                                    GaugeRange(
                                      startValue: 20,
                                      endValue: 40,
                                      color: ThemeColors.orange,
                                      label: 'Medium',
                                      sizeUnit: GaugeSizeUnit.factor,
                                      labelStyle: const GaugeTextStyle(
                                        fontFamily: Fonts.roboto,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      startWidth: 0.5,
                                      endWidth: 0.5,
                                    ),
                                    GaugeRange(
                                      startValue: 40,
                                      endValue: 60,
                                      color: Colors.yellow,
                                      label: 'High',
                                      sizeUnit: GaugeSizeUnit.factor,
                                      labelStyle: const GaugeTextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      startWidth: 0.5,
                                      endWidth: 0.5,
                                    ),
                                    GaugeRange(
                                      startValue: 60,
                                      endValue: 80,
                                      color: ThemeColors.success,
                                      label: 'Very High',
                                      sizeUnit: GaugeSizeUnit.factor,
                                      labelStyle: const GaugeTextStyle(
                                        fontFamily: Fonts.roboto,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      startWidth: 0.5,
                                      endWidth: 0.5,
                                    ),
                                    GaugeRange(
                                      startValue: 80,
                                      endValue: maxValue,
                                      color: ThemeColors.success120,
                                      label: 'Extreme',
                                      sizeUnit: GaugeSizeUnit.factor,
                                      labelStyle: const GaugeTextStyle(
                                        fontFamily: Fonts.roboto,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      startWidth: 0.5,
                                      endWidth: 0.5,
                                    ),
                                  ],
                                  pointers: [
                                    NeedlePointer(
                                      value: radialValue,
                                      needleColor: radialColor,
                                      knobStyle: KnobStyle(
                                        color: radialColor,
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
                    style: styleBaseBold(),
                    textAlign: TextAlign.center,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "As on - ${data?.quantFairValueUncertaintyDate}",
                    style: styleBaseRegular(
                      fontSize: 12,
                      color: ThemeColors.neutral80,
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.40, 0.9],
                            colors: [
                              Color.fromARGB(226, 238, 55, 42),
                              Color.fromARGB(255, 93, 19, 0),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              "One star price",
                              style: styleBaseRegular(color: ThemeColors.white),
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              "${data?.oneStarPrice}",
                              style: styleBaseBold(
                                fontSize: 24,
                                color: ThemeColors.white,
                              ),
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              "${data?.oneStarPriceDate}",
                              style: styleBaseRegular(
                                fontSize: 12,
                                color: ThemeColors.white,
                              ),
                            ),
                          ],
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
                                Color.fromARGB(255, 45, 161, 30),
                                Color.fromARGB(255, 0, 93, 12),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                "Five star price",
                                style:
                                    styleBaseRegular(color: ThemeColors.white),
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                "${data?.fiveStarPrice}",
                                style: styleBaseBold(
                                  fontSize: 24,
                                  color: ThemeColors.white,
                                ),
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                "${data?.fiveStarPriceDate}",
                                style: styleBaseRegular(
                                  fontSize: 12,
                                  color: ThemeColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SpacerVertical(height: 15),
              Container(
                padding: const EdgeInsets.all(Pad.pad16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: ThemeColors.neutral20,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Financial Health",
                      style: styleBaseBold(
                        fontSize: 18,
                      ),
                    ),
                    SpacerVertical(height: 3),
                    Text(
                      "As on - ${data?.quantFinancialHealthDate}",
                      style: styleBaseRegular(
                        fontSize: 12,
                        color: ThemeColors.neutral40,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            margin: const EdgeInsets.only(
                              top: 10,
                              left: 2,
                            ),
                            child: Image.asset(
                              Images.financialHealth,
                              width: 50,
                              height: 50,
                              color: Colors.black,
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
                            borderRadius: BorderRadius.circular(8),
                            color: healthLabel == "Weak"
                                ? const Color(0xFFF44336)
                                : healthLabel == "Moderate"
                                    ? const Color(0xFFFDEF2D)
                                    : const Color(0xFF2BFF75),
                          ),
                          child: Center(
                            child: Text(
                              "${data?.quantFinancialHealthLabel}",
                              style: styleBaseBold(
                                fontSize: 16,
                                color: healthLabel == "Weak"
                                    ? Colors.white
                                    : healthLabel == "Moderate"
                                        ? Colors.black
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SpacerVertical(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewerWidget(url: data?.pdfUrl ?? ''),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Icon(Icons.picture_as_pdf_outlined, size: 30),
                      const SpacerHorizontal(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "View Research Report",
                              style: styleBaseBold(color: ThemeColors.white),
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              "Powered by MORNINGSTAR",
                              style: styleBaseRegular(
                                fontSize: 12,
                                color: ThemeColors.white,
                              ),
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              "As on - ${data?.updated}",
                              style: styleBaseRegular(
                                fontSize: 12,
                                color: ThemeColors.white,
                              ),
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
              const SpacerVertical(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (_) => const MorningStarReportsIndex()),
                  );
                },
                child: Center(
                  child: Text(
                    "${data?.viewAllText}",
                    style: styleBaseBold(color: ThemeColors.accent),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
