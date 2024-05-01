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
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/text_input_field_search.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/reddit_twitter_item.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
//
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
    // if (provider.socialSentimentRes == null && !provider.isLoading) {
    //   return
    // }
    return BaseContainer(
      drawer: const BaseDrawer(),
      appbar: const AppBarHome(canSearch: true),
      body: Padding(
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
              child: provider.isLoading && provider.socialSentimentRes == null
                  ? Center(
                      child: Text(
                        "We are preparing …",
                        style: styleGeorgiaRegular(color: Colors.white),
                      ),
                    )
                  : provider.socialSentimentRes == null && !provider.isLoading
                      ? Center(
                          child: ErrorDisplayNewWidget(
                            error: provider.error,
                            onRefresh: _getRedditTwitterData,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await _getRedditTwitterData();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: _getWidget(provider),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWidget(RedditTwitterProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: provider.socialSentimentRes?.avgSentiment != null,
              child: const SocialSentimentsGraph(),
            ),
            const SpacerVerticel(),
            TextInputFieldSearch(
              hintText: "Search symbol or company name",
              onSubmitted: (text) {
                closeKeyboard();
                _getRedditTwitterData(search: text, isSearching: true);
              },
              searching: provider.isSearching,
              editable: true,
            ),
            const SpacerVerticel(height: 10),
            // RedditTwitterButtons(constraints: constraints),
            // const SpacerVerticel(height: 8),
            Text(
              "SHOW THE LAST - ",
              style: stylePTSansBold(fontSize: 12),
            ),
            RedditTwitterDays(constraints: constraints),
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
                        ? SizedBox(
                            height: 270.sp,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: ThemeColors.accent,
                                  ),
                                  const SpacerHorizontal(width: 5),
                                  Flexible(
                                      child: Text(
                                    "Preparing your data.. Please wait",
                                    style: stylePTSansRegular(),
                                  )),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount:
                                provider.socialSentimentRes?.data.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 12.sp),
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
                              // return const SpacerVerticel(height: 12);
                              return Divider(
                                color: ThemeColors.greyBorder,
                                height: 12.sp,
                              );
                            },
                          ),
                Divider(
                  color: ThemeColors.greyBorder,
                  height: 40.sp,
                ),
                // Text(
                //   "Most Recent Mentions",
                //   style: stylePTSansBold(),
                // ),
                // Text(
                //   "Most mentioned stocks in the last hour.",
                //   style: stylePTSansRegular(),
                // ),

                const ScreenTitle(
                  title: "Most Recent Mentions",
                  subTitle: "Most mentioned stocks in the last hour.",
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
                    // return const SpacerVerticel(height: 12);
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 12.sp,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
