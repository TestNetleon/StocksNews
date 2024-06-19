import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/news_detail.provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogDetail/widgets/item.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:url_launcher/url_launcher.dart';
//
import '../../../../widgets/disclaimer_widget.dart';
import '../../../blogs/index.dart';
import 'mentioned_by.dart';
import 'news_details_list.dart';

class NewsDetailsBody extends StatefulWidget {
  final String? slug;
  final String? inAppMsgId;
  final String? notificationId;
  const NewsDetailsBody({
    super.key,
    this.slug,
    this.inAppMsgId,
    this.notificationId,
  });

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
      context.read<NewsDetailProvider>().getNewsDetailData(
            showProgress: false,
            slug: widget.slug,
            inAppMsgId: widget.inAppMsgId,
            notificationId: widget.notificationId,
          );
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

  //   Utils().showLog("$_isVisible");
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
    // String date = DateFormat("MMMM dd, yyyy")
    //     .format(provider.data?.postDetail?.publishedDate ?? DateTime.now());
    String date = provider.data?.postDetail?.postDateString ?? "";

    bool foundSite = provider.data?.postDetail?.site != "" &&
        provider.data?.postDetail?.site != null;

    // ScrollControllerProvider controllerProvider =
    //     context.watch<ScrollControllerProvider>();

    return provider.isLoading
        ? const Loading()
        : provider.data != null && !provider.isLoading
            ? CommonRefreshIndicator(
                onRefresh: () async {
                  provider.getNewsDetailData(
                    slug: widget.slug,
                    showProgress: false,
                  );
                },
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          return true;
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.data?.postDetail?.title ?? "",
                              style: styleGeorgiaBold(fontSize: 25),
                            ),
                            const SpacerVertical(height: 5),
                            CachedNetworkImagesWidget(
                              provider.data?.postDetail?.image ?? "",
                              height: ScreenUtil().screenHeight * 0.27,
                              width: double.infinity,
                              // fit: BoxFit.contain,
                            ),

                            NewsDetailMentionedBy(),

