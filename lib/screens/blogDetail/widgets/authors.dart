// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/news_datail_res.dart';
// import 'package:stocks_news_new/providers/blog_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/screens/blogs/index.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// import 'item.dart';

// class BlogDetailAuthor extends StatelessWidget {
//   const BlogDetailAuthor({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<DetailListType>? authors =
//         context.watch<BlogProvider>().blogsDetail?.authors;
//     if (authors == null) {
//       return const SizedBox();
//     }

//     return BlogDetailClickItem(
//       showBottomDivider: false,
//       title: "Authors: ",
//       children: authors.map((item) {
//         return InkWell(
//           onTap: () {
//             Navigator.of(context).popUntil((route) {
//               // return route.settings.name == IndexBlog.path;
//               return route.settings.name == Blog.path;
//             });
//             Navigator.push(
//               navigatorKey.currentContext!,
//               MaterialPageRoute(
//                 builder: (_) => Blog(
//                   id: item.id!,
//                   type: BlogsType.author,
//                 ),
//               ),
//             );
//           },
//           child: Text(
//             item.name ?? "",
//             style: styleBaseRegular(
//               color: ThemeColors.accent,
//               fontSize: 12,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
