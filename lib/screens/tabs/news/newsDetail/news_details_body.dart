import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/news_detail.provider.dart';
import 'package:stocks_news_new/providers/scroll_controller.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogDetail/widgets/item.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:url_launcher/url_launcher.dart';
//
import '../../../blogs/index.dart';
import '../headerStocks/index.dart';
import 'news_details_list.dart';

class NewsDetailsBody extends StatefulWidget {
  final String? slug;
  const NewsDetailsBody({super.key, this.slug});

  @override
  State<NewsDetailsBody> createState() => _NewsDetailsBodyState();
}

class _NewsDetailsBodyState extends State<NewsDetailsBody> {
  // ScrollController? _scrollController;
  // bool _isVisible = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<ScrollControllerProvider>().isVisible = true;
      context
          .read<NewsDetailProvider>()
          .getNewsDetailData(showProgress: true, slug: widget.slug);
    });
  }

  // @override
  // void dispose() {
  //   _scrollController?.removeListener(_scrollListener);
  //   _scrollController?.dispose();
  //   super.dispose();
  // }

  // void _scrollListener() {
  //   if (_scrollController?.position.userScrollDirection ==
  //       ScrollDirection.reverse) {
  //     // User is scrolling up
  //     if (_isVisible) {
  //       setState(() {
  //         _isVisible = false;
  //       });
  //     }
  //   } else {
  //     // User is scrolling down
  //     if (!_isVisible) {
  //       setState(() {
  //         _isVisible = true;
  //       });
  //     }
  //   }

  //   log("$_isVisible");
  // }

