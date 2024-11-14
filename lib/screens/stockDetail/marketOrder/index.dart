// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/custom_tab_container.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../tabs/home/widgets/app_bar_home.dart';
// import 'item.dart';

// class SdMarketOrderIndex extends StatelessWidget {
//   const SdMarketOrderIndex({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const BaseContainer(
//       appBar: AppBarHome(
//         isPopBack: true,
//         showTrailing: true,
//         canSearch: true,
//       ),
//       body: Padding(
//         padding:
//             EdgeInsets.fromLTRB(Dimen.padding, Dimen.padding, Dimen.padding, 0),
//         child: Column(
//           children: [
//             ScreenTitle(
//               title: "Your Orders",
//               dividerPadding: EdgeInsets.only(bottom: 15),
//             ),
//             // Expanded(
//             //   child: ListView.separated(
//             //     itemBuilder: (context, index) {
//             //       return const SdMarketOrderItem();
//             //     },
//             //     separatorBuilder: (context, index) {
//             //       return const SpacerVertical();
//             //     },
//             //     itemCount: 20,
//             //   ),
//             // ),
//             Expanded(
//               child: CommonTabContainer(
//                 scrollable: false,
//                 tabPaddingNew: false,
//                 tabs: ["Buy", "Sell"],
//                 widgets: [
//                   SdMarketOrderBuy(),
//                   SdMarketOrderSell(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SdMarketOrderBuy extends StatelessWidget {
//   const SdMarketOrderBuy({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       itemBuilder: (context, index) {
//         return const SdMarketOrderItem();
//       },
//       separatorBuilder: (context, index) {
//         return const SpacerVertical();
//       },
//       itemCount: 20,
//     );
//   }
// }

// class SdMarketOrderSell extends StatelessWidget {
//   const SdMarketOrderSell({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       itemBuilder: (context, index) {
//         return const SdMarketOrderItem();
//       },
//       separatorBuilder: (context, index) {
//         return const SpacerVertical();
//       },
//       itemCount: 20,
//     );
//   }
// }
