import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
//
import 'aiNews/detail.dart';

class NewsItem extends StatelessWidget {
  final News? news;
  final bool showCategory;
  final bool gotoDetail;
  final bool fromMoreNews;
  final bool fromAI;
  const NewsItem({
    this.news,
    this.fromAI = false,
    this.showCategory = true,
    this.gotoDetail = true,
    super.key,
    this.fromMoreNews = false,
  });

  void _gotoDetail(BuildContext context) {
    closeKeyboard();

    if (fromAI && !fromMoreNews) {
      Utils().showLog("from AI true From more news false");

      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => NewsDetailsAI(slug: news?.slug)),
      );

      return;
    }

    if (fromAI && fromMoreNews) {
      Utils().showLog("from AI true From more news true");

      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => NewsDetailsAI(slug: news?.slug)),
      );

      return;
    }

    if (fromMoreNews) {
      Utils().showLog("From more news true");

      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => NewsDetails(slug: news?.slug),
        ),
      );
      return;
    }

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => NewsDetails(slug: news?.slug)),
    );
  }

  List<Widget> _buildTextWidgets(List<DetailListType>? data,
      {required BlogsType type}) {
    if (data == null || data.isEmpty) return [];

    List<Widget> widgets = [];

    // Iterate over the data list using forEach
    for (var detail in data) {
      widgets.add(
        Text(
          "${detail.name}",
          style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        ),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       navigatorKey.currentContext!,
        //       MaterialPageRoute(
        //         builder: (_) => NewsAuthorIndex(
        //           type: type,
        //           data: detail,
        //         ),
        //       ),
        //     );
        //   },
        //   child: Text(
        //     "${detail.name}",
        //     style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        //   ),
        // ),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => gotoDetail && news?.slug != null
          ? _gotoDetail(context)
          : openUrl(news?.url),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news?.title ?? "",
                  style: styleGeorgiaBold(fontSize: 16),
                  // maxLines: 2,
                  // overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                //  const SpacerVertical(height: 10),
                // Visibility(
                //   visible: news?.authors != null &&
                //       news?.authors?.isNotEmpty == true,
                //   child: Padding(
                //     padding: EdgeInsets.only(bottom: 3.sp),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Visibility(
                //           visible: news?.authors != null &&
                //               news?.authors?.isNotEmpty == true,
                //           child: Text(
                //             "By ",
                //             style: styleGeorgiaRegular(
                //                 color: ThemeColors.greyText, fontSize: 11),
                //           ),
                //         ),
                //         Flexible(
                //           child: NewsDetailAuthorA(
                //             underLines: false,
                //             fontSize: 11,
                //             type: BlogsType.author,
                //             title: "Author: ",
                //             data: news?.authors,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: news?.authors?.isNotEmpty == true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          children: [
                            Visibility(
                              visible: news?.authors?.isNotEmpty == true,
                              child: Text(
                                "By ",
                                style: stylePTSansRegular(
                                    color: ThemeColors.greyText, fontSize: 13),
                              ),
                            ),
                            Wrap(
                              children: _buildTextWidgets(news?.authors,
                                  type: BlogsType.author),
                            ),
                          ],
                        ),
                        const SpacerVertical(height: 2),
                        Text(
                          "${news?.postDateString} ",
                          style: stylePTSansRegular(
                              color: ThemeColors.greyText, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showCategory,
                  child: Column(
                    children: [
                      if (news?.site == "" || news?.site == null)
                        Text(
                          "${news?.postDate}",
                          style: stylePTSansRegular(
                            fontSize: 13,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      if (!(news?.site == "" || news?.site == null))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Source - ${news?.site}",
                              style: stylePTSansRegular(
                                  fontSize: 13, color: ThemeColors.greyText),
                            ),
                            const SpacerVertical(height: 2),
                            Text(
                              "${news?.postDateString}",
                              style: stylePTSansRegular(
                                  fontSize: 13, color: ThemeColors.greyText),
                            ),
                          ],
                        ),
                    ],
                  ),
                  //  Container(
                  //   margin: EdgeInsets.only(bottom: 5.sp),
                  //   decoration: BoxDecoration(
                  //     border:
                  //         Border.all(color: ThemeColors.accent, width: 1.sp),
                  //     borderRadius: BorderRadius.circular(4.sp),
                  //   ),
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 8.sp,
                  //     vertical: 4.sp,
                  //   ),
                  //   child: Text(
                  //     news?.site ?? "",
                  //     style: stylePTSansRegular(fontSize: 10),
                  //   ),
                  // ),
                ),
                // Visibility(
                //   visible: (news?.authors != null &&
                //               news?.authors?.isNotEmpty == true) &&
                //           news?.site == "" ||
                //       news?.site == null,
                //   child: Visibility(
                //     visible: !(news?.site == "" && news?.site == null),
                //     child: Text(
                //       "${news?.postDate}",
                //       style: stylePTSansRegular(
                //           fontSize: 11, color: ThemeColors.greyText),
                //     ),
                //   ),
                // ),

                // Text(
                //   news?.postDate ?? "",
                //   style: styleGeorgiaRegular(
                //     // color: ThemeColors.greyText,
                //     fontSize: 10,
                //   ),
                // ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          // ClipRRect(
          //   // borderRadius: BorderRadius.circular(Dimen.radius.r.sp),
          //   child: SizedBox(
          //     width: ScreenUtil().screenWidth * .22,
          //     height: ScreenUtil().screenWidth * .22,
          //     child: ThemeImageView(url: news?.image ?? ""),
          //     // Image.network(news!.image, fit: BoxFit.cover),
          //   ),
          // ),
          CachedNetworkImagesWidget(
            news?.image ?? "",
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class NewsItemSeparated extends StatelessWidget {
  final News? news;
  final bool showCategory;
  final bool gotoDetail;
  final bool fromMoreNews;
  final bool fromAI;
  const NewsItemSeparated({
    this.news,
    this.showCategory = true,
    this.gotoDetail = true,
    super.key,
    this.fromMoreNews = false,
    this.fromAI = false,
  });

  void _gotoDetail(BuildContext context) {
    if (fromAI) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => NewsDetailsAI(slug: news!.slug),
        ),
      );

      return;
    }

    if (fromMoreNews) {
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => NewsDetails(slug: news?.slug),
        ),
      );

      return;
    }

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => NewsDetails(slug: news!.slug),
      ),
    );
  }

  List<Widget> _buildTextWidgets(List<DetailListType>? data,
      {required BlogsType type}) {
    if (data == null || data.isEmpty) return [];

    List<Widget> widgets = [];

    // Iterate over the data list using forEach
    for (var detail in data) {
      widgets.add(
        Text(
          "${detail.name}",
          style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        ),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       navigatorKey.currentContext!,
        //       MaterialPageRoute(
        //         builder: (_) => NewsAuthorIndex(
        //           type: type,
        //           data: detail,
        //         ),
        //       ),
        //     );
        //   },
        //   child: Text(
        //     "${detail.name}",
        //     style: stylePTSansRegular(color: ThemeColors.white, fontSize: 13),
        //   ),
        // ),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => gotoDetail && news?.slug != null
          ? _gotoDetail(context)
          : openUrl(news?.url),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 6 / 3,
            child: CachedNetworkImagesWidget(
              news?.image,
              width: double.infinity,
            ),
          ),
          // Stack(
          //   alignment: Alignment.bottomCenter,
          //   children: [
          //     // ThemeImageView(url: news?.image ?? ""),
          //     // CachedNetworkImagesWidget(
          //     //   news?.image,
          //       // height: 200,
          //     //   width: double.infinity,
          //     // ),
          //     // Container(
          //     //   height: 30,
          //     //   width: double.infinity,
          //     //   decoration: BoxDecoration(
          //     //     gradient: RadialGradient(
          //     //       // begin: Alignment.topCenter,
          //     //       // end: Alignment.bottomCenter,
          //     //       colors: [
          //     //         ThemeColors.blackShade.shade600.withOpacity(0.5),
          //     //         ThemeColors.blackShade.shade700.withOpacity(0.5),
          //     //         ThemeColors.blackShade.shade700.withOpacity(0.5),
          //     //       ],
          //     //     ),
          //     //   ),
          //     // ),
          //     // Align(
          //     //   alignment: Alignment.bottomCenter,
          //     //   child: Container(
          //     //     height: 20,
          //     //     width: double.infinity,
          //     //     decoration: const BoxDecoration(
          //     //       gradient: LinearGradient(
          //     //         end: Alignment(0.0, -1),
          //     //         begin: Alignment(0.0, 2),
          //     //         colors: <Color>[
          //     //           ThemeColors.background,
          //     //           Color(0x8A000000),
          //     //         ],
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
          const SpacerVertical(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                news?.title ?? "",
                style: styleGeorgiaBold(fontSize: 24),
                // maxLines: 2,
                // overflow: TextOverflow.ellipsis,
              ),
              const SpacerVertical(height: 5),
              //  const SpacerVertical(height: 10),
              // Visibility(
              //   visible: news?.authors != null &&
              //       news?.authors?.isNotEmpty == true,
              //   child: Padding(
              //     padding: EdgeInsets.only(bottom: 3.sp),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Visibility(
              //           visible: news?.authors != null &&
              //               news?.authors?.isNotEmpty == true,
              //           child: Text(
              //             "By ",
              //             style: styleGeorgiaRegular(
              //                 color: ThemeColors.greyText, fontSize: 11),
              //           ),
              //         ),
              //         Flexible(
              //           child: NewsDetailAuthorA(
              //             underLines: false,
              //             fontSize: 11,
              //             type: BlogsType.author,
              //             title: "Author: ",
              //             data: news?.authors,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Visibility(
                visible: news?.authors?.isNotEmpty == true,
                child: Wrap(
                  children: [
                    Visibility(
                      visible: news?.authors?.isNotEmpty == true,
                      child: Text(
                        "By ",
                        style: stylePTSansRegular(
                            color: ThemeColors.greyText, fontSize: 13),
                      ),
                    ),
                    Wrap(
                      children: _buildTextWidgets(news?.authors,
                          type: BlogsType.author),
                    ),
                    Text(
                      " ${news?.postDateString} ",
                      style: stylePTSansRegular(
                          color: ThemeColors.greyText, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showCategory,
                child: Text(
                  news?.site == "" || news?.site == null
                      ? "${news?.postDateString}"
                      : "Source - ${news?.site} | ${news?.postDateString}",
                  style: stylePTSansRegular(
                      fontSize: 13, color: ThemeColors.greyText),
                ),
                //  Container(
                //   margin: EdgeInsets.only(bottom: 5.sp),
                //   decoration: BoxDecoration(
                //     border:
                //         Border.all(color: ThemeColors.accent, width: 1.sp),
                //     borderRadius: BorderRadius.circular(4.sp),
                //   ),
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 8.sp,
                //     vertical: 4.sp,
                //   ),
                //   child: Text(
                //     news?.site ?? "",
                //     style: stylePTSansRegular(fontSize: 10),
                //   ),
                // ),
              ),
              // Visibility(
              //   visible: (news?.authors != null &&
              //               news?.authors?.isNotEmpty == true) &&
              //           news?.site == "" ||
              //       news?.site == null,
              //   child: Visibility(
              //     visible: !(news?.site == "" && news?.site == null),
              //     child: Text(
              //       "${news?.postDate}",
              //       style: stylePTSansRegular(
              //           fontSize: 11, color: ThemeColors.greyText),
              //     ),
              //   ),
              // ),

              // Text(
              //   news?.postDate ?? "",
              //   style: styleGeorgiaRegular(
              //     // color: ThemeColors.greyText,
              //     fontSize: 10,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
