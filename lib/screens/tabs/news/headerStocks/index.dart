// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stock_header_news.dart';
// import 'package:stocks_news_new/providers/news_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// class NewsHeaderStocks extends StatelessWidget {
//   const NewsHeaderStocks({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const NewsHeaderStocksContainer();
//   }
// }

// //
// class NewsHeaderStocksContainer extends StatelessWidget {
//   const NewsHeaderStocksContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     HeaderNewsProvider provider = context.watch<HeaderNewsProvider>();
//     if (provider.isLoading && provider.data == null) {
//       return const SizedBox();
//     }
//     if (!provider.isLoading && provider.data == null) {
//       return const SizedBox();
//     }
//     return Container(
//       height: 32.sp,
//       margin: EdgeInsets.only(bottom: 15.sp),
//       child: ListView.separated(
//           physics: const BouncingScrollPhysics(),
//           scrollDirection: Axis.horizontal,
//           itemBuilder: (context, index) {
//             if (provider.data == null || provider.data?.isEmpty == true) {
//               return const SizedBox();
//             }

//             return NewsHeaderStocksItem(
//               data: provider.data?[index],
//             );
//           },
//           separatorBuilder: (context, index) {
//             return const SpacerHorizontal(width: 10);
//           },
//           itemCount: provider.data?.length ?? 0),
//     );
//   }
// }

// class NewsHeaderStocksItem extends StatelessWidget {
//   final StockHeaderNewsRes? data;
//   const NewsHeaderStocksItem({super.key, this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: ThemeColors.white,
//           borderRadius: BorderRadius.all(Radius.circular(5.sp))),
//       padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
//       child: Row(
//         children: [
//           Visibility(
//             visible: data?.name != null,
//             child: Text(
//               data?.name ?? "",
//               style:
//                   stylePTSansBold(color: ThemeColors.background, fontSize: 13),
//             ),
//           ),
//           const SpacerHorizontal(width: 5),
//           Visibility(
//             visible: data?.price != null,
//             child: Text(
//               "${data?.price ?? ""}",
//               style: stylePTSansRegular(
//                   color: ThemeColors.background, fontSize: 13),
//             ),
//           ),
//           const SpacerHorizontal(width: 5),
//           Visibility(
//             visible: data?.changesPercentage != null,
//             child: Text(
//               " ${data?.changesPercentage ?? ""}% ${data?.arrow ?? ""}",
//               style: stylePTSansBold(
//                   color: data?.arrowClass == "green"
//                       ? ThemeColors.accent
//                       : data?.arrowClass == "red"
//                           ? ThemeColors.sos
//                           : ThemeColors.white,
//                   fontSize: 13),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
