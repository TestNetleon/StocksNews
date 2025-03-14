// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/blogs_res.dart';
// import 'package:stocks_news_new/providers/blog_provider.dart';
// import 'package:stocks_news_new/screens/blogs/widgets/item.dart';
// import 'package:stocks_news_new/screens/blogs/widgets/header.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/refresh_controll.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../blogNew/blogsNew/item.dart';

// class BlogContainer extends StatelessWidget {
//   const BlogContainer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     BlogProvider provider = context.watch<BlogProvider>();

//     return BaseContainer(
//       appBar: const AppBarHome(
//         isPopBack: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(
//           Dimen.padding,
//           // Dimen.padding.sp,
//           0,
//           Dimen.padding,
//           0,
//         ),
//         child: BaseUiContainer(
//           isLoading: provider.isLoading,
//           hasData: provider.blogData != null &&
//               provider.blogData?.isNotEmpty == true,
//           showPreparingText: true,
//           error: provider.error,
//           errorDispCommon: true,
//           onRefresh: () => provider.getData(showProgress: false),
//           child: RefreshControl(
//             onRefresh: () async => provider.getData(showProgress: false),
//             canLoadMore: provider.canLoadMore,
//             onLoadMore: () async => provider.getData(loadMore: true),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   BlogsHeader(data: provider.blogRes),
//                   ListView.separated(
//                     padding: EdgeInsets.symmetric(vertical: 10.sp),
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: provider.blogData?.length ?? 0,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       BlogItemRes? blogItem = provider.blogData?[index];
//                       if (blogItem == null) {
//                         return const SizedBox();
//                       }
//                       return BlogItem(
//                         blogItem: blogItem,
//                       );
//                     },
//                     separatorBuilder: (BuildContext context, int index) {
//                       // return const SpacerVertical(height: 16);
//                       return const Divider(
//                         height: 16,
//                         color: ThemeColors.greyBorder,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AuthorContainer extends StatelessWidget {
//   final BlogsType type;
//   final String id;

//   const AuthorContainer({super.key, required this.type, this.id = ""});

//   @override
//   Widget build(BuildContext context) {
//     BlogProvider provider = context.watch<BlogProvider>();

//     return BaseContainer(
//       appBar: const AppBarHome(isPopBack: true),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
//         child: BaseUiContainer(
//           isLoading: provider.isLoading,
//           hasData: provider.authorsData != null &&
//               provider.authorsData?.isNotEmpty == true,
//           error: provider.error,
//           errorDispCommon: true,
//           onRefresh: () =>
//               provider.getData(showProgress: true, type: type, id: id),
//           child: RefreshControl(
//             onRefresh: () async =>
//                 provider.getData(showProgress: true, type: type, id: id),
//             canLoadMore: provider.canLoadMore,
//             onLoadMore: () async =>
//                 provider.getData(loadMore: true, type: type, id: id),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   BlogsHeader(data: provider.authorRes),
//                   ListView.separated(
//                     padding: EdgeInsets.symmetric(vertical: 10.sp),
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: provider.authorsData?.length ?? 0,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       BlogItemRes? blogItem = provider.authorsData?[index];
//                       if (blogItem == null) {
//                         return const SizedBox();
//                       }
//                       // return BlogItem(
//                       //   blogItem: blogItem,
//                       // );
//                       return BlogItemNew(
//                         showCategory: blogItem.authors?.isEmpty == true,
//                         blogItem: blogItem,
//                       );
//                     },
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const SpacerVertical(height: 16);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
