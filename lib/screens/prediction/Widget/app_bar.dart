// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../modals/stock_details_res.dart';
// import '../../../providers/stock_detail_new.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/theme.dart';
// import '../../../widgets/cache_network_image.dart';
// import '../../../widgets/spacer_horizontal.dart';

// class PredictionAppBar extends StatelessWidget {
//   const PredictionAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     KeyStats? keyStats = provider.tabRes?.keyStats;
//     CompanyInfo? companyInfo = provider.tabRes?.companyInfo;

//     return Row(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             // color: Colors.white,
//             color: Colors.transparent,
//             // border: Border.all(color: ThemeColors.white),
//             border: Border.all(color: ThemeColors.accent),
//           ),
//           padding: const EdgeInsets.all(8),
//           width: 48,
//           height: 48,
//           child: CachedNetworkImagesWidget(
//             companyInfo?.image ?? "",
//             fit: BoxFit.contain,
//           ),
//         ),
//         SpacerHorizontal(width: 8),
//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "${keyStats?.name}",
//                     style: stylePTSansBold(fontSize: 18),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: ThemeColors.greyBorder,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
//                     margin: EdgeInsets.only(left: 5),
//                     child: Text(
//                       "${keyStats?.exchange}",
//                       style: stylePTSansRegular(fontSize: 11),
//                     ),
//                   ),
//                 ],
//               ),
//               Visibility(
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.watch_later,
//                       size: 15,
//                       color: ThemeColors.greyText,
//                     ),
//                     const SpacerHorizontal(width: 5),
//                     Text(
//                       keyStats?.marketStatus ?? "",
//                       style: stylePTSansRegular(
//                         color: ThemeColors.greyText,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
