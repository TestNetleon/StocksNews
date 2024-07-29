import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/reddit_twitter_res.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/days.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/recent_mention_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/text_input_field_search.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/reddit_twitter_item.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/user_provider.dart';
import '../../marketData/lock/common_lock.dart';
import 'widgets/buttons.dart';
import 'widgets/graph.dart';

class RedditTwitter extends StatefulWidget {
  const RedditTwitter({super.key});

  @override
  State<RedditTwitter> createState() => _RedditTwitterState();
}

class _RedditTwitterState extends State<RedditTwitter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _getRedditTwitterData(reset: true);
    });
  }

  Future _getRedditTwitterData(
      {reset = false, String search = "", bool isSearching = false}) async {
    await context.read<RedditTwitterProvider>().getRedditTwitterData(
        reset: reset, search: search, isSearching: isSearching);
  }

  @override
  Widget build(BuildContext context) {
    RedditTwitterProvider provider = context.watch<RedditTwitterProvider>();
    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Sentiments"},
    );
    HomeProvider homeProvider = context.watch<HomeProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    bool purchased = userProvider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) =>
                (element.key == "reddit-twitter" && element.status == 0)) ??
        false;

    // bool isLocked = true;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) =>
                  (element.key == "reddit-twitter" && element.status == 1)) ??
          false;

      isLocked = !havePermissions;
    }
    Utils().showLog("isLocked? $isLocked, Purchased? $purchased");

    return BaseContainer(
      appBar: AppBarHome(isHome: false, title: "Sentiments"),
      drawer: const BaseDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimen.padding.sp,
              0,
              Dimen.padding.sp,
              0,
            ),
            child: Column(
              children: [
                // const ScreenTitle(title: "Social Sentiment"),
                Expanded(
                  child: provider.isLoading &&
                          provider.socialSentimentRes == null
                      ? const Loading()
                      : provider.socialSentimentRes == null &&
                              !provider.isLoading
                          ? Center(
                              child: ErrorDisplayNewWidget(
                                error: provider.error,
                                onRefresh: _getRedditTwitterData,
                              ),
                            )
                          : CommonRefreshIndicator(
                              onRefresh: () async {
                                await _getRedditTwitterData();
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: _getWidget(),
                              ),
                            ),
                ),
              ],
            ),
          ),
          if (isLocked) CommonLock(showLogin: true, isLocked: isLocked),
        ],
      ),
    );
  }

  Widget _getWidget() {
    RedditTwitterProvider provider = context.watch<RedditTwitterProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: provider.socialSentimentRes?.avgSentiment != null,
              child: const SocialSentimentsGraph(),
            ),
            const SpacerVertical(),
            TextInputFieldSearch(
              hintText: "Search symbol or company name",
              onSubmitted: (text) {
                closeKeyboard();
                _getRedditTwitterData(search: text, isSearching: true);
              },
              searching: provider.isSearching,
              editable: true,
            ),
            const SpacerVertical(height: 10),
            Row(
              children: [
                Text(
                  "DATA SOURCE - ",
                  style: stylePTSansBold(fontSize: 12),
                ),
                Flexible(child: RedditTwitterButtons(constraints: constraints)),
              ],
            ),
            const SpacerVertical(height: 5),
            Row(
              children: [
                Text(
                  "SHOW THE LAST - ",
                  style: stylePTSansBold(fontSize: 12),
                ),
                RedditTwitterDays(constraints: constraints),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                provider.socialSentimentRes?.data.isEmpty == true &&
                        !provider.isLoading
                    ? Center(
                        child: ErrorDisplayNewWidget(
                          error: provider.error,
                          onRefresh: _getRedditTwitterData,
                        ),
                      )
                    : provider.daysLoading
                        ? const Loading()
                        // SizedBox(
                        //     height: 270.sp,
                        //     child: Center(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           const CircularProgressIndicator(
                        //             color: ThemeColors.accent,
                        //           ),
                        //           const SpacerHorizontal(width: 5),
                        //           Flexible(
                        //               child: Text(
                        //             "Preparing your data.. Please wait",
                        //             style: stylePTSansRegular(),
                        //           )),
                        //         ],
                        //       ),
                        //     ),
                        //   )
                        : ListView.separated(
                            itemCount:
                                provider.socialSentimentRes?.data.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 12),
                            itemBuilder: (context, index) {
                              SocialSentimentItemRes? data =
                                  provider.socialSentimentRes?.data[index];

                              return RedditTwitterItem(
                                up: index % 3 == 0,
                                index: index,
                                data: data,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              // return const SpacerVertical(height: 12);
                              return Divider(
                                color: ThemeColors.greyBorder,
                                height: 12.sp,
                              );
                            },
                          ),
                const Divider(
                  color: ThemeColors.greyBorder,
                  height: 40,
                ),
                // Text(
                //   "Most Recent Mentions",
                //   style: stylePTSansBold(),
                // ),
                // Text(
                //   "Most mentioned stocks in the last hour.",
                //   style: stylePTSansRegular(),
                // ),

                ScreenTitle(
                  title: "Most Recent Mentions",
                  subTitle: provider.socialSentimentRes?.text?.mentionText,
                ),
                ListView.separated(
                  itemCount:
                      provider.socialSentimentRes?.recentMentions?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 0, bottom: 15.sp),
                  itemBuilder: (context, index) {
                    RecentMention? data =
                        provider.socialSentimentRes?.recentMentions?[index];
                    if (data == null) {
                      return const SizedBox();
                    }
                    return SocialSentimentMentions(
                      data: data,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    // return const SpacerVertical(height: 12);
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 12.sp,
                    );
                  },
                ),
                if (provider.extra?.disclaimer != null &&
                    provider.socialSentimentRes != null &&
                    !provider.isLoading)
                  DisclaimerWidget(
                    data: provider.extra!.disclaimer!,
                  )
              ],
            ),
          ],
        );
      },
    );
  }
}
