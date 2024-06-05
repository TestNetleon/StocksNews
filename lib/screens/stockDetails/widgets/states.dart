// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stock_details_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// //
// class States extends StatelessWidget {
//   const States({super.key});

//   // void _navigateSector(context, name, titleName) {
//   //   Navigator.pushNamed(context, SectorIndustry.path, arguments: {
//   //     "type": StockStates.sector,
//   //     "name": name,
//   //     "titleName": titleName,
//   //   });
//   // }

//   // void _navigateIndustry(context, name, titleName) {
//   //   Navigator.pushNamed(context, SectorIndustry.path, arguments: {
//   //     "type": StockStates.industry,
//   //     "name": name,
//   //     "titleName": titleName,
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     KeyStats? keyStats = context.watch<StockDetailProvider>().data?.keyStats;
//     // CompanyInfo? companyInfo =
//     //     context.watch<StockDetailProvider>().data?.companyInfo;
//     return Column(
//       children: [
//         ScreenTitle(
//           // title: "Key Stats",
//           subTitle: keyStats?.text,
//         ),
//         // StateItem(label: "Symbol", value: keyStats?.symbol),
//         // StateItem(label: "Name", value: keyStats?.name),
//         StateItem(label: "Price", value: keyStats?.price),
//         StateItem(
//           label: "Change Percentage",
//           value: keyStats?.changesPercentage?.toCurrency() ?? "",
//         ),
//         StateItem(label: "Change", value: "${keyStats?.change ?? ""}"),
//         StateItem(label: "Day Low", value: keyStats?.dayLow),
//         StateItem(label: "Day High", value: keyStats?.dayHigh),
//         StateItem(label: "Year Low", value: keyStats?.yearLow),
//         StateItem(label: "Year High", value: keyStats?.yearHigh),
//         StateItem(label: "Market Capitalization", value: keyStats?.marketCap),
//         // StateItem(
//         //   label: "Sector",
//         //   value: companyInfo?.sector,
//         //   clickable: true,
//         //   onTap: () => _navigateSector(
//         //       context, companyInfo?.sectorSlug, companyInfo?.sector),
//         // ),
//         // StateItem(
//         //   label: "Industry",
//         //   value: companyInfo?.industry,
//         //   clickable: true,
//         //   onTap: () => _navigateIndustry(
//         //       context, companyInfo?.industrySlug, companyInfo?.industry),
//         // ),
//         StateItem(label: "Price Avg 50 EMA (D)", value: keyStats?.priceAvg50),
//         StateItem(label: "Price Avg 200 EMA (D)", value: keyStats?.priceAvg200),
//         StateItem(label: "Exchange", value: keyStats?.exchange),
//         StateItem(label: "Volume", value: keyStats?.volume),
//         StateItem(label: "Average Volume", value: keyStats?.avgVolume),
//         StateItem(label: "Open", value: keyStats?.open),
//         StateItem(label: "Previous Close", value: keyStats?.previousClose),
//         StateItem(label: "EPS", value: "${keyStats?.eps ?? ""}"),
//         StateItem(label: "P-E", value: "${keyStats?.pe ?? ""}"),
//         StateItem(
//             label: "Earnings Announcement",
//             value: keyStats?.earningsAnnouncement),
//         StateItem(
//             label: "Shares Outstanding", value: keyStats?.sharesOutstanding),

//         // StateItem(label: "Avg. Volume (100-day)", value: keyStats.avgVolume),
//         // const StateItem(label: "Days Range", value: "\$158.22 - \$159.22"),
//         // const StateItem(label: "52-Week range", value: "\$158.22 - \$159.22"),
//         // const StateItem(label: "Dividend Yield", value: "0.05%"),
//         // const StateItem(label: "Ex. Dividend Date", value: "11/10/2023"),

//         // const StateItem(label: "Avg,. Analyst Rec.", value: "Buy"),
//         // const StateItem(label: "Beta", value: "0.99"),
//         // const StateItem(label: "PEG Rtio", value: "5.62"),
//       ],
//     );
//   }
// }

// class StateItem extends StatelessWidget {
//   final String label;
//   final String? value;
//   final bool clickable;
//   final bool divider;
//   final void Function()? onTap;
//   const StateItem({
//     required this.label,
//     this.value,
//     this.clickable = false,
//     this.divider = true,
//     this.onTap,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (value == null || value == "") {
//       return const SizedBox();
//     }
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 5.sp),
//           child: Row(
//             children: [
//               Text(
//                 label,
//                 style: stylePTSansRegular(
//                   fontSize: 14,
//                   color: ThemeColors.greyText,
//                 ),
//               ),
//               const SpacerHorizontal(width: 10),
//               Expanded(
//                 child: InkWell(
//                   onTap: onTap,
//                   child: Text(
//                     textAlign: TextAlign.end,
//                     value ?? "",
//                     style: stylePTSansRegular(
//                         fontSize: 14,
//                         color: clickable ? ThemeColors.accent : Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Visibility(
//           visible: divider,
//           child: const Divider(
//               height: .5, thickness: .5, color: ThemeColors.greyBorder),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'stockTopWidgets/common_heading.dart';

//
class States extends StatefulWidget {
  const States({super.key});

  @override
  State<States> createState() => _StatesState();
}

