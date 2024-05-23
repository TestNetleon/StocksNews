// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/gainers_losers_res.dart';
// import 'package:stocks_news_new/providers/fifty_two_weeks_provider.dart';
// import 'package:stocks_news_new/screens/drawerScreens/fiftyTwoWeeks/item.dart';
// import 'package:stocks_news_new/utils/colors.dart';

// import '../../../utils/constants.dart';
// import '../../../widgets/base_ui_container.dart';
// import '../../../widgets/refresh_controll.dart';

// class FiftyTwoWeeksLowsStocks extends StatefulWidget {
//   const FiftyTwoWeeksLowsStocks({super.key});

//   @override
//   State<FiftyTwoWeeksLowsStocks> createState() =>
//       _FiftyTwoWeeksLowsStocksState();
// }

// class _FiftyTwoWeeksLowsStocksState extends State<FiftyTwoWeeksLowsStocks> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       context
//           .read<FiftyTwoWeeksProvider>()
//           .getData(showProgress: true, type: "low");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     FiftyTwoWeeksProvider provider = context.watch<FiftyTwoWeeksProvider>();
//     List<HighLowPeDataRes>? low = provider.data?.data;

//     return BaseUiContainer(
//       error: provider.error,
//       // hasData: up != null && up.isNotEmpty,
//       hasData: true,
//       isLoading: provider.isLoading,
//       errorDispCommon: true,
//       showPreparingText: true,
//       onRefresh: () => provider.getData(showProgress: true, type: "low"),
//       child: RefreshControl(
//         onRefresh: () => provider.getData(showProgress: true, type: "low"),
//         canLoadMore: provider.canLoadMore,
//         onLoadMore: () =>
//             provider.getData(showProgress: false, type: "low", loadMore: true),
//         child: ListView.separated(
//           padding: EdgeInsets.only(
//             bottom: Dimen.padding.sp,
//             top: Dimen.padding.sp,
//           ),
//           itemBuilder: (context, index) {
//             HighLowPeDataRes? low = provider.data?.data?[index];
//             if (low == null) {
//               return SizedBox();
//             }

//             // if (up == null || up.isEmpty) {
//             //   return const SizedBox();
//             // }
//             // return GainerLoserItem(
//             //   data: up[index],
//             //   index: index,
//             // );
//             return FiftyTwoWeeksItem(
//               data: low,
//               index: index,
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider(
//               color: ThemeColors.greyBorder,
//               height: 20.sp,
//             );
//           },
//           // itemCount: up?.length ?? 0,
//           itemCount: low?.length ?? 0,
//         ),
//       ),
//     );
//   }
// }
