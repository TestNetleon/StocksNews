// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:readmore/readmore.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/stockDetails/widgets/sectorIndustry/sector_industry.dart';
// import 'package:stocks_news_new/screens/stockDetails/widgets/states.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../../modals/stockDetailRes/tab.dart';

// //
// class SdCompanyBrief extends StatelessWidget {
//   const SdCompanyBrief({super.key});
//   void _navigateSector(context, name, titleName) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (_) => SectorIndustry(
//           name: name,
//           stockStates: StockStates.sector,
//           titleName: titleName,
//         ),
//       ),
//     );
//   }

//   void _navigateIndustry(context, name, titleName) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (_) => SectorIndustry(
//           name: name,
//           stockStates: StockStates.industry,
//           titleName: titleName,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockDetailTabRes? res = context.watch<StockDetailProviderNew>().tabRes;

//     res?.keyStats?.name ?? "";
//     return Padding(
//       padding: EdgeInsets.only(bottom: 20.sp),
//       child: Column(
//         children: [
//           ScreenTitle(
//             title:
//                 "Company brief: ${res?.keyStats?.name} (${res?.keyStats?.symbol})",
//           ),
//           Visibility(
//             visible: res?.companyInfo?.sector != null,
//             child: StateItem(
//               label: "Sector",
//               value: "${res?.companyInfo?.sector}",
//               clickable: true,
//               onTap: () => _navigateSector(context,
//                   res?.companyInfo?.sectorSlug ?? "", res?.companyInfo?.sector),
//             ),
//           ),
//           Visibility(
//             visible: res?.companyInfo?.industry != null,
//             child: StateItem(
//               label: "Industry",
//               value: "${res?.companyInfo?.industry}",
//               clickable: true,
//               onTap: () => _navigateIndustry(
//                   context,
//                   res?.companyInfo?.industrySlug ?? "",
//                   res?.companyInfo?.industry),
//             ),
//           ),
//           Visibility(
//               visible: res?.companyInfo?.ceo != null,
//               child: StateItem(label: "CEO", value: res?.companyInfo?.ceo)),
//           Visibility(
//             visible: res?.companyInfo?.website != null,
//             child: StateItem(
//               label: "Website",
//               value: res?.companyInfo?.website,
//               clickable: true,
//               onTap: () => openUrl(res?.companyInfo?.website),
//             ),
//           ),
//           Visibility(
//             visible: res?.companyInfo?.country != null,
//             child: StateItem(
//               label: "Headquarters",
//               value: res?.companyInfo?.country,
//             ),
//           ),
//           Visibility(
//             visible: res?.companyInfo?.fullTimeEmployees != null,
//             child: StateItem(
//               label: "Employees (FY)",
//               value: res?.companyInfo?.fullTimeEmployees,
//             ),
//           ),
//           Visibility(
//               visible: res?.companyInfo?.ipoDate != null,
//               child: StateItem(
//                   label: "Founded", value: res?.companyInfo?.ipoDate)),
//           Visibility(
//               visible: res?.companyInfo?.isin != null,
//               child: StateItem(label: "ISIN", value: res?.companyInfo?.isin)),
//           const SpacerVertical(height: 5),
//           Visibility(
//             visible: res?.companyInfo?.description != null,
//             // child: Text(
//             //   res?.companyInfo?.description ?? "",
//             //   style: stylePTSansRegular(
//             //     fontSize: 14,
//             //     height: 1.3,
//             //     color: ThemeColors.white,
//             //   ),
//             // ),
//             child: ReadMoreText(
//               textAlign: TextAlign.start,
//               res?.companyInfo?.description ?? "",
//               trimLines: 5,
//               colorClickableText: ThemeColors.accent,
//               trimMode: TrimMode.Line,
//               trimCollapsedText: 'Read more',
//               trimExpandedText: 'Read less',
//               moreStyle: stylePTSansRegular(color: ThemeColors.accent),
//               style: stylePTSansRegular(height: 1.4),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/overview/stock_score.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sectorIndustry/sector_industry.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../modals/stockDetailRes/tab.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_horizontal.dart';

