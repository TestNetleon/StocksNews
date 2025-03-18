// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/blogs_res.dart';
// import 'package:stocks_news_new/providers/blog_provider_new.dart';
// import 'package:stocks_news_new/screens/blogNew/blogsNew/item.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';

// import '../../../../utils/colors.dart';
// import '../../../../widgets/refresh_controll.dart';

// class BlogTypeData extends StatelessWidget {
//   final String id;

//   const BlogTypeData({required this.id, super.key});

//   @override
//   Widget build(BuildContext context) {
//     BlogProviderNew provider = context.watch<BlogProviderNew>();
//     BlogTabHolder? blogsHolder = provider.blogData[id];

//     return BaseUiContainer(
//       error: blogsHolder?.error,
//       hasData: blogsHolder?.data != null &&
//           (blogsHolder?.data?.data.isNotEmpty ?? false),
//       isLoading: blogsHolder?.loading ?? true,
//       errorDispCommon: true,
//       showPreparingText: true,
//       onRefresh: () => provider.onRefresh(),
//       child: RefreshControl(
//         onRefresh: () async => await provider.onRefresh(),
//         canLoadMore: (blogsHolder?.currentPage ?? 1) <=
//             (blogsHolder?.data?.lastPage ?? 1),
//         onLoadMore: () async => provider.onLoadMore(),
//         child: ListView.separated(
//           itemCount: blogsHolder?.data?.data.length ?? 0,
//           padding: EdgeInsets.only(bottom: 12.sp, top: 12.sp),
//           itemBuilder: (context, index) {
//             BlogItemRes? blogData = blogsHolder?.data?.data[index];

//             return BlogItemNew(
//               showCategory: blogData?.authors?.isEmpty == true,
//               blogItem: blogData,
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider(color: ThemeColors.greyBorder, height: 20);
//           },
//         ),
//       ),
//     );
//   }
// }
