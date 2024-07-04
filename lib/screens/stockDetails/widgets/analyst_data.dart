import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/custom_cliper.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class StockDetailAnalystData extends StatelessWidget {
  const StockDetailAnalystData({super.key});

  @override
  Widget build(BuildContext context) {
    MorningStar? morningStar =
        context.watch<StockDetailProviderNew>().overviewRes?.morningStart;

    int value = morningStar?.quantEconomicMoatLabel == "Narrow"
        ? 70
        : morningStar?.quantEconomicMoatLabel == "Wide"
            ? 99
            : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: ThemeColors.greyBorder.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Quantitative Equity Research Report ",
                style: styleGeorgiaBold(fontSize: 18),
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              const EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => const Icon(
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
                        width: constraints.maxWidth * (value / 100),
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
              // Row(
              //   children: [
              //     Flexible(
              //       flex: 1,
              //       child: Container(
              //         height: 30,
              //         decoration: const BoxDecoration(
              //           color: ThemeColors.accent,
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(30),
              //             bottomLeft: Radius.circular(30),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SpacerHorizontal(width: 2),
              //     Flexible(
              //       flex: 1,
              //       child: Container(
              //         height: 30,
              //         decoration: const BoxDecoration(
              //           color: Color.fromARGB(255, 255, 191, 52),
              //         ),
              //       ),
              //     ),
              //     const SpacerHorizontal(width: 2),
              //     Flexible(
              //       flex: 1,
              //       child: Container(
              //         height: 30,
              //         decoration: const BoxDecoration(
              //           color: Colors.orange,
              //           borderRadius: BorderRadius.only(
              //             topRight: Radius.circular(30),
              //             bottomRight: Radius.circular(30),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SpacerVertical(height: 5),
              // Row(
              //   children: [
              //     Flexible(
              //       child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           "Buy ${anaRes?.buyPercent ?? "N/A"}%",
              //           style: stylePTSansRegular(
              //             color: ThemeColors.accent,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Flexible(
              //       child: Align(
              //         alignment: Alignment.center,
              //         child: Text(
              //           "Hold ${anaRes?.holdPercent ?? "N/A"}%",
              //           style: stylePTSansRegular(
              //             color: const Color.fromARGB(255, 255, 191, 52),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Flexible(
              //       child: Align(
              //         alignment: Alignment.centerRight,
              //         child: Text(
              //           "Sell ${anaRes?.sellPercent ?? "N/A"}%",
              //           style: stylePTSansRegular(
              //             color: Colors.orange,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SpacerVertical(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible(
                  //   child: Row(
                  //     children: [
                  //       const Icon(
                  //         Icons.person_outline_rounded,
                  //         size: 18,
                  //         color: ThemeColors.greyBorder,
                  //       ),
                  //       const SpacerHorizontal(width: 5),
                  //       Flexible(
                  //         child: Text(
                  //           "${anaRes?.totalAnalysis ?? "N/A"} analysts",
                  //           style: stylePTSansRegular(fontSize: 12),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: ThemeColors.greyBorder,
                        ),
                        const SpacerHorizontal(width: 5),
                        Flexible(
                          child: Text(
                            "Updated on ${morningStar?.updated ?? "N/A"}",
                            style: stylePTSansRegular(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // const SpacerVertical(height: 20),
              // Text(
              //   "Source: morningstar.com",
              //   style: stylePTSansRegular(
              //     fontSize: 12,
              //     color: ThemeColors.greyText,
              //   ),
              // )
              const SpacerVertical(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  // color: ThemeColors.gradientLight,
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ThemeColors.bottomsheetGradient,
                      // ThemeColors.blackShade,
                      ThemeColors.greyBorder.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    ItemRow(
                      label: "Fair Value",
                      value: "${morningStar?.quantFairValue}",
                    ),
                    // const SpacerVertical(height: 10),
                    const Divider(color: ThemeColors.divider),
                    ItemRow(
                      label: "Valuation",
                      value: "${morningStar?.quantValuation}",
                      valueColor: Colors.red,
                    ),
                    // const SpacerVertical(height: 10),
                    const Divider(color: ThemeColors.divider),
                    ItemRow(
                      label: "Price over quant fair value date",
                      value: "${morningStar?.priceOverQuantFairValueDate}",
                    ),
                    // const SpacerVertical(height: 10),
                    const Divider(color: ThemeColors.divider),
                    ItemRow(
                      label: "Fair value date",
                      value: "${morningStar?.quantFairValueDate}",
                    ),
                    // const SpacerVertical(height: 10),
                    const Divider(color: ThemeColors.divider),
                    ItemRow(
                      label: "Fair value uncertainty",
                      value: "${morningStar?.quantFairValueUncertaintyLabel}",
                      valueColor: Colors.red,
                    ),
                  ],
                ),
              ),
              const SpacerVertical(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  // color: ThemeColors.gradientLight,
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ThemeColors.bottomsheetGradient,
                      // ThemeColors.blackShade,
                      ThemeColors.greyBorder.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    style: stylePTSansBold(fontSize: 24),
                                  ),
                                  const SpacerVertical(height: 5),
                                  Text(
                                    "${morningStar?.oneStarPriceDate}",
                                    style: stylePTSansRegular(fontSize: 12),
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
                                    style: stylePTSansBold(fontSize: 24),
                                  ),
                                  const SpacerVertical(height: 5),
                                  Text(
                                    "${morningStar?.fiveStarPriceDate}",
                                    style: stylePTSansRegular(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Divider(color: ThemeColors.divider),
                    ItemRow(
                      label: "Fair value uncertainty date",
                      value: "${morningStar?.quantFairValueUncertaintyDate}",
                    ),
                    // const SpacerVertical(height: 10),
                    // ItemRow(
                    //   label: "One star price",
                    //   value: "${morningStar?.oneStarPrice}",
                    // ),
                    // const Divider(color: ThemeColors.divider),
                    // ItemRow(
                    //   label: "One star price date",
                    //   value: "${morningStar?.oneStarPriceDate}",
                    // ),
                    // const Divider(color: ThemeColors.divider),
                    // ItemRow(
                    //   label: "Five star price",
                    //   value: "${morningStar?.fiveStarPrice}",
                    // ),
                    // const Divider(color: ThemeColors.divider),
                    // ItemRow(
                    //   label: "Five star price date",
                    //   value: "${morningStar?.fiveStarPriceDate}",
                    // ),
                    const Divider(color: ThemeColors.divider),
                    ItemRow(
                      label: "Financial health",
                      value: "${morningStar?.quantFinancialHealthLabel}",
                    ),
                    const Divider(color: ThemeColors.divider),
                    ItemRow(
                      label: "Financial health date",
                      value: "${morningStar?.quantFinancialHealthDate}",
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
                      builder: (_) =>
                          WebviewLink(stringURL: morningStar?.pdfUrl),
                    ),
                  );
                  // openUrl(morningStar?.pdfUrl);
                },
                // text: "VIEW FULL REPORT",
                // icon: Icons.picture_as_pdf,

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Download Quantitative Research Report",
                              style: stylePTSansBold(),
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              "Powered by Morningstar",
                              style: stylePTSansRegular(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // const Icon(Icons.picture_as_pdf_outlined, size: 30),
                      Image.asset(Images.downloadFile)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
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
              style: styleGeorgiaRegular(),
            ),
          ),
          const SpacerHorizontal(width: 10),
          Text(
            value ?? "",
            style: styleGeorgiaBold(color: valueColor, fontSize: 14),
          )
        ],
      ),
    );
  }
}