//
class SdCompanyBrief extends StatelessWidget {
  const SdCompanyBrief({super.key});
  void _navigateSector(context, name, titleName) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => SectorIndustry(
          name: name,
          stockStates: StockStates.sector,
          titleName: titleName,
        ),
      ),
    );
  }

  void _navigateIndustry(context, name, titleName) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => SectorIndustry(
          name: name,
          stockStates: StockStates.industry,
          titleName: titleName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    StockDetailTabRes? res = context.watch<StockDetailProviderNew>().tabRes;

    res?.keyStats?.name ?? "";
    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Column(
        children: [
          ScreenTitle(
            title:
                "Company brief: ${res?.keyStats?.name} (${res?.keyStats?.symbol})",
          ),
          // Visibility(
          //   visible: res?.companyInfo?.sector != null,
          //   child: StateItem(
          //     label: "Sector",
          //     value: "${res?.companyInfo?.sector}",
          //     clickable: true,
          //     onTap: () => _navigateSector(context,
          //         res?.companyInfo?.sectorSlug ?? "", res?.companyInfo?.sector),
          //   ),

          // ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: stockDOverviewItem(
                title: "CEO", value: "${res?.companyInfo?.ceo}"),
          ),

          Row(
            children: [
              Expanded(
                  child: stockDOverviewItem(
                      title: "Country", value: "${res?.companyInfo?.country}")),
              const SpacerHorizontal(width: 8),
              Expanded(
                  child: stockDOverviewItem(
                      title: "Employees (FY)",
                      value: res?.companyInfo?.fullTimeEmployees)),
            ],
          ),
          const SpacerVertical(height: 8),

          Row(
            children: [
              Expanded(
                  child: stockDOverviewItem(
                      title: "Founded", value: "${res?.companyInfo?.ipoDate}")),
              const SpacerHorizontal(width: 8),
              Expanded(
                  child: stockDOverviewItem(
                      title: "ISIN", value: res?.companyInfo?.isin)),
            ],
          ),
          const SpacerVertical(height: 8),
          Visibility(
            visible: res?.companyInfo?.sector != null &&
                res?.companyInfo?.sector != '',
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: double.infinity,
              child: stockDOverviewItem(
                  onTap: () => _navigateSector(
                      context,
                      res?.companyInfo?.sectorSlug ?? "",
                      res?.companyInfo?.sector),
                  title: "Sector",
                  value: res?.companyInfo?.sector),
            ),
          ),
          Visibility(
            visible: res?.companyInfo?.industry != null &&
                res?.companyInfo?.industry != '',
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: double.infinity,
              child: stockDOverviewItem(
                  onTap: () => _navigateIndustry(
                      context,
                      res?.companyInfo?.industrySlug ?? "",
                      res?.companyInfo?.industry),
                  title: "Industry",
                  value: res?.companyInfo?.industry),
            ),
          ),

          Visibility(
            visible: res?.companyInfo?.website != null &&
                res?.companyInfo?.website != '',
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: double.infinity,
              child: stockDOverviewItem(
                  onTap: () => openUrl(res?.companyInfo?.website),
                  title: "Website",
                  value: res?.companyInfo?.website),
            ),
          ),
          Visibility(
            visible: res?.companyInfo?.description != null,
            // child: Text(
            //   res?.companyInfo?.description ?? "",
            //   style: stylePTSansRegular(
            //     fontSize: 14,
            //     height: 1.3,
            //     color: ThemeColors.white,
            //   ),
            // ),
            child: ReadMoreText(
              textAlign: TextAlign.start,
              res?.companyInfo?.description ?? "",
              trimLines: 3,
              colorClickableText: ThemeColors.accent,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' Read more',
              trimExpandedText: ' Read less',
              moreStyle: stylePTSansRegular(color: ThemeColors.accent),
              style: stylePTSansRegular(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
