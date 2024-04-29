import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/analysis_forecast.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/states.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_mentions.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_trending_stories.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocks_mention_with.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
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
    List<TradingStock>? tradingStock = provider.dataMentions?.tradingStock;
    List<Mentions>? mentions = provider.dataMentions?.mentions;
    String? html = provider.dataMentions?.forecastAnalyst;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimen.padding.sp),
            child: Column(
              children: [
                const StockTopDetail(),
                const StockDetailTopGraph(),
                const SpacerVerticel(),
                const CompanyEarningStockDetail(),

                const States(),
                const SpacerVerticel(),
                const StocksScoreGrades(),
                const CompanyBrief(),
                const Analysis(),
                const SpacerVerticel(),
                html == null || html.isEmpty
                    ? const SizedBox()
                    : AnalysisForecast(html: html),
                const SpacerVerticel(),
                const StocksTechnicalAnalysis(),

                // const SpacerVerticel(),
                // const TwitterSentiments(),
                // const SpacerVerticel(),
                // Visibility(
                //     visible: redditPost?.isNotEmpty == true,
                //     child: const RedditSentiments()),
                const SpacerVerticel(),

                Visibility(
                    visible: mentions?.isNotEmpty == true,
                    child: const StocksMentions()),
                const SpacerVerticel(),

                RedditTwitterIframe(
                  redditRssId: companyInfo?.redditRssId,
                  twitterRssId: companyInfo?.twitterRssId,
                ),
                const SpacerVerticel(),

                const StocksTrendingStories(),
                Visibility(
                  visible: companyInfo?.description != null &&
                      companyInfo?.description?.isNotEmpty == true,
                  child: const SpacerVerticel(),
                ),
                // Visibility(
                //   visible: companyInfo?.description != null &&
                //       companyInfo?.description?.isNotEmpty == true,
                //   child: const AboutStock(),
                // ),
                // const SpacerVerticel(),
                Visibility(
                  visible: tradingStock?.isNotEmpty == true,
                  child: const StockMentionWith(),
                ),
                const SpacerVerticel(height: 90),
              ],
            ),
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
    );
  }
}
