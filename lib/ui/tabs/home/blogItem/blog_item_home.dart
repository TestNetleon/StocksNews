import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
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
        bool isDark = value.isDarkMode;
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: Pad.pad10,
            horizontal: Pad.pad16,
          ),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  closeKeyboard();
                  // Navigator.pushNamed(
                  //   context,
                  //   BlogsDetailIndex.path,
                  //   arguments: {'slug': blogItem.slug},
                  // );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BlogsDetailIndex(slug: blogItem.slug ?? '')));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(Pad.pad16),
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.neutral5),
                    borderRadius: BorderRadius.circular(8),
                    color: isDark ? null : ThemeColors.white,
                    gradient: isDark
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ThemeColors.gradientGreen,
                              ThemeColors.blackShade,
                            ],
                            stops: [0.0025, 0.5518],
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.boxShadow,
                        blurRadius: 60,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blogItem.title ?? "",
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
              ),
              Positioned(
                top: 0,
                left: Pad.pad16,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? null : ThemeColors.white,
                    gradient: isDark
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ThemeColors.blackShade,
                              ThemeColors.gradientGreen,
                            ],
                            stops: [0.0025, 0.5518],
                          )
                        : null,
                    border: Border.all(color: ThemeColors.neutral5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.notifications_active_outlined,
                    size: 22,
                    color: isDark ? Colors.yellow : ThemeColors.primary120,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
