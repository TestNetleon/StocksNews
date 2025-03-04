// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class AISwotDetail extends StatelessWidget {
//   const AISwotDetail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
//     List<String>? strengths = provider.completeData?.swotAnalysis?.strengths;
//     List<String>? weaknesses = provider.completeData?.swotAnalysis?.weaknesses;
//     List<String>? opportunity =
//         provider.completeData?.swotAnalysis?.opportunity;
//     List<String>? threats = provider.completeData?.swotAnalysis?.threats;

//     return BaseContainer(
//       appBar: AppBarHome(
//         isPopBack: true,
//         title: 'SWOT Analysis Detail',
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               childCount: 1,
//               (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(Dimen.padding),
//                   child: Column(
//                     children: [
//                       Visibility(
//                         visible: strengths != null && strengths.isNotEmpty,
//                         child: AISwotDetailItem(
//                           title: 'Strength',
//                           list: strengths,
//                           color: ThemeColors.accent,
//                         ),
//                       ),
//                       Visibility(
//                         visible: weaknesses != null && weaknesses.isNotEmpty,
//                         child: AISwotDetailItem(
//                           title: 'Weakness',
//                           list: weaknesses,
//                           color: Colors.orange,
//                         ),
//                       ),
//                       Visibility(
//                         visible: opportunity != null && opportunity.isNotEmpty,
//                         child: AISwotDetailItem(
//                           title: 'Opportunity',
//                           list: opportunity,
//                           color: ThemeColors.accent,
//                         ),
//                       ),
//                       Visibility(
//                         visible: threats != null && threats.isNotEmpty,
//                         child: AISwotDetailItem(
//                           title: 'Threat',
//                           list: threats,
//                           color: ThemeColors.sos,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AISwotDetailItem extends StatelessWidget {
//   final String title;
//   final List<String>? list;
//   final Color? color;
//   const AISwotDetailItem(
//       {super.key, required this.title, this.list, this.color});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(6),
//       child: Container(
//         decoration: BoxDecoration(
//           color: ThemeColors.background,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         margin: EdgeInsets.only(bottom: 20),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(color: color),
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               child: Text(
//                 title,
//                 style: styleGeorgiaBold(fontSize: 20),
//               ),
//             ),
//             ListView.separated(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(
//                         '${list?[index]}',
//                         style: styleGeorgiaRegular(color: ThemeColors.greyText),
//                       ),
//                     ),
//                     Divider(
//                       color: ThemeColors.greyBorder,
//                       height: 25,
//                     )
//                   ],
//                 );
//               },
//               separatorBuilder: (context, index) {
//                 return SpacerVertical(height: 0);
//               },
//               itemCount: list?.length ?? 0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