// Function to create Text widgets from array data
  // List<Widget> _buildTextWidgets(List<DetailListType>? data,
  //     {required BlogsType type}) {
  //   if (data == null || data.isEmpty) return [];

  //   List<Widget> widgets = [];

  //   // Iterate over the data list using forEach
  //   for (var detail in data) {
  //     widgets.add(
  //       InkWell(
  //         onTap: () {
  //           Navigator.pushNamed(context, NewsAuthorIndex.path, arguments: {
  //             "data": detail,
  //             "type": type,
  //           });
  //         },
  //         child: Text(
  //           "${detail.name}",
  //           style: stylePTSansRegular(color: ThemeColors.accent, fontSize: 13),
  //         ),
  //       ),
  //     );
  //     // Add comma if it's not the last item
  //     if (detail != data.last) {
  //       widgets.add(Text(
  //         ", ",
  //         style: stylePTSansRegular(color: ThemeColors.accent, fontSize: 13),
  //       ));
  //     }
  //   }

  //   return widgets;
  // }

  @override
  Widget build(BuildContext context) {
    NewsDetailProvider provider = context.watch<NewsDetailProvider>();
    String date = DateFormat("MMMM dd, yyyy")
        .format(provider.data?.postDetail?.publishedDate ?? DateTime.now());

    bool foundSite = provider.data?.postDetail?.site != "" &&
        provider.data?.postDetail?.site != null;

    ScrollControllerProvider controllerProvider =
        context.watch<ScrollControllerProvider>();

    return provider.data != null && !provider.isLoading
        ? RefreshIndicator(
            onRefresh: () async {
              provider.getNewsDetailData(slug: widget.slug, showProgress: true);
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controllerProvider.scrollController,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      return true;
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const ScreenTitle(title: "News Detail"),
                        // Padding(
                        //   padding:
                        //       EdgeInsets.symmetric(vertical: Dimen.itemSpacing.sp),
                        //   child: Divider(
                        //     color: ThemeColors.accent,
                        //     height: 2.sp,
                        //     thickness: 2.sp,
                        //   ),
                        // ),
                        const NewsHeaderStocks(),

                        Text(
                          provider.data?.postDetail?.title ?? "",
                          style: styleGeorgiaBold(fontSize: 25),
                        ),
                        // Divider(
                        //   color: ThemeColors.border,
                        //   height: 10.sp,
                        // ),

                        const SpacerVerticel(height: 5),

                        // Visibility(
                        //   visible: foundSite,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(bottom: 10.sp),
                        //     child: Text(
                        //       "Source - ${provider.data?.postDetail?.site} | $date",
                        //       style: stylePTSansRegular(
                        //           fontSize: 13, color: ThemeColors.greyText),
                        //     ),
                        //   ),
                        // ),

                        // Visibility(
                        //   visible: (provider.data?.postDetail?.authors?.isEmpty ==
                        //               true ||
                        //           provider.data?.postDetail?.categories?.isEmpty ==
                        //               true) &&
                        //       !foundSite,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(bottom: 10.sp),
                        //     child: Text(
                        //       date,
                        //       style: stylePTSansRegular(
                        //           fontSize: 13, color: ThemeColors.greyText),
                        //     ),
                        //   ),
                        // ),
                        // Divider(
                        //   color: ThemeColors.border,
                        //   height: 10.sp,
                        // ),

                        // Visibility(
                        //   visible:
                        //       provider.data?.postDetail?.authors?.isNotEmpty == true,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(bottom: 10.sp),
                        //     child: NewsDetailAuthor(
                        //       type: BlogsType.author,
                        //       title: "Author: ",
                        //       data: provider.data?.postDetail?.authors,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 3.sp),
                        //   child: Wrap(
                        //     runAlignment: WrapAlignment.start,
                        //     alignment: WrapAlignment.center,
                        //     children: [
                        //       Visibility(
                        //         visible: provider.data?.postDetail?.authors != null &&
                        //             provider.data?.postDetail?.authors?.isNotEmpty ==
                        //                 true,
                        //         child: Text(
                        //           "By ",
                        //           style: styleGeorgiaRegular(
                        //               color: ThemeColors.greyText, fontSize: 13),
                        //         ),
                        //       ),
                        //       NewsDetailAuthorAB(
                        //         underLines: false,
                        //         type: BlogsType.author,
                        //         title: "Author: ",
                        //         data: provider.data?.postDetail?.authors,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        provider.data?.postDetail?.authors?.isNotEmpty ==
                                    true ||
                                provider.data?.postDetail?.categories
                                        ?.isNotEmpty ==
                                    true
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 15.sp),
                                child: ListAlignment(
                                  date: date,
                                  list1: provider.data?.postDetail?.authors,
                                  list2: provider.data?.postDetail?.categories,
                                ),
                              )

                            //  Padding(
                            //     padding: EdgeInsets.only(bottom: 15.sp),
                            //     child: Wrap(
                            //       children: [
                            //         Visibility(
                            //           visible: provider.data?.postDetail?.authors
                            //                   ?.isNotEmpty ==
                            //               true,
                            //           child: Text(
                            //             "By ",
                            //             style: stylePTSansRegular(
                            //                 color: ThemeColors.greyText,
                            //                 fontSize: 13),
                            //           ),
                            //         ),
                            //         Visibility(
                            //           visible: provider.data?.postDetail?.authors
                            //                   ?.isNotEmpty ==
                            //               true,
                            //           child: Wrap(
                            //             children: _buildTextWidgets(
                            //                 provider.data?.postDetail?.authors,
                            //                 type: BlogsType.author),
                            //           ),
                            //         ),
                            //         Text(
                            //           provider.data?.postDetail?.authors?.isEmpty ==
                            //                   true
                            //               ? " $date | "
                            //               : provider.data?.postDetail?.categories
                            //                           ?.isEmpty ==
                            //                       true
                            //                   ? " | $date "
                            //                   : " | $date | ",
                            //           style: stylePTSansRegular(
                            //               color: ThemeColors.greyText, fontSize: 13),
                            //         ),
                            //         Visibility(
                            //           visible: provider.data?.postDetail?.categories
                            //                   ?.isNotEmpty ==
                            //               true,
                            //           child: Wrap(
                            //             children: _buildTextWidgets(
                            //                 provider.data?.postDetail?.categories,
                            //                 type: BlogsType.category),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   )

                            : foundSite
                                ? Padding(
                                    padding: EdgeInsets.only(bottom: 10.sp),
                                    child: Text(
                                      "Source - ${provider.data?.postDetail?.site} | $date",
                                      style: stylePTSansRegular(
                                          fontSize: 13,
                                          color: ThemeColors.greyText),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(bottom: 10.sp),
                                    child: Text(
                                      date,
                                      style: stylePTSansRegular(
                                          fontSize: 13,
                                          color: ThemeColors.greyText),
                                    ),
                                  ),

                        // Divider(
                        //   color: ThemeColors.border,
                        //   height: 10.sp,
                        // ),

                        // SizedBox(
                        //   width: double.infinity,
                        //   height: ScreenUtil().screenHeight * 0.3,
                        //   child: ThemeImageView(
                        //     url: provider.data?.postDetail?.image ?? "",
                        //   ),
                        // ),

                        CachedNetworkImagesWidget(
                          provider.data?.postDetail?.image ?? "",
                          height: ScreenUtil().screenHeight * 0.27,
                          width: double.infinity,
                          // fit: BoxFit.contain,
                        ),

                        // Visibility(
                        //   visible:
                        //       provider.data?.postDetail?.categories?.isNotEmpty ==
                        //           true,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(top: Dimen.itemSpacing.sp),
                        //     child: NewsDetailAuthor(
                        //       type: BlogsType.category,
                        //       title: "Category: ",
                        //       data: provider.data?.postDetail?.categories,
                        //     ),
                        //   ),
                        // ),
                        SpacerVerticel(height: Dimen.itemSpacing.sp),
                        // Text(
                        //   provider.data?.postDetail?.text ?? "",
                        //   style: stylePTSansRegular(),
                        // ),
                        HtmlWidget(
                          customStylesBuilder: (element) {
                            if (element.localName == 'a') {
                              return {
                                'color': '#1bb449',
                                'text-decoration': 'none'
                              };
                            }
                            return null;
                          },
                          onTapUrl: (url) async {
                            bool a = await launchUrl(Uri.parse(url));
                            log("clicked ur---$url, return value $a");

                            return a;
                          },
                          provider.data?.postDetail?.text ?? "",

                          // customWidgetBuilder: (element) {
                          //   if (element.localName == 'a') {
                          //     return GestureDetector(
                          //       onTap: () {
                          //         openUrl(element.attributes['href']);
                          //       },
                          //       child: Text(element.text,
                          //           style: styleGeorgiaRegular(
                          //               color: ThemeColors.accent, fontSize: 15)),
                          //     );
                          //   }
                          //   return null;
                          // },
                          textStyle:
                              styleGeorgiaRegular(fontSize: 14, height: 1.5),
                        ),

                        const SpacerVerticel(height: 20),
                        Visibility(
                          visible:
                              provider.data?.postDetail?.tags?.isNotEmpty ==
                                  true,
                          child: NewsDetailAuthor(
                            type: BlogsType.tag,
                            title: "Tags: ",
                            data: provider.data?.postDetail?.tags,
                          ),
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: "To discover the latest insights, ",
                        //         style: stylePTSansRegular(
                        //           fontSize: 13,
                        //         ),
                        //       ),
                        //       TextSpan(
                        //         text: "click here for the full article",
                        //         style: stylePTSansRegular(
                        //           fontSize: 13,
                        //           color: ThemeColors.accent,
                        //         ),
                        //         recognizer: TapGestureRecognizer()
                        //           ..onTap = () {
                        //             openUrl(provider.data?.postDetail?.url);
                        //           },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // ThemeButtonSmall(
                        //   showArrow: false,
                        //   onPressed: () {},
                        //   text: "Read More",
                        // ),
                        const SpacerVerticel(height: 25),
                        const ScreenTitle(title: "More News to Read"),

                        ListView.separated(
                          itemCount: provider.data?.otherPost?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(12.sp),
                          itemBuilder: (context, index) {
                            PostDetail? moreNewsData =
                                provider.data?.otherPost?[index];

                            return NewsDetailList(
                              moreNewsData: moreNewsData,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            // return const SpacerVerticel(height: 16);
                            return Divider(
                              color: ThemeColors.greyBorder,
                              height: 16.sp,
                            );
                          },
                        ),
                      ],
                    ),
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
                        title: provider.data?.postDetail?.title ?? "",
                        url: provider.data?.postDetail?.slug ?? "",
                      );
                    },
                  ),
                ),
                // CommonShare(
                //   visible: controllerProvider.isVisible,
                //   linkShare: provider.data?.postDetail?.slug ?? "",
                //   title: provider.data?.postDetail?.title ?? "",
                // ),
              ],
            ),
          )
        : !provider.isLoading && provider.data == null
            ? Center(
                child: ErrorDisplayWidget(
                  error: provider.error,
                  onRefresh: () => provider.getNewsDetailData(
                      slug: widget.slug, showProgress: true),
                ),
              )
            : const SizedBox();
  }
}

