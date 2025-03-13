// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../modals/news_datail_res.dart';
// import '../../providers/blog_provider.dart';
// import '../../utils/constants.dart';
// import '../../utils/theme.dart';
// import '../../widgets/spacer_vertical.dart';
// import '../tabs/news/newsDetail/mentioned_by.dart';

// class BlogDetailMentionBy extends StatelessWidget {
//   const BlogDetailMentionBy({super.key});

//   @override
//   Widget build(BuildContext context) {
//     BlogProvider provider = context.watch<BlogProvider>();
//     if (provider.blogsDetail?.tickers?.isEmpty == true ||
//         provider.blogsDetail?.tickers == null) {
//       return const SizedBox();
//     }
//     return Padding(
//       padding: const EdgeInsets.only(top: Dimen.itemSpacing),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Mentioned in Story",
//             style: styleBaseBold(),
//           ),
//           const SpacerVertical(height: 8),
//           SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(
//                 provider.blogsDetail?.tickers?.length ?? 0,
//                     (index) {
//                       NewsTicker? tickers = provider.blogsDetail?.tickers?[index];
//                   return MentionedByItem(
//                     tickers: tickers,
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
