import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/article_feedback.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/cache_network_image.dart';
import '../tabs/news/newsDetail/news_details_body.dart';
import 'blog_mention_by.dart';

//
class BlogDetailContainer extends StatelessWidget {
  final String slug;

  const BlogDetailContainer({super.key, required this.slug});

  void _onSubmitAffiliate(value, context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    BlogProvider provider = Provider.of<BlogProvider>(context, listen: false);
    if (userProvider.user == null) {
      await loginSheet();
      if (userProvider.user != null) {
        await provider.getBlogDetailData(slug: slug);
      }
      return;
    }

    provider.requestFeedbackSubmit(
      showProgress: true,
      feedbackType: "blog",
      id: provider.blogsDetail!.id,
      type: value,
    );
  }

  void _onLoginClick(context) async {
    await loginSheet();

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    BlogProvider provider = Provider.of<BlogProvider>(context, listen: false);

    if (userProvider.user != null) {
      provider.getBlogDetailData(slug: slug);
    }
  }

  void _onViewBlogClick(context) async {
    BlogProvider provider = Provider.of<BlogProvider>(context, listen: false);
    await provider.getBlogDetailData(slug: slug, point_deduction: true);
  }

  @override
  Widget build(BuildContext context) {
    double height = (ScreenUtil().screenHeight -
            ScreenUtil().bottomBarHeight -
            ScreenUtil().statusBarHeight) /
        2.2;

    BlogProvider provider = context.watch<BlogProvider>();
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp,
            Dimen.padding.sp,
            Dimen.padding.sp,
            0,
          ),
          child: BaseUiContainer(
            error: provider.error,
            hasData: provider.blogsDetail != null && !provider.isLoadingDetail,
            isLoading: provider.isLoadingDetail,
            showPreparingText: true,
            onRefresh: () => provider.getBlogDetailData(slug: slug),
            child: CommonRefreshIndicator(
              onRefresh: () => provider.getBlogDetailData(slug: slug),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SpacerVertical(height: 5),
                        Text(
                          provider.blogsDetail?.name ?? "",
                          style: styleGeorgiaBold(fontSize: 25),
                        ),

                        const SpacerVertical(height: 5),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 15.sp),
                        //   child: ListAlignment(
                        //     // date: DateFormat("MMMM dd, yyyy").format(
                        //     //     provider.blogsDetail?.publishedDate ??
                        //     //         DateTime.now()),
                        //     date: provider.blogsDetail?.postDateString ?? "",
                        //     list1: provider.blogsDetail?.authors,
                        //     list2: const [],
                        //     blog: true,
                        //   ),
                        // ),
                        const SpacerVertical(height: 10),
                        // SizedBox(
                        //   width: double.infinity,
                        //   // height: isPhone
                        //   //     ? ScreenUtil().screenHeight * 0.3
                        //   //     : ScreenUtil().screenHeight * 0.4,
                        //   child: ThemeImageView(
                        //     url: provider.blogsDetail?.image ?? "",
                        //     // fit: BoxFit.contain,
                        //   ),
                        // ),

                        CachedNetworkImagesWidget(
                          provider.blogsDetail?.image ?? "",
                          height: ScreenUtil().screenHeight * 0.27,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          // fit: BoxFit.contain,
                        ),
                        const SpacerVertical(height: 10),
                        Padding(
                          padding: EdgeInsets.only(bottom: 0.sp),
                          child: ListAlignment(
                            date: provider.blogsDetail?.postDateString ?? "",
                            list1: provider.blogsDetail?.authors,
                            list2: const [],
                            blog: true,
                          ),
                        ),
                        SpacerVertical(height: Dimen.itemSpacing.sp),
                        //Text("shwoing ticker Data", style: TextStyle(color: Colors.white),),
                        //New Blog Tickers Widget
                        const BlogDetailMentionBy(),

                        SpacerVertical(height: Dimen.itemSpacing.sp),
                        // const BlogDetailAuthor(),
                        // const SpacerVertical(height: 5),
                        // const BlogDetailCategory(),
                        // const SpacerVertical(height: 5),
                        // const BlogDetailTags(),
                        HtmlWidget(
                          onTapImage: (data) {
                            Utils().showLog(data.sources.first.url);
                          },
                          onTapUrl: (url) async {
                            bool a = false;
                            if (Platform.isAndroid) {
                              a = await launchUrl(Uri.parse(url));
                              // Utils().showLog("clicked ur---$url, return value $a");
                            } else {
                              a = true;
                              Uri uri = Uri.parse(url);
                              iOSNavigate(uri);
                              // Utils().showLog("iOS navigation");
                            }
                            return a;
                          },

                          // customWidgetBuilder: (element) {
                          //   if (element.localName == 'img') {
                          //     final src = element.attributes['src'];
                          //     return ZoomableImage(url: src ?? "");
                          //   }
                          //   return null;
                          // },
                          onLoadingBuilder:
                              (context, element, loadingProgress) {
                            return const ProgressDialog();
                          },
                          provider.blogsDetail?.description ?? "",
                          textStyle:
                              styleGeorgiaRegular(fontSize: 18, height: 1.5),
                        ),
                        if (provider.blogsDetail?.feedbackMsg != null)
                          ArticleFeedback(
                            feebackType: provider.extra?.feebackType,
                            title: provider.blogsDetail?.feedbackMsg,
                            submitMessage:
                                provider.blogsDetail?.feedbackExistMsg,
                            onSubmit: (value) =>
                                _onSubmitAffiliate(value, context),
                          ),
                        const SpacerVertical(height: 30),
                      ],
                    ),
                  ),

                  //TODO: Add condition here
                  Positioned(
                    bottom: 6.sp,
                    right: 0,
                    child: FloatingActionButton(
                      backgroundColor: ThemeColors.accent,
                      child: const Icon(Icons.share),
                      onPressed: () {
                        commonShare(
                          title: provider.blogsDetail?.name ?? "",
                          url: provider.blogsDetail?.slug ?? "",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if ((provider.blogsDetail?.readingStatus == false) &&
            !provider.isLoadingDetail)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  height: height / 2,
                  // height: double.infinity,
                  // width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        ThemeColors.tabBack,
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: height / 1.2,
                // width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ThemeColors.tabBack,
                ),
                child: context.watch<UserProvider>().user == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock, size: 40),
                            const SpacerVertical(),
                            Text(
                              "${provider.blogsDetail?.readingTitle}",
                              style: stylePTSansBold(fontSize: 18),
                            ),
                            const SpacerVertical(height: 10),
                            Text(
                              "${provider.blogsDetail?.readingSubtitle}",
                              style: stylePTSansRegular(
                                fontSize: 14,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SpacerVertical(height: 10),
                            // if (context.watch<UserProvider>().user == null)
                            ThemeButtonSmall(
                              onPressed: () => _onLoginClick(context),
                              text: "Login to continue",
                              showArrow: false,
                            ),
                            const SpacerVertical(),
                          ],
                        ),
                      )
                    : provider.blogsDetail?.balanceStatus == null ||
                            provider.blogsDetail?.balanceStatus == false
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock, size: 40),
                                const SpacerVertical(),
                                Text(
                                  "${provider.blogsDetail?.readingTitle}",
                                  style: stylePTSansBold(fontSize: 18),
                                ),
                                const SpacerVertical(height: 10),
                                Text(
                                  "${provider.blogsDetail?.readingSubtitle}",
                                  style: stylePTSansRegular(
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SpacerVertical(height: 10),
                                ThemeButtonSmall(
                                  onPressed: () {
                                    Share.share(
                                      "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                                    );
                                  },
                                  text: "Refer Now",
                                  showArrow: false,
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock, size: 40),
                                const SpacerVertical(),
                                Text(
                                  "${provider.blogsDetail?.readingTitle}",
                                  style: stylePTSansBold(fontSize: 18),
                                ),
                                const SpacerVertical(height: 10),
                                Text(
                                  "${provider.blogsDetail?.readingSubtitle}",
                                  style: stylePTSansRegular(
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SpacerVertical(height: 10),
                                ThemeButtonSmall(
                                  onPressed: () => _onViewBlogClick(context),
                                  text: "View Blog",
                                  showArrow: false,
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          )
      ],
    );
  }
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
                  builder: (_) => NewsAuthorIndex(data: list[i], type: type),
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
