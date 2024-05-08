import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';
import '../../../modals/news_datail_res.dart';

//
class BlogItem extends StatelessWidget {
  final BlogItemRes? blogItem;
  const BlogItem({
    this.blogItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          BlogDetail.path,
          arguments: blogItem?.id,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blogItem?.name ?? "",
                  style: styleGeorgiaRegular(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                // Text(
                //   DateFormat("MMMM dd, yyyy")
                //       .format(blogItem?.publishedDate ?? DateTime.now()),
                //   style: stylePTSansRegular(
                //     // color: ThemeColors.greyText,
                //     fontSize: 10,
                //   ),
                // ),
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.sp),
                    child: Wrap(
                      children: [
                        Visibility(
                          visible: blogItem?.authors?.isNotEmpty == true,
                          child: Text(
                            "By ",
                            style: stylePTSansRegular(
                                color: ThemeColors.greyText, fontSize: 13),
                          ),
                        ),
                        Wrap(
                          children: _buildTextWidgets(
                              data: blogItem?.authors, type: BlogsType.author),
                        ),
                        Text(
                          blogItem?.authors?.isNotEmpty == true
                              ? " | ${DateFormat("MMMM dd, yyyy").format(blogItem?.publishedDate ?? DateTime.now())} "
                              : "${DateFormat("MMMM dd, yyyy").format(blogItem?.publishedDate ?? DateTime.now())} ",
                          style: stylePTSansRegular(
                            color: ThemeColors.greyText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimen.radius.r.sp),
            child: SizedBox(
              width: ScreenUtil().screenWidth * .22,
              height: ScreenUtil().screenWidth * .22,
              child: ThemeImageView(url: blogItem?.image ?? ""),
              // Image.network(news!.image, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTextWidgets(
      {List<DetailListType>? data, required BlogsType type}) {
    if (data == null || data.isEmpty) return [];

    List<Widget> widgets = [];

    // Iterate over the data list using forEach
    for (var detail in data) {
      widgets.add(
        InkWell(
          onTap: () {
            // Navigator.pushNamed(
            //     navigatorKey.currentContext!, NewsAuthorIndex.path,
            //     arguments: {
            //       "data": detail,
            //       "type": type,
            //     });
            Navigator.pushReplacementNamed(
                navigatorKey.currentContext!, Blog.path,
                arguments: {
                  "type": BlogsType.author,
                  "id": detail.id,
                });
          },
          child: Text(
            "${detail.name}",
            style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
          ),
        ),
      );
      // Add comma if it's not the last item
      if (detail != data.last) {
        widgets.add(Text(
          ", ",
          style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        ));
      }
    }

    return widgets;
  }
}
