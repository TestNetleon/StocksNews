import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

//
class BlogItemHome extends StatelessWidget {
  const BlogItemHome({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    BannerBlogRes? blogItem = provider.homeTrendingRes?.bannerBlog;

    if (blogItem == null) {
      return SizedBox();
    }

    return InkWell(
      onTap: () async {
        closeKeyboard();
        await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => BlogDetail(slug: blogItem.slug)),
        );
        provider.getHomeTrendingData();
      },
      child: Card(
        color: ThemeColors.tabBack,
        elevation: 4,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 63, 63, 63),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    size: 22,
                    color: ThemeColors.golden,
                  ),
                  const SpacerHorizontal(width: 8),
                  Text(
                    blogItem.headingText ?? "Alert of the day",
                    style: styleGeorgiaBold(
                      fontSize: 22,
                      color: ThemeColors.golden,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogItem.name ?? "",
                          style: styleGeorgiaBold(fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SpacerVertical(height: 5),
                        Visibility(
                          visible: true,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 0.sp),
                            child: Wrap(
                              children: [
                                Text(
                                  " ${blogItem.publishedDateString} ",
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
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      width: 100,
                      // height: 100,
                      child: ThemeImageView(url: blogItem.image ?? ""),
                      // Image.network(news!.image, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            // Navigator.push(
            //     navigatorKey.currentContext!, NewsAuthorIndex.path,
            //     arguments: {
            //       "data": detail,
            //       "type": type,
            //     });
            Navigator.pushReplacement(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (_) => Blog(
                  id: detail.id!,
                  type: BlogsType.author,
                ),
              ),
            );
          },
          child: Text(
            "${detail.name}",
            style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
          ),
        ),
      );
      // Add comma if it's not the last item
      if (detail != data.last) {
        widgets.add(
          Text(
            ", ",
            style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
          ),
        );
      }
    }

    return widgets;
  }
}
