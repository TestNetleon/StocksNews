import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/analysis_forecast.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/states.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_mentions.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_trending_stories.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_mention_with.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import '../../utils/colors.dart';
import '../../widgets/spacer_vertical.dart';
import 'widgets/AlertWatchlist/add_alert_watchlist.dart';
import 'widgets/analysis.dart';
import 'widgets/companyBrief/container.dart';
import 'widgets/companyEarning/container.dart';
import 'widgets/redditComments/reddit_twitter_iframe.dart';
import 'widgets/scoreGrades/container.dart';
import 'widgets/stock_top_detail.dart';
import 'widgets/technicalAnalysis/index.dart';
import 'widgets/top_graph.dart';

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

    return CustomTabContainerNEW(
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
        Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(Dimen.padding.sp),
              child: const Column(
                children: [
                  StockTopDetail(),
                  StockDetailTopGraph(),
                  CompanyBrief(),
                  SpacerVertical(height: 90),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ThemeColors.greyBorder),
                  color: ThemeColors.primaryLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.sp),
                    topRight: Radius.circular(5.sp),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: const AddToAlertWatchlist(),
              ),
            )
          ],
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const CompanyEarningStockDetail(),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const States(),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const StocksScoreGrades(),
        ),
        // SingleChildScrollView(
        //   padding: EdgeInsets.all(Dimen.padding.sp),
        //   child: const CompanyBrief(),
        // ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const Analysis(),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: html == null || html.isEmpty
              ? const ErrorDisplayWidget(
                  smallHeight: true,
                  error: 'No analysis forecast found.',
                )
              : AnalysisForecast(html: html),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const StocksTechnicalAnalysis(),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const Visibility(
            // visible: mentions?.isNotEmpty == true,
            child: StocksMentions(),
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: RedditTwitterIframe(
            redditRssId: companyInfo?.redditRssId,
            twitterRssId: companyInfo?.twitterRssId,
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const StocksTrendingStories(),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.padding.sp),
          child: const Visibility(
            // visible: tradingStock?.isNotEmpty == true,
            child: StockMentionWith(),
          ),
        ),
      ],
    );

//     return Column(
//       children: [
//         CustomTabContainerNEW(
//           tabs: [
//             "Home",
//             // "A",
//             // "B",
//             // "C",
//             // "D",
//             // "E",
//             // "F",
//             // "G",
//             // "H",
//             // "I",
//             // "J",
//             // "K",
//             // "L"
//           ],
//           widgets: [
//             const StockTopDetail(),
//             // const StockDetailTopGraph(),
//             // // const SpacerVertical(),
//             // const CompanyEarningStockDetail(),
//             // const States(),
//             // // const SpacerVertical(),
//             // const StocksScoreGrades(),
//             // const CompanyBrief(),
//             // const Analysis(),
//             // // const SpacerVertical(),
//             // html == null || html.isEmpty
//             //     ? const SizedBox()
//             //     : AnalysisForecast(html: html),
//             // // const SpacerVertical(),
//             // const StocksTechnicalAnalysis(),

//             // // const SpacerVertical(),
//             // // const TwitterSentiments(),
//             // // const SpacerVertical(),
//             // // Visibility(
//             // //     visible: redditPost?.isNotEmpty == true,
//             // //     child: const RedditSentiments()),
//             // // const SpacerVertical(),

//             // Visibility(
//             //     visible: mentions?.isNotEmpty == true,
//             //     child: const StocksMentions()),
//             // // const SpacerVertical(),

//             // RedditTwitterIframe(
//             //   redditRssId: companyInfo?.redditRssId,
//             //   twitterRssId: companyInfo?.twitterRssId,
//             // ),
//             // // const SpacerVertical(),

//             // const StocksTrendingStories(),
//             // // Visibility(
//             // //   visible: companyInfo?.description != null &&
//             // //       companyInfo?.description?.isNotEmpty == true,
//             // //   child: const SpacerVertical(),
//             // // ),
//             // // Visibility(
//             // //   visible: companyInfo?.description != null &&
//             // //       companyInfo?.description?.isNotEmpty == true,
//             // //   child: const AboutStock(),
//             // // ),
//             // // const SpacerVertical(),
//             // Visibility(
//             //   visible: tradingStock?.isNotEmpty == true,
//             //   child: const StockMentionWith(),
//             // ),
//             // // const SpacerVertical(height: 90),
//           ],
//         ),

//         // SingleChildScrollView(
//         //   child: Padding(
//         //     padding: EdgeInsets.all(Dimen.padding.sp),
//         //     child: Column(
//         //       children: [
//         //         const StockTopDetail(),
//         //         const StockDetailTopGraph(),
//         //         const SpacerVertical(),
//         //         const CompanyEarningStockDetail(),
//         //         const States(),
//         //         const SpacerVertical(),
//         //         const StocksScoreGrades(),
//         //         const CompanyBrief(),
//         //         const Analysis(),
//         //         const SpacerVertical(),
//         //         html == null || html.isEmpty
//         //             ? const SizedBox()
//         //             : AnalysisForecast(html: html),
//         //         const SpacerVertical(),
//         //         const StocksTechnicalAnalysis(),

//         //         // const SpacerVertical(),
//         //         // const TwitterSentiments(),
//         //         // const SpacerVertical(),
//         //         // Visibility(
//         //         //     visible: redditPost?.isNotEmpty == true,
//         //         //     child: const RedditSentiments()),
//         //         const SpacerVertical(),

//         //         Visibility(
//         //             visible: mentions?.isNotEmpty == true,
//         //             child: const StocksMentions()),
//         //         const SpacerVertical(),

//         //         RedditTwitterIframe(
//         //           redditRssId: companyInfo?.redditRssId,
//         //           twitterRssId: companyInfo?.twitterRssId,
//         //         ),
//         //         // const SpacerVertical(),

//         //         const StocksTrendingStories(),
//         //         Visibility(
//         //           visible: companyInfo?.description != null &&
//         //               companyInfo?.description?.isNotEmpty == true,
//         //           child: const SpacerVertical(),
//         //         ),
//         //         // Visibility(
//         //         //   visible: companyInfo?.description != null &&
//         //         //       companyInfo?.description?.isNotEmpty == true,
//         //         //   child: const AboutStock(),
//         //         // ),
//         //         // const SpacerVertical(),
//         //         Visibility(
//         //           visible: tradingStock?.isNotEmpty == true,
//         //           child: const StockMentionWith(),
//         //         ),
//         //         const SpacerVertical(height: 90),
//         //       ],
//         //     ),
//         //   ),
//         // ),

//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.greyBorder),
//               color: ThemeColors.primaryLight,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(5.sp),
//                 topRight: Radius.circular(5.sp),
//               ),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 10.sp),
//             child: const AddToAlertWatchlist(),
//           ),
//         )
//       ],
//     );
  }
}
