// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/modals/compare_stock_res.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// class FooterItem extends StatelessWidget {
//   final CompareStockRes? company;
//   final int index;
//   const FooterItem({super.key, this.company, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: index == 0 ? 180.sp : 180.sp,
//       width: 200.sp,

//       // decoration: BoxDecoration(
//       //     color: ThemeColors.primaryLight,
//       //     borderRadius: BorderRadius.circular(5.sp),
//       //     border: Border.all(color: ThemeColors.dividerDark)),
//       padding: EdgeInsets.all(5.sp),
//       child: Column(
//         children: [
//           StateItemCompare(
//               label: "Symbol", value: company?.symbol, show: index == 0),
//           StateItemCompare(
//               label: "Name", value: company?.name, show: index == 0),
//           StateItemCompare(
//               label: "Price", value: company?.price, show: index == 0),
//           StateItemCompare(
//               label: "Change Percentage",
//               value: "${company?.changesPercentage.toCurrency()}",
//               show: index == 0),
//           // StateItem(label: "Change", value: "${company?.change}"),
//           StateItemCompare(
//               label: "Day Low", value: company?.dayLow, show: index == 0),
//           StateItemCompare(
//               label: "Day High", value: company?.dayHigh, show: index == 0),
//           StateItemCompare(
//               label: "Year Low", value: company?.yearLow, show: index == 0),
//           StateItemCompare(
//               label: "Year High", value: company?.yearHigh, show: index == 0),
//           // StateItem(label: "Market Capitalization", value: company?.marketCap),
//           // StateItem(
//           //   label: "Sector",
//           //   value: company?.sector,
//           //   clickable: true,

//           // ),
//           // StateItem(
//           //   label: "Industry",
//           //   value: company?.industry,
//           //   clickable: true,
//           // ),
//           StateItemCompare(
//               label: "Price Avg 50",
//               value: company?.priceAvg50,
//               show: index == 0),
//           StateItemCompare(
//               label: "Price Avg 200",
//               value: company?.priceAvg200,
//               show: index == 0),
//           StateItemCompare(
//               label: "Exchange", value: company?.exchange, show: index == 0),
//           StateItemCompare(
//               label: "Volume", value: company?.volume, show: index == 0),
//           StateItemCompare(
//               label: "Average Volume",
//               value: company?.avgVolume,
//               show: index == 0),
//           StateItemCompare(
//               label: "Open", value: company?.open, show: index == 0),
//           StateItemCompare(
//               label: "Previous Close",
//               value: company?.previousClose,
//               show: index == 0),
//           StateItemCompare(
//               label: "EPS", value: "${company?.eps}", show: index == 0),
//           StateItemCompare(
//               label: "P-E", value: "${company?.pe}", show: index == 0),
//           StateItemCompare(
//               label: "Earnings Announcement",
//               value: company?.earningsAnnouncement,
//               show: index == 0),
//           StateItemCompare(
//               label: "Shares Outstanding",
//               value: company?.sharesOutstanding,
//               show: index == 0),
//         ],
//       ),
//     );
//   }
// }

// class StateItemCompare extends StatelessWidget {
//   final String label;
//   final String? value;
//   final bool clickable;
//   final bool show;
//   final void Function()? onTap;
//   const StateItemCompare({
//     required this.label,
//     this.value,
//     this.clickable = false,
//     this.onTap,
//     super.key,
//     this.show = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (value == null || value?.isEmpty == true) {
//       return const SizedBox();
//     }

//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 3.sp),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Visibility(
//                 visible: true,
//                 child: Expanded(
//                   child: Text(
//                     label,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: stylePTSansRegular(
//                       fontSize: 11,
//                       color: ThemeColors.greyText,
//                     ),
//                   ),
//                 ),
//               ),
//               const SpacerHorizontal(width: 10),
//               Expanded(
//                 child: InkWell(
//                   onTap: onTap,
//                   child: Text(
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.end,
//                     value ?? "",
//                     style: stylePTSansRegular(
//                         fontSize: 11,
//                         color: clickable ? ThemeColors.blue : Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           color: ThemeColors.greyBorder,
//           height: 10.sp,
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class FooterItem extends StatelessWidget {
  final CompareStockRes? company;
  final int index;
  const FooterItem({super.key, this.company, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _value(title: company?.symbol),
        _value(title: company?.name),
        _value(title: "${company?.price}"),
        _value(title: "${company?.changesPercentage.toCurrency()}%"),
        _value(title: "${company?.displayChange}"),
        _value(title: company?.dayLow),
        _value(title: company?.dayHigh),
        _value(title: company?.yearLow),
        _value(title: company?.yearHigh),
        _value(title: company?.mktCap),
        _value(title: company?.priceAvg50),
        _value(title: company?.priceAvg200),
        _value(title: company?.exchange),
        _value(title: company?.volume),
        _value(title: company?.avgVolume),
        _value(title: company?.open),
        _value(title: company?.previousClose),
        _value(title: "${company?.eps}"),
        _value(title: "${company?.pe}"),
        _value(title: company?.earningsAnnouncement),
        _value(title: company?.sharesOutstanding),
      ],
    );
  }

  Widget _value({String? title}) {
    if (title == null) {
      return const SizedBox();
    }
    return Container(
      width: 180.sp,
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: ThemeColors.greyBorder,
        )),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: stylePTSansBold(color: ThemeColors.white, fontSize: 12),
      ),
    );
  }
}