class _StatesState extends State<States> {
  @override
  Widget build(BuildContext context) {
    KeyStats? keyStats = context.watch<StockDetailProvider>().data?.keyStats;

    return Column(
      children: [
        const CommonHeadingStockDetail(),
        CustomGridView(
          paddingVerticle: 8.sp,
          paddingHorizontal: 5.sp,
          length: 25,
          getChild: (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0)
                StateItemNEW(label: "Symbol", value: keyStats?.symbol),
              if (index == 1)
                StateItemNEW(label: "Name", value: keyStats?.name),

              if (index == 2)
                StateItemNEW(label: "Price", value: keyStats?.price),
              if (index == 3)
                Visibility(
                  visible: keyStats?.change != null,
                  child: StateItemNEW(
                      label: "Change", value: "\$${keyStats?.change ?? ""}"),
                ),
              if (index == 4)
                Visibility(
                  visible: keyStats?.changesPercentage != null,
                  child: StateItemNEW(
                    label: "Change Per.",
                    value: "${keyStats?.changesPercentage?.toCurrency()}%",
                  ),
                ),
              if (index == 5)
                StateItemNEW(label: "Day Low", value: keyStats?.dayLow),
              if (index == 6)
                StateItemNEW(label: "Day High", value: keyStats?.dayHigh),
              if (index == 7)
                StateItemNEW(label: "Year Low", value: keyStats?.yearLow),
              if (index == 8)
                StateItemNEW(label: "Year High", value: keyStats?.yearHigh),
              if (index == 9)
                StateItemNEW(label: "Volume", value: keyStats?.volume),
              if (index == 10)
                StateItemNEW(
                    label: "Avg. Volume (3m)", value: keyStats?.avgVolume),

              if (index == 11)
                StateItemNEW(
                    label: "Previous Close", value: keyStats?.previousClose),

              if (index == 12)
                StateItemNEW(label: "Open", value: keyStats?.open),
              if (index == 13)
                StateItemNEW(label: "EPS", value: "${keyStats?.eps ?? ""}"),
              if (index == 14)
                StateItemNEW(
                    label: "P/E ratio", value: "${keyStats?.pe ?? ""}"),

              if (index == 15)
                StateItemNEW(
                    label: "Avg 50 EMA (D)", value: keyStats?.priceAvg50),
              if (index == 16)
                StateItemNEW(
                    label: "Avg 200 EMA (D)", value: keyStats?.priceAvg200),
              // if (index == 10)
              //   StateItemNEW(label: "Exchange", value: keyStats?.exchange),
              if (index == 17)
                StateItemNEW(label: "Revenue", value: keyStats?.revenue),
              if (index == 18)
                StateItemNEW(
                    label: "Book value/Share",
                    value: keyStats?.bookValuePerShare),
              if (index == 19)
                StateItemNEW(
                    label: "Dividend (yield)", value: keyStats?.dividendYield),
              if (index == 20)
                StateItemNEW(
                    label: "EV/Ebitda",
                    value: keyStats?.enterpriseValueOverEbitda),
              if (index == 21)
                Visibility(
                  visible: (keyStats?.bid != null && keyStats?.bid != '') ||
                      keyStats?.ask != null && keyStats?.ask != '',
                  child: StateItemNEW(
                      label: "Bid/Ask",
                      value:
                          "${keyStats?.bid ?? "N/A"}/${keyStats?.ask ?? "N/A"}"),
                ),
              // if (index == 22) StateItemNEW(label: "Fair Value", value: "-"),
              // if (index == 23)
              //   StateItemNEW(label: "Analyst target price", value: "-"),

              if (index == 22)
                StateItemNEW(label: "Market Cap.", value: keyStats?.marketCap),
              if (index == 23)
                StateItemNEW(
                    label: "Shares Outstanding",
                    value: keyStats?.sharesOutstanding),
              if (index == 24)
                StateItemNEW(
                    label: "Earnings Announcement",
                    value: keyStats?.earningsAnnouncement),
            ],
          ),
        ),
      ],
    );
  }
}

class StateItem extends StatelessWidget {
  final String label;
  final String? value;
  final bool clickable;
  final bool divider;
  final void Function()? onTap;
  const StateItem({
    required this.label,
    this.value,
    this.clickable = false,
    this.divider = true,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value == "") {
      return const SizedBox();
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp),
          child: Row(
            children: [
              Text(
                label,
                style: stylePTSansRegular(
                  fontSize: 14,
                  color: ThemeColors.greyText,
                ),
              ),
              const SpacerHorizontal(width: 10),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Text(
                    textAlign: TextAlign.end,
                    value ?? "",
                    style: stylePTSansRegular(
                        fontSize: 14,
                        color: clickable ? ThemeColors.accent : Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: divider,
          child: const Divider(
              height: .5, thickness: .5, color: ThemeColors.greyBorder),
        ),
      ],
    );
  }
}

class StateItemNEW extends StatelessWidget {
  final String label;
  final String? value;
  final bool clickable;
  final bool divider;
  final void Function()? onTap;
  const StateItemNEW({
    required this.label,
    this.value,
    this.clickable = false,
    this.divider = true,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value == "") {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: stylePTSansRegular(
            fontSize: 12,
            color: ThemeColors.greyText,
          ),
        ),
        const SpacerVertical(height: 5),
        InkWell(
          onTap: onTap,
          child: Text(
            textAlign: TextAlign.start,
            value ?? "",
            style: stylePTSansRegular(
                fontSize: 13,
                color: clickable ? ThemeColors.accent : Colors.white),
          ),
        ),
      ],
    );
  }
}