class NewsDetailAuthor extends StatelessWidget {
  final List<DetailListType>? data;
  final String title;
  final BlogsType type;
  const NewsDetailAuthor({
    super.key,
    this.data,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    // List<DetailListType>? authors =
    //     context.watch<NewsDetailProvider>().data?.postDetail?.authors;
    List<Widget> widgets = [];
    if (data == null) {
      return const SizedBox();
    }

    if (data?.isNotEmpty == true) {
      for (int i = 0; i < data!.length; i++) {
        widgets.add(
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, NewsAuthorIndex.path, arguments: {
                "data": data?[i],
                "type": type,
              });
            },
            child: Text(
              "${data?[i].name?.capitalizeWords()}",
              style: stylePTSansRegular(
                color: ThemeColors.accent,
                fontSize: 12,
              ),
            ),
          ),
        );
        if (i != data!.length - 1) {
          widgets.add(
            Text(
              ", ",
              style: stylePTSansRegular(
                color: ThemeColors.white,
                fontSize: 12,
              ),
            ),
          );
        }
      }
    }

    if (type == BlogsType.tag) {
      List<Widget> tagWidgets = [];

      for (int i = 0; i < data!.length; i++) {
        tagWidgets.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.greyBorder,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.sp),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, NewsAuthorIndex.path, arguments: {
                "data": data?[i],
                "type": BlogsType.tag,
              });
            },
            child: Text(
              data![i].name ?? "",
              style: stylePTSansBold(fontSize: 12),
            ),
          ),
        );

        if (i != data!.length - 1) {
          tagWidgets.add(const SpacerHorizontal(width: 10));
        }
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: stylePTSansBold(
              fontSize: 12,
              color: ThemeColors.white,
            ),
          ),
          const SpacerHorizontal(width: 10),
          Flexible(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: tagWidgets,
            ),
          ),
        ],
      );
    }

    return BlogDetailClickItem(
      title: title,
      fromNews: true,
      showTopDivider: false,
      // showBottomDivider: type == BlogsType.author,
      showBottomDivider: false,

      children: widgets,
    );
  }
}

