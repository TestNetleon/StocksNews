import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/newTopGraph/index.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/analysis_forecast.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/states.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_mentions.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_trending_stories.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_mention_with.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import '../../utils/colors.dart';
import 'widgets/AlertWatchlist/add_alert_watchlist.dart';
import 'widgets/analysis.dart';
import 'widgets/companyBrief/container.dart';
import 'widgets/companyEarning/container.dart';
import 'widgets/redditComments/reddit_twitter_iframe.dart';
import 'widgets/scoreGrades/container.dart';
import 'widgets/stock_top_detail.dart';
import 'widgets/technicalAnalysis/index.dart';

//
class StockDetailsBase extends StatelessWidget {
  const StockDetailsBase({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();

    CompanyInfo? companyInfo = provider.data?.companyInfo;
    // List<TradingStock>? tradingStock = provider.dataMentions?.tradingStock;
    // List<Mentions>? mentions = provider.dataMentions?.mentions;
    String? html = provider.dataMentions?.forecastAnalyst;

    return Stack(
      children: [
        CustomTabContainerNEW(
          physics: const NeverScrollableScrollPhysics(),
          scrollable: true,
          tabs: const [
            "Overview",
            "Company Earnings",
            "Key Stats",
            "Stock Score/Grades",
            // "Company Brief",
            "Stock Analysis",
            "Analysis Forecast",
            "Technical Analysis",
            "News Mentions",
            "Recent Reddit Posts and X Tweets",
            "Trending Stories",
            "Popular Stocks"
          ],
          widgets: [
            StockDetailsTabContainer(
              content: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dimen.padding.sp,
                      right: Dimen.padding.sp,
                    ),
                    child: StockTopDetail(),
                  ),
                  // StockDetailTopGraph(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.sp,
                      right: 8.sp,
                    ),
                    child: NewTopGraphIndex(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dimen.padding.sp,
                      right: Dimen.padding.sp,
                    ),
                    child: CompanyBrief(),
                  ),
                  // SpacerVertical(height: 90),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: CompanyEarningStockDetail(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: States(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: StocksScoreGrades(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: Analysis(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: StockDetailsTabContainer(
                content: html == null || html.isEmpty
                    ? const ErrorDisplayWidget(
                        smallHeight: true,
                        error: 'No analysis forecast found.',
                      )
                    : AnalysisForecast(html: html),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: StocksTechnicalAnalysis(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: StocksMentions(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: StockDetailsTabContainer(
                content: RedditTwitterIframe(
                  redditRssId: companyInfo?.redditRssId,
                  twitterRssId: companyInfo?.twitterRssId,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: StocksTrendingStories(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding.sp,
                right: Dimen.padding.sp,
              ),
              child: const StockDetailsTabContainer(
                content: StockMentionWith(),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              // border: Border.all(color: ThemeColors.greyBorder),
              border: Border(
                top: BorderSide(color: ThemeColors.greyBorder),
              ),
              color: ThemeColors.tabBack,
              // borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(5.sp),
              // topRight: Radius.circular(5.sp),
              // ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: const AddToAlertWatchlist(),
          ),
        )
      ],
    );
  }
}

class StockDetailsTabContainer extends StatelessWidget {
  final Widget content;

  const StockDetailsTabContainer({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          // padding: EdgeInsets.all(Dimen.padding.sp),
          padding: EdgeInsets.only(
            top: Dimen.padding.sp,
            // left: Dimen.padding.sp,
            // right: Dimen.padding.sp,
            bottom: 90.sp,
          ),
          child: content,
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       // border: Border.all(color: ThemeColors.greyBorder),
        //       border: Border(
        //         top: BorderSide(color: ThemeColors.greyBorder),
        //       ),
        //       color: ThemeColors.tabBack,
        //       // borderRadius: BorderRadius.only(
        //       // topLeft: Radius.circular(5.sp),
        //       // topRight: Radius.circular(5.sp),
        //       // ),
        //     ),
        //     padding: EdgeInsets.symmetric(horizontal: 10.sp),
        //     child: const AddToAlertWatchlist(),
        //   ),
        // )
      ],
    );
  }
}
