import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/reddit_twitter_res.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/custom_tab_item_label.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_item_insider_trending.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/reddit_twitter_item.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/reddit_twitter_content.dart';
import 'package:stocks_news_new/widgets/view_more_widget.dart';

//
class InsiderSocialTabs extends StatefulWidget {
  const InsiderSocialTabs({super.key});

  @override
  State<InsiderSocialTabs> createState() => _InsiderSocialTabsState();
}

class _InsiderSocialTabsState extends State<InsiderSocialTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // height: 36,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ThemeColors.accent, width: 1.sp),
            ),
          ),
          child: Row(
            children: [
              CustomTabLabel(
                "Insider Trending",
                coloredLetters: const ['T'],
                selected: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              VerticalDivider(
                color: ThemeColors.accent,
                width: 1.sp,
                thickness: 1.sp,
              ),
              CustomTabLabel(
                "Reddit/X Mention",
                coloredLetters: const ['M'],
                selected: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedIndex == 0
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(0, 10.sp, 0, 0),
                    //   child: Text(
                    //     "Recent Insider Trades: Unveiling Market Insights through Real-Time Transactions",
                    //     style: stylePTSansRegular(fontSize: 12),
                    //   ),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //     Padding(
                        //   padding: EdgeInsets.fromLTRB(0, 10.sp, 0, 0),
                        //   child: Text(
                        //     "Recent Insider Trades: Unveiling Market Insights through Real-Time Transactions",
                        //     style: stylePTSansRegular(fontSize: 12),
                        //   ),
                        // ),
                        HomeItemInsiderTrending(),
                      ],
                    ),
                  ],
                )
              : const HomeRedditTwitterContentIndex(),
        ),
        const SpacerVertical(height: Dimen.itemSpacing),
        Visibility(
          visible: _selectedIndex == 0,
          child:
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: ThemeButtonSmall(
              //     onPressed: () {
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(builder: (_) => const Tabs(index: 2)),
              //       );
              //     },
              //     text: "View More",
              //   ),
              // ),
              ViewMoreWidget(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Tabs(index: 2)),
              );
            },
            text: "View More Insider Trending",
          ),
        )
      ],
    );
  }
}

class HomeRedditTwitterContentIndex extends StatefulWidget {
  const HomeRedditTwitterContentIndex({super.key});

  @override
  State<HomeRedditTwitterContentIndex> createState() =>
      _HomeRedditTwitterContentIndexState();
}

class _HomeRedditTwitterContentIndexState
    extends State<HomeRedditTwitterContentIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<RedditTwitterProvider>().getRedditTwitterData(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const RedditTwitterHomeContentBase();
  }
}

class RedditTwitterHomeContentBase extends StatelessWidget {
  const RedditTwitterHomeContentBase({super.key});

  @override
  Widget build(BuildContext context) {
    RedditTwitterProvider provider = context.watch<RedditTwitterProvider>();

    return RedditTwitterContent(
      widget: provider.isLoading
          ? Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 30.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: ThemeColors.accent,
                    ),
                    const SpacerHorizontal(width: 5),
                    Flexible(
                      child: Text(
                        "Preparing your data.. Please wait.",
                        style: stylePTSansRegular(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : !provider.isLoading &&
                  (provider.socialSentimentRes?.data == null ||
                      provider.socialSentimentRes?.data.isEmpty == true)
              ? Center(
                  child: ErrorDisplayWidget(
                    smallHeight: true,
                    error: provider.error,
                    onRefresh: () => provider.getRedditTwitterData(reset: true),
                  ),
                )
              : ListView.separated(
                  itemCount: provider.socialSentimentRes?.data.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 12.sp),
                  itemBuilder: (context, index) {
                    SocialSentimentItemRes? data =
                        provider.socialSentimentRes?.data[index];

                    if (data == null && !provider.isLoading) {
                      return const SizedBox();
                    }
                    return RedditTwitterItem(
                      data: data,
                      up: index % 3 == 0,
                      index: index,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    // return const SpacerVertical(height: 12);
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 10.sp,
                    );
                  },
                ),
    );
  }
}