class NewsDetailAuthorAB extends StatelessWidget {
  final List<DetailListType>? data;
  final String title;
  final BlogsType type;
  final double fontSize;
  final bool underLines;
  const NewsDetailAuthorAB({
    super.key,
    this.data,
    required this.title,
    required this.type,
    this.underLines = true,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    // List<DetailListType>? authors =
    //     context.watch<NewsDetailProvider>().data?.postDetail?.authors;
    List<Widget> widgets = [];
    if (data == null) {
      return const SizedBox();
    }

    if (data?.isNotEmpty == true) {
      for (int i = 0; i < data!.length; i++) {
        widgets.add(
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, NewsAuthorIndex.path, arguments: {
                "data": data?[i],
                "type": type,
              });
            },
            child: Text(
              "${data?[i].name?.capitalizeWords()}",
              style: styleGeorgiaRegular(
                  color: ThemeColors.white,
                  fontSize: fontSize,
                  decoration: underLines ? TextDecoration.underline : null),
            ),
          ),
        );
        if (i != data!.length - 1) {
          widgets.add(
            Text(
              ", ",
              style: styleGeorgiaRegular(
                  color: ThemeColors.white, fontSize: fontSize),
            ),
          );
        }
      }
    }

    return BlogDetailClickItem(
      fromNews: true,
      showTopDivider: false,
      showBottomDivider: false,
      children: widgets,
    );
  }
}

class ListAlignment extends StatelessWidget {
  final List<DetailListType>? list1;
  final List<DetailListType>? list2;
  final String? date;
  final bool blog;

  const ListAlignment({
    super.key,
    this.list1,
    this.list2,
    this.date,
    this.blog = false,
  });

  @override
  Widget build(BuildContext context) {
    log("${list1?.isEmpty}, ${list2?.isEmpty}");
    return Wrap(
      children: [
        Visibility(
          visible: list1 != null && list1?.isNotEmpty == true,
          child: Text(
            "By ",
            style:
                styleGeorgiaRegular(color: ThemeColors.greyText, fontSize: 13),
          ),
        ),
        buildList(
            list: list1, isLastList: true, type: BlogsType.author, blog: blog),
        // buildList(list: list2, isLastList: list3.isEmpty),
        Visibility(
          visible: date != null,
          child: Text(
            list1?.isEmpty == true && list2?.isNotEmpty == true
                ? " $date | "
                : list2?.isEmpty == true && list1?.isNotEmpty == true
                    ? " | $date  "
                    : list1?.isEmpty == true && list2?.isEmpty == true
                        ? "$date"
                        : " | $date | ",
            style:
                stylePTSansRegular(color: ThemeColors.greyText, fontSize: 13),
          ),
        ),
        buildList(list: list2, isLastList: true, type: BlogsType.category),
      ],
    );
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
                log("1");
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
              style:
                  stylePTSansRegular(color: ThemeColors.accent, fontSize: 13),
            ),
          ),
        );

        if (!isLastList || i != list.length - 1) {
          widgets.add(
            Text(
              ', ',
              style:
                  stylePTSansRegular(color: ThemeColors.accent, fontSize: 13),
            ),
          );
        }
      }
    }

    return Wrap(
      children: widgets,
    );
  }
}
