// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/alerts_res.dart';
// import 'package:stocks_news_new/providers/alert_provider.dart';
// import 'package:stocks_news_new/screens/alerts/alert_item.dart';
// import 'package:stocks_news_new/widgets/refresh_controll.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class AlertContainer extends StatelessWidget {
//   const AlertContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AlertProvider provider = context.watch<AlertProvider>();

//     return RefreshControl(
//       onRefresh: () async => provider.getAlerts(showProgress: false),
//       canLoadMore: provider.canLoadMore,
//       onLoadMore: () async => provider.getAlerts(loadMore: true),
//       child: ListView.separated(
//         itemCount: provider.data?.length ?? 0,
//         padding: EdgeInsets.only(top: 5, bottom: 16),
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           AlertData data = provider.data![index];
//           return AlertsItem(
//             data: data,
//             index: index,
//           );
//           // return CommonStockItem(
//           //   change: "${data.changes}",
//           //   changesPercentage: data.changesPercentage,
//           //   image: data.image,
//           //   name: data.name,
//           //   price: data.price,
//           //   symbol: data.symbol,
//           // );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return const SpacerVertical(height: 12);
//           // return const SizedBox();
//           // return const Divider(
//           //   color: ThemeColors.greyBorder,
//           //   height: 16,
//           // );
//         },
//       ),
//     );
//   }
// }
