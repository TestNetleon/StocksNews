import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../tabs/news/newsDetail/news_details_body.dart';

//
class BlogDetailContainer extends StatelessWidget {
  final String id;

  const BlogDetailContainer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = context.watch<BlogProvider>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
      child: Column(
        children: [
          // const ScreenTitle(title: "Blog Detail"),
          Expanded(
            child: BaseUiContainer(
              error: provider.error,
              hasData: provider.blogsDetail != null,
              isLoading: provider.isLoading,
              onRefresh: () => provider.getBlogDetailData(blogId: id),
              child: RefreshIndicator(
                onRefresh: () => provider.getBlogDetailData(blogId: id),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SpacerVertical(height: 5),
                      Text(
                        provider.blogsDetail?.name ?? "",
                        style: styleGeorgiaBold(fontSize: 25),
                      ),
                      const SpacerVertical(height: 5),

                      Padding(
                        padding: EdgeInsets.only(bottom: 15.sp),
                        child: ListAlignment(
                          date: DateFormat("MMMM dd, yyyy").format(
                              provider.blogsDetail?.publishedDate ??
                                  DateTime.now()),
                          list1: provider.blogsDetail?.authors,
                          list2: const [],
                          blog: true,
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: ScreenUtil().screenHeight * 0.3,
                        child: ThemeImageView(
                          url: provider.blogsDetail?.image ?? "",
                        ),
                      ),
                      // const SpacerVertical(height: 5),
                      // RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: "Published Date: ",
                      //         style: stylePTSansRegular(
                      //           fontSize: 14,
                      //           color: ThemeColors.white,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: DateFormat("MMMM dd, yyyy").format(
                      //             provider.blogsDetail?.publishedDate ??
                      //                 DateTime.now()),
                      //         style: stylePTSansRegular(
                      //             fontSize: 14, color: ThemeColors.greyText),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SpacerVertical(height: Dimen.itemSpacing.sp),

                      // const BlogDetailAuthor(),
                      // const SpacerVertical(height: 5),
                      // const BlogDetailCategory(),
                      // const SpacerVertical(height: 5),
                      // const BlogDetailTags(),
                      HtmlWidget(
                        provider.blogsDetail?.description ?? "",
                        textStyle:
                            styleGeorgiaRegular(fontSize: 14, height: 1.5),
                      ),
                      const SpacerVertical(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
