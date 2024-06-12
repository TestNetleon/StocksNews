import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../tabs/news/newsDetail/news_details_body.dart';

//
class BlogDetailContainer extends StatelessWidget {
  final String slug;

  const BlogDetailContainer({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = context.watch<BlogProvider>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
      child: BaseUiContainer(
        error: provider.error,
        hasData: provider.blogsDetail != null && !provider.isLoadingDetail,
        isLoading: provider.isLoadingDetail,
        showPreparingText: true,
        onRefresh: () => provider.getBlogDetailData(slug: slug),
        child: CommonRefreshIndicator(
          onRefresh: () => provider.getBlogDetailData(slug: slug),
          child: Stack(
            children: [
              SingleChildScrollView(
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
                    // Padding(
                    //   padding: EdgeInsets.only(bottom: 15.sp),
                    //   child: ListAlignment(
                    //     // date: DateFormat("MMMM dd, yyyy").format(
                    //     //     provider.blogsDetail?.publishedDate ??
                    //     //         DateTime.now()),
                    //     date: provider.blogsDetail?.postDateString ?? "",
                    //     list1: provider.blogsDetail?.authors,
                    //     list2: const [],
                    //     blog: true,
                    //   ),
                    // ),
                    const SpacerVertical(height: 10),
                    SizedBox(
                      width: double.infinity,
                      // height: isPhone
                      //     ? ScreenUtil().screenHeight * 0.3
                      //     : ScreenUtil().screenHeight * 0.4,
                      child: ThemeImageView(
                        url: provider.blogsDetail?.image ?? "",
                        // fit: BoxFit.contain,
                      ),
                    ),
                    const SpacerVertical(height: 10),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.sp),
                      child: ListAlignment(
                        date: provider.blogsDetail?.postDateString ?? "",
                        list1: provider.blogsDetail?.authors,
                        list2: const [],
                        blog: true,
                      ),
                    ),
                    SpacerVertical(height: Dimen.itemSpacing.sp),
                    // const BlogDetailAuthor(),
                    // const SpacerVertical(height: 5),
                    // const BlogDetailCategory(),
                    // const SpacerVertical(height: 5),
                    // const BlogDetailTags(),
                    HtmlWidget(
                      onTapImage: (data) {
                        Utils().showLog(data.sources.first.url);
                      },
                      // customWidgetBuilder: (element) {
                      //   if (element.localName == 'img') {
                      //     final src = element.attributes['src'];

                      //     return ZoomableImage(url: src ?? "");
                      //   }

                      //   return null;
                      // },
                      onLoadingBuilder: (context, element, loadingProgress) {
                        return const ProgressDialog();
                      },
                      provider.blogsDetail?.description ?? "",
                      textStyle: styleGeorgiaRegular(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SpacerVertical(height: 10),
                  ],
                ),
              ),
              Positioned(
                bottom: 6.sp,
                right: 0,
                child: FloatingActionButton(
                  backgroundColor: ThemeColors.accent,
                  child: const Icon(Icons.share),
                  onPressed: () {
                    commonShare(
                      title: provider.blogsDetail?.name ?? "",
                      url: provider.blogsDetail?.slug ?? "",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildList({
  List<DetailListType>? list,
  required bool isLastList,
  bool clickable = true,
  required BlogsType type,
  bool blog = false,
}) {
  List<Widget> widgets = [];

  if (list != null && list.isNotEmpty) {
    for (int i = 0; i < list.length; i++) {
      widgets.add(
        InkWell(
          onTap: () {
            if (blog) {
              Utils().showLog("1");
              Navigator.pushReplacementNamed(
                  navigatorKey.currentContext!, Blog.path,
                  arguments: {
                    "type": BlogsType.author,
                    "id": list[i].id,
                  });
            } else {
              Navigator.pushNamed(
                  navigatorKey.currentContext!, NewsAuthorIndex.path,
                  arguments: {
                    "data": list[i],
                    "type": type,
                  });
            }

            // Navigator.pushNamed(
            //     navigatorKey.currentContext!, NewsAuthorIndex.path,
            //     arguments: {
            //       "data": list[i],
            //       "type": type,
            //     });
          },
          child: Text(
            list[i].name ?? "",
            style: stylePTSansRegular(
              color: ThemeColors.accent,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );

      if (!isLastList || i != list.length - 1) {
        widgets.add(
          Text(
            ', ',
            style: stylePTSansRegular(
              color: ThemeColors.accent,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
    }
  }

  return Wrap(children: widgets);
}


// String? extractImageUrl(String html) {
//   final document = parse(html);
//   final imgElement = document.querySelector('img');
//   final imgSrc = imgElement?.attributes['src'];
//   log("Image->$imgSrc");
//   return imgSrc;
// }

// class ZoomableImage extends StatefulWidget {
//   final String url;

//   const ZoomableImage({super.key, required this.url});

//   @override
//   State<ZoomableImage> createState() => _ZoomableImageState();
// }

// class _ZoomableImageState extends State<ZoomableImage> {
//   double _scale = 1.0;
//   Offset _startOffset = Offset.zero;
//   Offset _currentOffset = Offset.zero;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onScaleStart: (details) {
//         _startOffset = details.focalPoint;
//       },
//       onScaleUpdate: (details) {
//         setState(() {
//           _scale = details.scale;
//           _currentOffset = details.focalPoint - _startOffset + _currentOffset;
//           _startOffset = details.focalPoint;
//         });
//       },
//       onScaleEnd: (details) {
//         setState(() {
//           _scale = 1.0;
//           _currentOffset = Offset.zero;
//         });
//       },
//       child: Transform(
//         transform: Matrix4.identity()
//           ..translate(_currentOffset.dx, _currentOffset.dy)
//           ..scale(_scale),
//         child: Image.network(widget.url),
//       ),
//     );
//   }
// }
