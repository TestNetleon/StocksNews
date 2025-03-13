import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/detail.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

//
class BlogHomeIndex extends StatelessWidget {
  const BlogHomeIndex({super.key});

  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();
    BaseNewsRes? blogItem = manager.data?.bannerBlog;

    if (blogItem == null) {
      return SizedBox();
    }

    return Consumer<ThemeManager>(
      builder: (context, value, child) {
        bool darkTheme = value.isDarkMode;

        return InkWell(
          onTap: () async {
            closeKeyboard();
            Navigator.pushNamed(
              context,
              BlogsDetailIndex.path,
              arguments: {'slug': blogItem.slug},
            );
            manager.getHomeData();
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: Pad.pad10),
            decoration: BoxDecoration(
              color: darkTheme ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(28, 239, 239, 239),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: darkTheme
                        ? ThemeColors.neutral80
                        : ThemeColors.neutral5,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
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
                        color: darkTheme
                            ? ThemeColors.white
                            : ThemeColors.splashBG,
                      ),
                      const SpacerHorizontal(width: 8),
                      Text(
                        blogItem.headingText ?? "Alert of the day",
                        // style: styleBaseBold(
                        //   fontSize: 18,
                        //   color: darkTheme
                        //       ? ThemeColors.white
                        //       : ThemeColors.splashBG,
                        // ),
                        style: Theme.of(context).textTheme.headlineLarge,
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
                              blogItem.title ?? "",
                              // style: styleBaseBold(
                              //   fontSize: 16,
                              //   color: darkTheme
                              //       ? ThemeColors.white
                              //       : ThemeColors.black,
                              // ),
                              style: Theme.of(context).textTheme.displayLarge,

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
                                      " ${blogItem.publishedDate} ",
                                      style: styleBaseRegular(
                                        color: ThemeColors.neutral20,
                                        fontSize: 12,
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
                      CachedNetworkImage(
                        imageUrl: blogItem.image ?? "",
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
