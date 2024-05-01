import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';

class HomeItemInsiderTrending extends StatefulWidget {
  const HomeItemInsiderTrending({super.key});

  @override
  State<HomeItemInsiderTrending> createState() =>
      _HomeItemInsiderTrendingState();
}

class _HomeItemInsiderTrendingState extends State<HomeItemInsiderTrending> {
  int openItemIndex = -1;

//
  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    if (provider.homeInsiderRes!.insiderTrading.isEmpty) {
      return const ErrorDisplayWidget(
        error: Const.errNoRecord,
        smallHeight: true,
      );
    }

    return ListView.separated(
      itemCount: provider.homeInsiderRes!.insiderTrading.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 12.sp),
      itemBuilder: (context, index) {
        InsiderTrading data = provider.homeInsiderRes!.insiderTrading[index];
        // if (index == 0) {
        //   return Column(
        //     children: [
        //       Divider(
        //         color: ThemeColors.greyBorder,
        //         height: 15.sp,
        //         thickness: 1,
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Expanded(
        //             flex: 2,
        //             child: Text(
        //               "COMPANY",
        //               style: stylePTSansRegular(
        //                 fontSize: 12,
        //                 color: ThemeColors.greyText,
        //               ),
        //             ),
        //           ),
        //           const SpacerHorizontal(width: 10),
        //           Expanded(
        //             flex: 2,
        //             child: Text(
        //               "INSIDER NAME",
        //               style: stylePTSansRegular(
        //                 fontSize: 12,
        //                 color: ThemeColors.greyText,
        //               ),
        //             ),
        //           ),
        //           const SpacerHorizontal(width: 10),
        //           Expanded(
        //             child: Text(
        //               "BUY/SELL",
        //               style: stylePTSansRegular(
        //                 fontSize: 12,
        //                 color: ThemeColors.greyText,
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //       Divider(
        //         color: ThemeColors.greyBorder,
        //         height: 15.sp,
        //         thickness: 1,
        //       ),
        //       InsiderContentItem(data: data),
        //     ],
        //   );
        // }
        return InsiderContentItem(
          data: data,
          isOpen: openItemIndex == index,
          onTap: () {
            // Toggle open/close state
            setState(() {
              openItemIndex = openItemIndex == index ? -1 : index;
            });
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        // return const SpacerVertical(height: 12);
        return Divider(
          color: ThemeColors.greyBorder,
          height: 12.sp,
        );
      },
    );
  }
}

// class StocksItemTrending extends StatefulWidget {
//   final bool up;
//   const StocksItemTrending({this.up = true, super.key});
//   @override
//   State<StocksItemTrending> createState() => _StocksItemTrendingState();
// }
// class _StocksItemTrendingState extends State<StocksItemTrending> {
//   bool open = false;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () {
//             setState(() {
//               open = !open;
//             });
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "NYSL:TSLA",
//                       style: stylePTSansBold(
//                         fontSize: 14,
//                         color: ThemeColors.accent,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SpacerVertical(height: 5),
//                     Text(
//                       "Tesla Inc",
//                       style: stylePTSansRegular(
//                         color: ThemeColors.greyText,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SpacerHorizontal(width: 10),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "ABCD ABCD ABCD",
//                       style: stylePTSansBold(fontSize: 14),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SpacerVertical(height: 5),
//                     Text(
//                       "Tesla Inc",
//                       style: stylePTSansRegular(
//                         color: ThemeColors.greyText,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SpacerHorizontal(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text("Buy", style: stylePTSansBold(fontSize: 14)),
//                     const SpacerVertical(height: 5),
//                     Container(
//                       decoration: const BoxDecoration(
//                         color: ThemeColors.accent,
//                       ),
//                       margin: EdgeInsets.only(left: 8.sp),
//                       padding: const EdgeInsets.all(3),
//                       child: Icon(
//                         open
//                             ? Icons.arrow_upward_rounded
//                             : Icons.arrow_downward_rounded,
//                         size: 16.sp,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 150),
//           child: Container(
//               height: open ? null : 0,
//               margin: EdgeInsets.only(
//                 top: open ? 10.sp : 0,
//                 bottom: open ? 10.sp : 0,
//               ),
//               child: const Column(
//                 children: [
//                   InnerRowItem(lable: "Shares Bought/Sold", value: "2,455"),
//                   InnerRowItem(lable: "Total Transaction", value: "\$2,455"),
//                   InnerRowItem(
//                     lable: "Shares Held After Transaction",
//                     value: "1,455",
//                   ),
//                   InnerRowItem(lable: "Transaction Date", value: "12/05/2023"),
//                   InnerRowItem(lable: "Details", link: true),
//                 ],
//               )),
//         )
//       ],
//     );
//   }
// }
// class InnerRowItem extends StatelessWidget {
//   final String lable;
//   final String? value;
//   final bool link;
//   const InnerRowItem({
//     required this.lable,
//     this.value,
//     this.link = false,
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 10.sp),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(lable, style: stylePTSansBold(fontSize: 14)),
//               Flexible(
//                 child: !link
//                     ? Text(value ?? '', style: stylePTSansBold(fontSize: 14))
//                     : InkWell(
//                         onTap: () {},
//                         child: Text(
//                           "See Details",
//                           style: stylePTSansBold(
//                               fontSize: 14,
//                               color: ThemeColors.accent,
//                               decoration: TextDecoration.underline),
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           color: ThemeColors.dividerDark,
//           height: 1.sp,
//           thickness: 1.sp,
//         )
//       ],
//     );
//   }
// }