                            const SpacerVertical(height: Dimen.itemSpacing),
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
                                      // list2: provider.data?.postDetail?.categories,
                                    ),
                                  )
                                : foundSite
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 10.sp),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              constraints: const BoxConstraints(
                                                  minHeight: 18),
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              alignment: Alignment.centerLeft,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    color: ThemeColors.accent,
                                                    width: 3,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Source - ",
                                                    style: stylePTSansRegular(
                                                      fontSize: 16,
                                                      color: ThemeColors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${provider.data?.postDetail?.site}",
                                                    style: stylePTSansRegular(
                                                        fontSize: 16,
                                                        color:
                                                            ThemeColors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SpacerVertical(height: 8),
                                            Text(
                                              date,
                                              style: stylePTSansRegular(
                                                fontSize: 13,
                                                color: ThemeColors.greyText,
                                              ),
                                            ),
                                          ],
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

                            SpacerVertical(height: Dimen.itemSpacing.sp),
                            HtmlWidget(
                              // customStylesBuilder: (element) {
                              //   if (element.localName == 'a') {
                              //     return {
                              //       'color': '#1bb449',
                              //       'text-decoration': 'none'
                              //     };
                              //   }
                              //   return null;
                              // },
                              onTapUrl: (url) async {
                                bool a = await launchUrl(Uri.parse(url));
                                Utils().showLog(
                                    "clicked ur---$url, return value $a");

                                return a;
                              },
                              provider.data?.postDetail?.text ?? "",
                              textStyle: styleGeorgiaRegular(
                                  fontSize: 18, height: 1.5),
                            ),
                            // const SpacerVertical(height: 20),
                            Visibility(
                              visible: (provider.data?.postDetail?.categories
                                          ?.length ??
                                      0) >
                                  0,
                              child: Container(
                                margin: EdgeInsets.only(top: 20.sp),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      "Posted under - ",
                                      style: stylePTSansRegular(
                                          fontSize: 16,
                                          color: ThemeColors.greyText),
                                    ),
                                    const ListAlignment().buildList(
                                      list:
                                          provider.data?.postDetail?.categories,
                                      isLastList: true,
                                      type: BlogsType.category,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Visibility(
                              visible:
                                  provider.data?.postDetail?.tags?.isNotEmpty ==
                                      true,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: NewsDetailAuthor(
                                  type: BlogsType.tag,
                                  title: "Tags: ",
                                  data: provider.data?.postDetail?.tags,
                                ),
                              ),
                            ),

                            Visibility(
                              visible: provider.data?.postDetail?.authors
                                          ?.isNotEmpty ==
                                      true &&
                                  provider.data?.postDetail?.authors != null,
                              child: ListView.separated(
                                itemCount: provider
                                        .data?.postDetail?.authors?.length ??
                                    0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  DetailListType? data = provider
                                      .data?.postDetail?.authors?[index];
                                  if (data?.show == false) {
                                    return const SizedBox();
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ThemeColors.greyBorder
                                            .withOpacity(0.2)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: data?.image != null &&
                                              data?.image != '',
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0.sp),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              padding: EdgeInsets.all(5.sp),
                                              child: CachedNetworkImagesWidget(
                                                data?.image,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SpacerHorizontal(width: 10),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                visible: data?.name != null &&
                                                    data?.name != '',
                                                child: Text(
                                                  "${data?.name}",
                                                  style: stylePTSansBold(
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    data?.designation != null &&
                                                        data?.designation != '',
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4),
                                                  child: Text(
                                                    "${data?.designation}",
                                                    style: stylePTSansBold(
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                color: ThemeColors.greyBorder,
                                              ),
                                              Visibility(
                                                visible: data?.text != null &&
                                                    data?.text != '',
                                                child: HtmlWidget(
                                                  '${data?.text}',
                                                  // textStyle: const TextStyle(
                                                  //   fontFamily: Fonts.ptSans,
                                                  // ),
                                                  textStyle: stylePTSansRegular(
                                                      color:
                                                          ThemeColors.greyText),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SpacerVertical(height: 16);
                                },
                              ),
                            ),

                            const SpacerVertical(height: 25),

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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                // return const SpacerVertical(height: 16);
                                return Divider(
                                  color: ThemeColors.greyBorder,
                                  height: 16.sp,
                                );
                              },
                            ),
                            if (provider.extra?.disclaimer != null && foundSite)
                              DisclaimerWidget(
                                  data: provider.extra?.disclaimer ?? "")
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
                          slug: widget.slug, showProgress: false),
                    ),
                  )
                : provider.isLoading
                    ? const Loading()
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
              "${data?[i].name}",
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
              "${data?[i].name}",
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
    Utils().showLog("${list1?.isEmpty}, ${list2?.isEmpty}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 18),
          padding: const EdgeInsets.only(left: 8),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: ThemeColors.accent,
                width: 3,
              ),
            ),
          ),
          child: Wrap(
            children: [
              Visibility(
                visible: list1 != null && list1?.isNotEmpty == true,
                child: Text(
                  "By ",
                  style: styleGeorgiaRegular(
                      color: ThemeColors.white, fontSize: 16),
                ),
              ),
              buildList(
                  list: list1,
                  isLastList: true,
                  type: BlogsType.author,
                  blog: blog),
              // buildList(list: list2, isLastList: list3.isEmpty),
              // buildList(list: list2, isLastList: true, type: BlogsType.category),
            ],
          ),
        ),
        const SpacerVertical(height: 8),
        Visibility(
          visible: date != null,
          child: Text(
            list1?.isEmpty == true && list2?.isNotEmpty == true
                ? "$date"
                : list2?.isEmpty == true && list1?.isNotEmpty == true
                    ? "$date"
                    : list1?.isEmpty == true && list2?.isEmpty == true
                        ? "$date"
                        : "$date",
            style: stylePTSansRegular(
              color: ThemeColors.greyText,
              fontSize: 13,
            ),
          ),
        ),
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
}
