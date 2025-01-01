import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/ai_provider.dart';
import 'package:stocks_news_new/screens/auth/base/base_auth_bottom.dart';
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
import '../../../../widgets/custom/update_error.dart';
import '../../../../widgets/disclaimer_widget.dart';
import '../../../../widgets/theme_button_small.dart';
import '../../../AdManager/manager.dart';
import '../../../auth/base/base_auth_email_bottom.dart';
import '../../../t&cAndPolicy/tc_policy.dart';
import '../newsDetail/news_details_body.dart';
import '../newsDetail/news_details_list.dart';

class NewsDetailsBodyAI extends StatefulWidget {
  final String? slug;

  const NewsDetailsBodyAI({
    super.key,
    this.slug,
  });

  @override
  State<NewsDetailsBodyAI> createState() => _NewsDetailsBodyAIState();
}

class _NewsDetailsBodyAIState extends State<NewsDetailsBodyAI> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  void _getInitialData() async {
    AIProvider newsProvider = context.read<AIProvider>();
    await newsProvider.getNewsDetailData(
      showProgress: false,
      slug: widget.slug,
    );
    // AmplitudeService.logUserInteractionEvent(
    //   type: 'News Detail',
    //   selfText: newsProvider.detail?.postDetail?.title ?? "",
    // );
  }

  @override
  Widget build(BuildContext context) {
    AIProvider provider = context.watch<AIProvider>();
    String date = provider.detail?.postDetail?.postDateString ?? "";
    bool foundSite = provider.detail?.postDetail?.source != "" &&
        provider.detail?.postDetail?.source != null;

    return provider.detailLoading
        ? const Loading()
        : provider.detail != null && !provider.detailLoading
            ? CommonRefreshIndicator(
                onRefresh: () async {
                  provider.getNewsDetailData(
                    slug: widget.slug,
                    showProgress: false,
                  );
                },
                child: Column(
                  children: [
                    Expanded(
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
                                    provider.detail?.postDetail?.title ?? "",
                                    style: styleGeorgiaBold(fontSize: 25),
                                  ),
                                  const SpacerVertical(height: 5),
                                  CachedNetworkImagesWidget(
                                    provider.detail?.postDetail?.image ?? "",
                                    height: ScreenUtil().screenHeight * 0.27,
                                    width: double.infinity,
                                    // fit: BoxFit.contain,
                                  ),
                                  const SpacerVertical(
                                      height: Dimen.itemSpacing),
                                  provider.detail?.postDetail?.authors
                                                  ?.isNotEmpty ==
                                              true ||
                                          provider.detail?.postDetail
                                                  ?.categories?.isNotEmpty ==
                                              true
                                      ? Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 15.sp),
                                          child: ListAlignment(
                                            date: date,
                                            list1: provider
                                                .detail?.postDetail?.authors,
                                            // list2: provider.data?.postDetail?.categories,
                                          ),
                                        )
                                      : foundSite
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 10.sp),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
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
                                                          "${provider.detail?.postDetail?.source}",
                                                          style:
                                                              stylePTSansRegular(
                                                            fontSize: 16,
                                                          ),
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
                                                      color:
                                                          ThemeColors.greyText,
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
                                  SpacerVertical(height: Dimen.itemSpacing.sp),
                                  HtmlWidget(
                                    customWidgetBuilder: (element) {
                                      if (element.innerHtml
                                          .contains('DISPLAY_AD_1')) {
                                        return Visibility(
                                          visible: provider.extra?.adManagers
                                                  ?.data?.newsPlace1 !=
                                              null,
                                          child: AdManagerIndex(
                                              screen: AdScreen.aiNews,
                                              places: AdPlaces.place1,
                                              margin: EdgeInsets.zero,
                                              data: provider.extraD?.adManagers
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
                                              screen: AdScreen.aiNews,
                                              places: AdPlaces.place2,
                                              margin: EdgeInsets.zero,
                                              data: provider.extraD?.adManagers
                                                  ?.data?.newsPlace2),
                                        );
                                      }
                                      return null;
                                    },
                                    onTapUrl: (url) async {
                                      if (url.startsWith(
                                          "https://app.stocks.news/page/")) {
                                        String slug = extractLastPathComponent(
                                            Uri.parse(url));
                                        Navigator.pushReplacement(
                                          context,
                                          createRoute(
                                            TCandPolicy(
                                              policyType: PolicyType.disclaimer,
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
                                    provider.detail?.postDetail?.summary ?? "",
                                    textStyle: styleGeorgiaRegular(
                                        fontSize: 18, height: 1.5),
                                  ),
                                  const SpacerVertical(),
                                  GestureDetector(
                                    onTap: () {
                                      openUrl(provider
                                          .detail?.postDetail?.permalink);
                                    },
                                    child: Text(
                                      "Read full news..",
                                      style: stylePTSansRegular(
                                          color: ThemeColors.accent),
                                    ),
                                  ),
                                  Visibility(
                                    visible: (provider.detail?.postDetail
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
                                                .detail?.postDetail?.categories,
                                            isLastList: true,
                                            type: BlogsType.category,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: provider.detail?.postDetail?.tags
                                            ?.isNotEmpty ==
                                        true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: NewsDetailAuthor(
                                        type: BlogsType.tag,
                                        title: "Tags: ",
                                        data: provider.detail?.postDetail?.tags,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: provider.detail?.postDetail
                                                ?.authors?.isNotEmpty ==
                                            true &&
                                        provider.detail?.postDetail?.authors !=
                                            null,
                                    child: ListView.separated(
                                      itemCount: provider.detail?.postDetail
                                              ?.authors?.length ??
                                          0,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        DetailListType? data = provider.detail
                                            ?.postDetail?.authors?[index];
                                        if (data?.show == false) {
                                          return const SizedBox();
                                        }
                                        return Container(
                                          margin: const EdgeInsets.only(top: 8),
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
                                                visible: data?.image != null &&
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
                                              const SpacerHorizontal(width: 10),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Visibility(
                                                      visible:
                                                          data?.name != null &&
                                                              data?.name != '',
                                                      child: Text(
                                                        "${data?.name}",
                                                        style: stylePTSansBold(
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
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      color: ThemeColors
                                                          .greyBorder,
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          data?.text != null &&
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
                                        return const SpacerVertical(height: 16);
                                      },
                                    ),
                                  ),
                                  const SpacerVertical(height: 25),
                                  AdManagerIndex(
                                    screen: AdScreen.aiNews,
                                    places: AdPlaces.place3,
                                    margin: EdgeInsets.zero,
                                    data: provider
                                        .extraD?.adManagers?.data?.newsPlace3,
                                  ),
                                  const ScreenTitle(
                                    title: "More News to Read",
                                    dividerPadding: EdgeInsets.zero,
                                  ),
                                  ListView.separated(
                                    itemCount:
                                        provider.detail?.otherPost?.length ?? 0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(12.sp),
                                    itemBuilder: (context, index) {
                                      PostDetail? moreNewsData =
                                          provider.detail?.otherPost?[index];
                                      return NewsDetailList(
                                        fromAI:
                                            moreNewsData?.newsType == "ainews",
                                        moreNewsData: moreNewsData,
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      // return const SpacerVertical(height: 16);
                                      return Divider(
                                        color: ThemeColors.greyBorder,
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
                          ),
                          Positioned(
                            bottom: 6,
                            right: 10,
                            child: ThemeButtonSmall(
                              onPressed: () {
                                commonShare(
                                  title:
                                      provider.detail?.postDetail?.title ?? "",
                                  url: provider.detail?.postDetail?.slug ?? "",
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
                    BaseAuth(),
                    BaseAuthEmail()
                  ],
                ),
              )
            : !provider.detailLoading && provider.detail == null
                ? provider.errorDetail?.contains('You are using') == true
                    ? UpdateError(
                        error: provider.errorDetail,
                      )
                    : Center(
                        child: ErrorDisplayWidget(
                          error: provider.errorDetail,
                          onRefresh: () => provider.getNewsDetailData(
                              slug: widget.slug, showProgress: false),
                        ),
                      )
                : provider.detailLoading
                    ? const Loading()
                    : const SizedBox();
  }
}
