import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/newTopGraph/index.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/analysis_forecast.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/states.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_mentions.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_trending_stories.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import '../../utils/colors.dart';
import '../../widgets/custom/refresh_indicator.dart';
import '../../widgets/disclaimer_widget.dart';
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
  final String symbol;
  final String? inAppMsgId;
  final String? notificationId;

  const StockDetailsBase({
    super.key,
    required this.symbol,
    this.inAppMsgId,
    this.notificationId,
  });

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
            "Stock Analysis",
            "Analysis Forecast",
            "Technical Analysis",
            "News Mentions",
            "Recent Reddit Posts and X Tweets",
            "Trending Stories",
            // "Popular Stocks",
          ],
          widgets: [
            BaseUiContainer(
              hasData: !provider.isLoading ||
                  !provider.isLoadingGraph ||
                  provider.data != null &&
                      (provider.graphChart != null &&
                          provider.graphChart?.isNotEmpty == true),
              isLoading: provider.isLoading ||
                  provider.isLoadingGraph &&
                      provider.data == null &&
                      (provider.graphChart == null &&
                          provider.graphChart?.isEmpty == true),
              error: provider.data != null
                  ? provider.error
                  : (provider.graphChart != null &&
                          provider.graphChart?.isNotEmpty == true)
                      ? provider.graphError
                      : null,
              showPreparingText: true,
              child: CommonRefreshIndicator(
                onRefresh: () async {
                  provider.getStockDetails(symbol: symbol);
                  provider.getStockGraphData(symbol: symbol);
                },
                child: StockDetailsTabContainer(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: Dimen.padding,
                          right: Dimen.padding,
                        ),
                        child: StockTopDetail(symbol: symbol),
                      ),
                      // StockDetailTopGraph(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: NewTopGraphIndex(symbol: symbol),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     left: Dimen.padding.sp,
                      //     right: Dimen.padding.sp,
                      //     bottom: Dimen.padding.sp,
                      //   ),
                      //   child: const StockDetailAnalystData(),
                      // ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: Dimen.padding,
                          right: Dimen.padding,
                        ),
                        child: CompanyBrief(),
                      ),
                      if (provider.extra?.disclaimer != null)
                        DisclaimerWidget(
                          data: provider.extra!.disclaimer!,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimen.padding),
                        ),
                      // SpacerVertical(height: 90),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: CommonRefreshIndicator(
                onRefresh: () async {
                  provider.getStockOtherDetails(symbol: symbol);
                },
                child: StockDetailsTabContainer(
                  content: CompanyEarningStockDetail(
                    symbol: symbol,
                    inAppMsgId: inAppMsgId,
                    notificationId: notificationId,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: States(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: StocksScoreGrades(
                  symbol: symbol,
                  inAppMsgId: inAppMsgId,
                  notificationId: notificationId,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: Analysis(symbol: symbol),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: html == null || html.isEmpty
                    ? const ErrorDisplayWidget(
                        smallHeight: true,
                        error: 'No analysis forecast found.',
                      )
                    // ? const NoDataCustom(
                    //     error: "No analysis forecast data found.",
                    //   )
                    : AnalysisForecast(html: html),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: StocksTechnicalAnalysis(
                  symbol: symbol,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: StocksMentions(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: RedditTwitterIframe(
                  redditRssId: companyInfo?.redditRssId,
                  twitterRssId: companyInfo?.twitterRssId,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: Dimen.padding,
                right: Dimen.padding,
              ),
              child: StockDetailsTabContainer(
                content: StocksTrendingStories(),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     left: Dimen.padding.sp,
            //     right: Dimen.padding.sp,
            //   ),
            //   child: const StockDetailsTabContainer(
            //     content: StockMentionWith(),
            //   ),
            // ),
          ],
        ),
        Visibility(
          visible: !provider.isLoading ||
              !provider.isLoadingGraph &&
                  provider.data == null &&
                  (provider.graphChart == null &&
                      provider.graphChart?.isEmpty == true),
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                // border: Border.all(color: ThemeColors.greyBorder),
                border: const Border(
                  top: BorderSide(color: ThemeColors.greyBorder),
                ),
                color: ThemeColors.background.withOpacity(0.8),

                // borderRadius: BorderRadius.only(
                // topLeft: Radius.circular(5.sp),
                // topRight: Radius.circular(5.sp),
                // ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: const AddToAlertWatchlist(),
            ),
          ),
        ),
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
          physics: const AlwaysScrollableScrollPhysics(),
          // padding: EdgeInsets.all(Dimen.padding.sp),
          padding: EdgeInsets.only(
            top: isPhone ? Dimen.padding.sp : Dimen.paddingTablet.sp,
            // left: Dimen.padding.sp,
            // right: Dimen.padding.sp,
            bottom: 95.sp,
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
