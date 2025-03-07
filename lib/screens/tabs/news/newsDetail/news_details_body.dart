import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/database/database_helper.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/news_detail.provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/AdManager/manager.dart';
import 'package:stocks_news_new/screens/blogDetail/widgets/item.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/article_feedback.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/widget/news_lock.dart';
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
import 'package:widget_zoom/widget_zoom.dart';
import '../../../../providers/home_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../widgets/custom/update_error.dart';
import '../../../../widgets/disclaimer_widget.dart';
import '../../../../widgets/theme_button_small.dart';
import '../../../auth/base/base_auth.dart';
import '../../../auth/base/base_auth_email_bottom.dart';
import '../../../auth/refer/refer_code.dart';
import '../../../blogs/index.dart';
import '../../../t&cAndPolicy/tc_policy.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  void _getInitialData() async {
    NewsDetailProvider newsProvider = context.read<NewsDetailProvider>();
    UserProvider userProvider = context.read<UserProvider>();
    newsProvider.clearLimitCall();
    await newsProvider.getNewsDetailData(
      showProgress: false,
      slug: widget.slug,
      inAppMsgId: widget.inAppMsgId,
      notificationId: widget.notificationId,
    );
    // AmplitudeService.logUserInteractionEvent(
    //   type: 'News Detail',
    //   selfText: newsProvider.data?.postDetail?.title ?? "",
    // );

    if (newsProvider.data?.postDetail?.readingStatus == false ||
        newsProvider.extra?.isOldApp == true) {
      return;
    }

    if (userProvider.user == null) {
      DatabaseHelper helper = DatabaseHelper();
      bool visible = await helper.fetchLoginDialogData(NewsDetails.path);
      if (visible) {
        Timer(const Duration(seconds: 3), () {
          if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
            helper.update(NewsDetails.path);
            // loginSheet();
            loginFirstSheet();
          }
        });
      }
    }
    //BECAUSE OF BOTTOM
    // else if (userProvider.user != null &&
    //     (userProvider.user?.phone == null || userProvider.user?.phone == "")) {
    //   DatabaseHelper helper = DatabaseHelper();
    //   bool visible = await helper.fetchLoginDialogData(NewsDetails.path);
    //   if (visible) {
    //     Timer(const Duration(seconds: 3), () {
    //       if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
    //         helper.update(NewsDetails.path);
    //         verifyIdentitySheet();
    //       }
    //     });
    //   }
    // }
  }

  void _onSubmit(value) async {
    UserProvider userProvider = context.read<UserProvider>();
    NewsDetailProvider provider = context.read<NewsDetailProvider>();

    if (userProvider.user == null) {
      // await loginSheet();
      await loginFirstSheet();

      if (context.read<UserProvider>().user != null) {
        await provider.getNewsDetailData(
          showProgress: false,
          slug: widget.slug,
          inAppMsgId: widget.inAppMsgId,
          notificationId: widget.notificationId,
        );
      }
      return;
    }

    provider.requestFeedbackSubmit(
      showProgress: true,
      feedbackType: "news",
      id: provider.data!.postDetail!.id!,
      type: value,
    );
  }

  void _onLoginClick(context) async {
    // await loginSheet();
    await loginFirstSheet();

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    NewsDetailProvider provider =
        Provider.of<NewsDetailProvider>(context, listen: false);

    if (userProvider.user != null) {
      provider.getNewsDetailData(slug: widget.slug);
    }
  }

  Future _onReferClick(BuildContext context) async {
    UserProvider userProvider = context.read<UserProvider>();

    // if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
    if (userProvider.user?.affiliateStatus != 1) {
      await referLogin();
    } else {
      if (userProvider.user != null) {
        await Share.share(
          "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
        );
      }
    }
  }

  void _onViewNewsClick(context) async {
    NewsDetailProvider provider =
        Provider.of<NewsDetailProvider>(context, listen: false);
    await provider.getNewsDetailData(slug: widget.slug, pointsDeducted: true);
  }

  // Future _membership() async {
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   if (provider.user?.phone == null || provider.user?.phone == '') {
  //     await membershipLogin();
  //   }
  //   if (provider.user?.phone != null && provider.user?.phone != '') {
  //     // await RevenueCatService.initializeSubscription();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => const NewMembership(),
  //       ),
  //     );
  //   }
  // }

  // Future _membership() async {
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

  //   await askToSubscribe(
  //     onPressed: () async {
  //       Navigator.pop(navigatorKey.currentContext!);

  //       if (provider.user?.phone == null || provider.user?.phone == '') {
  //         await membershipLogin();
  //       }
  //       if (provider.user?.phone != null && provider.user?.phone != '') {
  //         await RevenueCatService.initializeSubscription();
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    NewsDetailProvider provider = context.watch<NewsDetailProvider>();
    // HomeProvider homeProvider = context.watch<HomeProvider>();

    // String date = DateFormat("MMMM dd, yyyy")
    //     .format(provider.data?.postDetail?.publishedDate ?? DateTime.now());
    String date = provider.data?.postDetail?.postDateString ?? "";

    bool foundSite = provider.data?.postDetail?.site != "" &&
        provider.data?.postDetail?.site != null;
    // double height = (ScreenUtil().screenHeight -
    //         ScreenUtil().bottomBarHeight -
    //         ScreenUtil().statusBarHeight) /
    //     2.2;
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
                    Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              SingleChildScrollView(
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
                                    NewsDetailMentionedBy(
                                      data: provider.data?.postDetail?.tickers,
                                    ),
                                    const SpacerVertical(
                                        height: Dimen.itemSpacing),
                                    provider.data?.postDetail?.authors
                                                    ?.isNotEmpty ==
                                                true ||
                                            provider.data?.postDetail
                                                    ?.categories?.isNotEmpty ==
                                                true
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15.sp),
                                            child: ListAlignment(
                                              date: date,
                                              list1: provider
                                                  .data?.postDetail?.authors,
                                              // list2: provider.data?.postDetail?.categories,
                                            ),
                                          )
                                        : foundSite
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.sp),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                              minHeight: 18),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            color: ThemeColors
                                                                .accent,
                                                            width: 3,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Source - ",
                                                            style:
                                                                stylePTSansRegular(
                                                              fontSize: 16,
                                                              color: ThemeColors
                                                                  .white,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${provider.data?.postDetail?.site}",
                                                            style: stylePTSansRegular(
                                                                fontSize: 16,
                                                                color:
                                                                    ThemeColors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SpacerVertical(
                                                        height: 8),
                                                    Text(
                                                      date,
                                                      style: stylePTSansRegular(
                                                        fontSize: 13,
                                                        color: ThemeColors
                                                            .greyText,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.sp),
                                                child: Text(
                                                  date,
                                                  style: stylePTSansRegular(
                                                      fontSize: 13,
                                                      color:
                                                          ThemeColors.greyText),
                                                ),
                                              ),
                                    SpacerVertical(
                                        height: Dimen.itemSpacing.sp),
                                    HtmlWidget(
                                      customWidgetBuilder: (element) {
                                        if (element.innerHtml
                                            .contains('DISPLAY_AD_1')) {
                                          return Visibility(
                                            visible: provider.extra?.adManagers
                                                    ?.data?.newsPlace1 !=
                                                null,
                                            child: AdManagerIndex(
                                                screen: AdScreen.newsDetail,
                                                places: AdPlaces.place1,
                                                margin: EdgeInsets.zero,
                                                data: provider.extra?.adManagers
                                                    ?.data?.newsPlace1),
                                          );
                                        }

                                        if (element.innerHtml
                                            .contains('DISPLAY_AD_2')) {
                                          return Visibility(
                                            visible: provider.extra?.adManagers
                                                    ?.data?.newsPlace2 !=
                                                null,
                                            child: AdManagerIndex(
                                                screen: AdScreen.newsDetail,
                                                places: AdPlaces.place2,
                                                margin: EdgeInsets.zero,
                                                data: provider.extra?.adManagers
                                                    ?.data?.newsPlace2),
                                          );
                                        }
                                        if (element.localName == 'img' &&
                                            !(element.innerHtml
                                                    .contains('DISPLAY_AD_1') ||
                                                element.innerHtml.contains(
                                                    'DISPLAY_AD_2'))) {
                                          final src = element.attributes['src'];
                                          return WidgetZoom(
                                            heroAnimationTag: '$src',
                                            zoomWidget: Image.network(
                                              src ?? '',
                                            ),
                                          );
                                        }
                                        return null;
                                      },
                                      onTapUrl: (url) async {
                                        if (url.startsWith(
                                            "https://app.stocks.news/page/")) {
                                          String slug =
                                              extractLastPathComponent(
                                                  Uri.parse(url));
                                          Navigator.pushReplacement(
                                            context,
                                            createRoute(
                                              TCandPolicy(
                                                policyType:
                                                    PolicyType.disclaimer,
                                                slug: slug,
                                              ),
                                            ),
                                          );
                                          return true;
                                        }
                                        bool a = false;
                                        if (Platform.isAndroid) {
                                          a = await launchUrl(Uri.parse(url));
                                          Utils().showLog(
                                              "clicked ur---$url, return value $a");
                                        } else {
                                          a = true;
                                          Uri uri = Uri.parse(url);
                                          iOSNavigate(uri);
                                          Utils().showLog("iOS navigation");
                                        }
                                        return a;
                                      },
                                      provider.data?.postDetail?.text ?? "",
                                      textStyle: styleGeorgiaRegular(
                                          fontSize: 18, height: 1.5),
                                    ),

                                    // const SpacerVertical(height: 20),
                                    if (provider.data?.feedbackMsg != null)
                                      ArticleFeedback(
                                        feebackType:
                                            provider.extra?.feebackType,
                                        title: provider.data?.feedbackMsg,
                                        submitMessage:
                                            provider.data?.feedbackExistMsg,
                                        onSubmit: _onSubmit,
                                      ),
                                    Visibility(
                                      visible: (provider.data?.postDetail
                                                  ?.categories?.length ??
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
                                              list: provider
                                                  .data?.postDetail?.categories,
                                              isLastList: true,
                                              type: BlogsType.category,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: provider.data?.postDetail?.tags
                                              ?.isNotEmpty ==
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
                                      visible: provider.data?.postDetail
                                                  ?.authors?.isNotEmpty ==
                                              true &&
                                          provider.data?.postDetail?.authors !=
                                              null,
                                      child: ListView.separated(
                                        itemCount: provider.data?.postDetail
                                                ?.authors?.length ??
                                            0,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          DetailListType? data = provider.data
                                              ?.postDetail?.authors?[index];
                                          if (data?.show == false) {
                                            return const SizedBox();
                                          }
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: ThemeColors.greyBorder
                                                    .withOpacity(0.2)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      data?.image != null &&
                                                          data?.image != '',
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.sp),
                                                    child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      padding:
                                                          EdgeInsets.all(5.sp),
                                                      child:
                                                          CachedNetworkImagesWidget(
                                                        data?.image,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SpacerHorizontal(
                                                    width: 10),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Visibility(
                                                        visible: data?.name !=
                                                                null &&
                                                            data?.name != '',
                                                        child: Text(
                                                          "${data?.name}",
                                                          style:
                                                              stylePTSansBold(
                                                                  fontSize: 18),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            data?.designation !=
                                                                    null &&
                                                                data?.designation !=
                                                                    '',
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 4),
                                                          child: Text(
                                                            "${data?.designation}",
                                                            style:
                                                                stylePTSansBold(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        color: ThemeColors
                                                            .greyBorder,
                                                      ),
                                                      Visibility(
                                                        visible: data?.text !=
                                                                null &&
                                                            data?.text != '',
                                                        child: HtmlWidget(
                                                          data?.text ?? "",
                                                          customWidgetBuilder:
                                                              (element) =>
                                                                  ReadMoreText(
                                                            textAlign:
                                                                TextAlign.start,
                                                            element.text,
                                                            trimLines: 2,
                                                            colorClickableText:
                                                                ThemeColors
                                                                    .accent,
                                                            trimMode:
                                                                TrimMode.Line,
                                                            trimCollapsedText:
                                                                ' Read more',
                                                            trimExpandedText:
                                                                ' Read less',
                                                            moreStyle:
                                                                stylePTSansRegular(
                                                              color: ThemeColors
                                                                  .accent,
                                                              height: 1.3,
                                                            ),
                                                            style:
                                                                stylePTSansRegular(
                                                              height: 1.3,
                                                              color: ThemeColors
                                                                  .white,
                                                            ),
                                                          ),
                                                        ),

                                                        //  HtmlWidget(
                                                        //   '${data?.text}',
                                                        //   // textStyle: const TextStyle(
                                                        //   //   fontFamily: Fonts.ptSans,
                                                        //   // ),
                                                        //   textStyle: stylePTSansRegular(
                                                        //       color:
                                                        //           ThemeColors.greyText),
                                                        // ),
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
                                          return const SpacerVertical(
                                              height: 16);
                                        },
                                      ),
                                    ),
                                    const SpacerVertical(height: 25),
                                    Visibility(
                                      visible: provider.extra?.adManagers?.data
                                              ?.newsPlace3 !=
                                          null,
                                      child: AdManagerIndex(
                                          places: AdPlaces.place3,
                                          screen: AdScreen.newsDetail,
                                          margin: EdgeInsets.zero,
                                          data: provider.extra?.adManagers?.data
                                              ?.newsPlace3),
                                    ),
                                    const ScreenTitle(
                                        title: "More News to Read"),
                                    ListView.separated(
                                      itemCount:
                                          provider.data?.otherPost?.length ?? 0,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(12.sp),
                                      itemBuilder: (context, index) {
                                        PostDetail? moreNewsData =
                                            provider.data?.otherPost?[index];
                                        return NewsDetailList(
                                          moreNewsData: moreNewsData,
                                          fromAI: moreNewsData?.newsType ==
                                              "ainews",
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        // return const SpacerVertical(height: 16);
                                        return Divider(
                                          color: const Color.fromARGB(
                                              255, 98, 98, 98),
                                          height: 16,
                                        );
                                      },
                                    ),
                                    if (provider.extra?.disclaimer != null &&
                                        foundSite)
                                      DisclaimerWidget(
                                        data: provider.extra?.disclaimer ?? "",
                                      )
                                  ],
                                ),
                              ),
                              Positioned(
                                // bottom: homeProvider.extra?.updateYourPhone == null
                                //     ? 6
                                //     : ScreenUtil().screenWidth * 0.68,
                                bottom: 6,
                                right: 10,
                                child: ThemeButtonSmall(
                                  onPressed: () {
                                    commonShare(
                                      title: provider.data?.postDetail?.title ??
                                          "",
                                      url:
                                          provider.data?.postDetail?.slug ?? "",
                                    );
                                  },
                                  text: "Share Story",
                                  fontBold: true,
                                  icon: Icons.share,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // BaseAuth(),
                        BaseAuthEmail(),
                      ],
                    ),
                    // Positioned(
                    //   // bottom: homeProvider.extra?.updateYourPhone == null
                    //   //     ? 6
                    //   //     : ScreenUtil().screenWidth * 0.68,
                    //   bottom: 6,
                    //   right: 10,
                    //   child: ThemeButtonSmall(
                    //     onPressed: () {
                    //       commonShare(
                    //         title: provider.data?.postDetail?.title ?? "",
                    //         url: provider.data?.postDetail?.slug ?? "",
                    //       );
                    //     },
                    //     text: "Share Story",
                    //     fontBold: true,
                    //     icon: Icons.share,
                    //   ),
                    // ),
                    NewsDetailsLock(slug: widget.slug),
                    // if (provider.data?.postDetail?.premiumReaderOnly == true)
                    //   CommonLock(isLocked: true),
                  ],
                ),
              )
            : !provider.isLoading && provider.data == null
                ? provider.extra?.isOldApp == true
                    ? UpdateError(error: provider.error)
                    : Center(
                        child: ErrorDisplayWidget(
                            error: provider.error,
                            onRefresh: () {
                              provider.clearLimitCall();
                              provider.getNewsDetailData(
                                  slug: widget.slug, showProgress: false);
                            }),
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
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => NewsAuthorIndex(
                    type: type,
                    data: data?[i],
                  ),
                ),
              );
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
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => NewsAuthorIndex(
                    type: BlogsType.tag,
                    data: data?[i],
                  ),
                ),
              );
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
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => NewsAuthorIndex(
                    type: type,
                    data: data?[i],
                  ),
                ),
              );
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
                Navigator.pushReplacement(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(
                    builder: (_) => Blog(
                      id: list[i].id!,
                      type: BlogsType.author,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(
                    builder: (_) => NewsAuthorIndex(
                      type: type,
                      data: list[i],
                    ),
                  ),
                );
              }
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

iOSNavigate(event) {
  // DeeplinkEnum type = containsSpecificPath(event);
  // String slug = extractLastPathComponent(event);

  // handleNavigation(
  //   uri: event,
  //   slug: slug,
  //   type: type,
  //   setPopHome: false,
  // );
  handleDeepLinkNavigation(uri: event, conditionalCheck: true);
}
