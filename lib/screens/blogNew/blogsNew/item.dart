import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../routes/my_app.dart';

class BlogItemNew extends StatelessWidget {
  final BlogItemRes? blogItem;
  final bool showCategory;
  const BlogItemNew({
    this.blogItem,
    this.showCategory = true,
    super.key,
  });

  List<Widget> _buildTextWidgets(List<DetailListType>? data,
      {required BlogsType type}) {
    if (data == null || data.isEmpty) return [];

    List<Widget> widgets = [];

    for (var detail in data) {
      widgets.add(
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       navigatorKey.currentContext!,
        //       MaterialPageRoute(
        //         builder: (_) => Blog(
        //           type: BlogsType.author,
        //           id: detail.id!,
        //         ),
        //       ),
        //     );
        //   },
        //   child: Text(
        //     "${detail.name}",
        //     style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        //   ),
        // ),
        Text(
          "${detail.name}",
          style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        ),
      );
      if (detail != data.last) {
        widgets.add(Text(
          ", ",
          style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => BlogDetail(slug: blogItem?.slug)),
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
                  style: styleGeorgiaBold(fontSize: 16),
                ),
                const SpacerVertical(height: 5),
                Visibility(
                  visible: blogItem?.authors?.isNotEmpty == true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
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
                              children: _buildTextWidgets(blogItem?.authors,
                                  type: BlogsType.author),
                            ),
                          ],
                        ),
                        const SpacerVertical(height: 2),
                        Text(
                          "${blogItem?.postDateString} ",
                          style: stylePTSansRegular(
                              color: ThemeColors.greyText, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showCategory,
                  child: Text(
                    " ${blogItem?.postDateString}",
                    style: stylePTSansRegular(
                        fontSize: 13, color: ThemeColors.greyText),
                  ),
                ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          CachedNetworkImagesWidget(
            blogItem?.image ?? "",
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
