import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/providers/congressional_detail_provider.dart';
import 'package:stocks_news_new/providers/dividends_provider.dart';
import 'package:stocks_news_new/providers/dow_30_provider.dart';
import 'package:stocks_news_new/providers/earnings_provider.dart';
import 'package:stocks_news_new/providers/featured_ticker.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_high_provider.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_provider.dart';
import 'package:stocks_news_new/providers/gap_down_provider.dart';
import 'package:stocks_news_new/providers/gap_up_provider.dart';
import 'package:stocks_news_new/providers/high_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/high_pe_growth_provider.dart';
import 'package:stocks_news_new/providers/high_pe_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/indices_provider.dart';
import 'package:stocks_news_new/providers/low_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/low_pe_growth_provider.dart';
import 'package:stocks_news_new/providers/low_pe_provider.dart';
import 'package:stocks_news_new/providers/low_prices_stocks.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/providers/most_active_penny_stocks_provider.dart';
import 'package:stocks_news_new/providers/most_active_provider.dart';
import 'package:stocks_news_new/providers/most_popular_penny_provider.dart';
import 'package:stocks_news_new/providers/most_volatile_stocks.dart';
import 'package:stocks_news_new/providers/negative_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/providers/sector_industry_provider.dart';
import 'package:stocks_news_new/providers/snp_500_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/today_breackout_stocks_provider.dart';
import 'package:stocks_news_new/providers/today_top_gainer_provider.dart';
import 'package:stocks_news_new/providers/today_top_loser_provider.dart';
import 'package:stocks_news_new/providers/top_today_penny_stocks_provider.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/providers/unusual_trading_volume_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

import '../../../../utils/constants.dart';
import 'setup_alert.dart';

//
class AlertPopup extends StatefulWidget {
  final String symbol;
  final bool up;
  final bool fromTrending;
  final bool fromTopStock;
  final bool fromStockDetail;
  final bool homeTrending;
  final int index;
  final bool homeTopGainers;
  final bool homeTopLosers;
  final bool homeMostBoughtMembers;
  final bool homeFeatureStocks;
  final bool marketDataTopGainers;
  final bool marketDataTopLosers;
  final bool marketDataTodaysBreakOut;
  final bool marketDataGapUp;
  final bool marketDataGapDown;
  final bool marketDataHighPe;
  final bool marketDataLowPe;
  final bool marketDataHighPeGrowth;
  final bool marketDataLowPeGrowth;
  final bool marketDataFiftyTwoHigh;
  final bool marketDataFiftyTwoLow;
  final bool marketDataHighBetaStocks;
  final bool marketDataLowBetaStocks;
  final bool marketDataNegativeBetaStocks;
  final bool marketDataDowStocks;
  final bool marketDataSP500;
  final bool marketDataIndices;
  final bool marketDataLowPriceStocks;
  final bool marketDataMostActiveStocks;
  final bool marketDataMostVolatile;
  final bool marketDataUnusualTradingVolume;
  final bool marketDataMostActivePenny;
  final bool marketDataMostPopularPenny;
  final bool marketDataTopTodayPenny;
  final bool marketDataDividends;
  final bool marketDataEarning;
  final bool marketDataStocks;
  final bool sectorAndIndustry;
  final bool stocksAnalysisPeers;
  final bool competitorsDetail;
  final bool sentimentShowTheLast;
  final bool sentimentRecent;
  final bool congresionalImagesClick;

  final StocksType? homeGainersAndLosers;

  final EdgeInsets? insetPadding;
  const AlertPopup({
    super.key,
    required this.symbol,
    this.up = false,
    this.fromTrending = false,
    this.fromTopStock = false,
    this.fromStockDetail = false,
    this.homeTrending = false,
    this.index = 0,
    this.insetPadding,
    this.homeTopGainers = false,
    this.homeTopLosers = false,
    this.homeMostBoughtMembers = false,
    this.homeFeatureStocks = false,
    this.marketDataTopGainers = false,
    this.marketDataTopLosers = false,
    this.marketDataTodaysBreakOut = false,
    this.marketDataGapUp = false,
    this.marketDataGapDown = false,
    this.marketDataHighPe = false,
    this.marketDataLowPe = false,
    this.marketDataHighPeGrowth = false,
    this.marketDataLowPeGrowth = false,
    this.marketDataFiftyTwoHigh = false,
    this.marketDataFiftyTwoLow = false,
    this.marketDataHighBetaStocks = false,
    this.marketDataLowBetaStocks = false,
    this.marketDataNegativeBetaStocks = false,
    this.marketDataDowStocks = false,
    this.marketDataSP500 = false,
    this.marketDataIndices = false,
    this.marketDataLowPriceStocks = false,
    this.marketDataMostActiveStocks = false,
    this.marketDataMostVolatile = false,
    this.marketDataUnusualTradingVolume = false,
    this.marketDataMostActivePenny = false,
    this.marketDataMostPopularPenny = false,
    this.marketDataTopTodayPenny = false,
    this.marketDataDividends = false,
    this.marketDataEarning = false,
    this.marketDataStocks = false,
    this.sectorAndIndustry = false,
    this.stocksAnalysisPeers = false,
    this.competitorsDetail = false,
    this.sentimentShowTheLast = false,
    this.sentimentRecent = false,
    this.congresionalImagesClick = false,
    this.homeGainersAndLosers,
  });

  @override
  State<AlertPopup> createState() => _AlertPopupState();
}

class _AlertPopupState extends State<AlertPopup> {
  bool selectedOne = false;
  bool selectedTwo = false;
  TextEditingController controller = TextEditingController();
  TextEditingController symbolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = "New ${widget.symbol} alert";
    symbolController.text = widget.symbol;
  }

  void selectType({int index = 0}) {
    if (index == 0) {
      selectedOne = !selectedOne;
    } else if (index == 1) {
      selectedTwo = !selectedTwo;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeColors.bottomsheetGradient, Colors.black],
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color.fromARGB(255, 23, 23, 23),
        //     // ThemeColors.greyBorder,
        //     Color.fromARGB(255, 48, 48, 48),
        //   ],
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // insetPadding: widget.insetPadding,
        children: [
          _header(context),
          const SpacerVertical(height: 5),
          Text(
            "Select an alert type",
            style: stylePTSansBold(),
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30,
          ),
          _typeSelect(
            heading: "${widget.symbol} Sentiment Spike",
            description:
                "Alert if ${widget.symbol} news sentiment changes significantly.",
            onTap: () => selectType(index: 0),
            isSelected: selectedOne,
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30,
          ),
          _typeSelect(
            heading: "${widget.symbol} Mentions Spike",
            description: "Alert if ${widget.symbol} has a surge in mentions.",
            onTap: () => selectType(index: 1),
            isSelected: selectedTwo,
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30,
          ),
          Text(
            "Choose sentiment spike or mentions spike or both to receive email alerts and app notification for the selected stock.",
            style: stylePTSansRegular(fontSize: 12),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: const BoxDecoration(
                color: ThemeColors.greyBorder,
                border: Border(
                    left: BorderSide(color: ThemeColors.white, width: 3))),
            child: Text(
              "Note: Please be aware that you will receive an email and app notification only once a day, around 8:00 AM (EST), in the event of any spike.",
              style: stylePTSansRegular(fontSize: 12),
            ),
          ),
          Text(
            "In future if you don't want to receive any email and notification then remove stock added into alert section.",
            style: stylePTSansRegular(fontSize: 12),
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30,
          ),
          ThemeButton(
            color: selectedOne == false && selectedTwo == false
                ? ThemeColors.white
                : ThemeColors.accent,
            onPressed: selectedOne == false && selectedTwo == false
                ? () {
                    popUpAlert(
                        message: "Please select at least one alert type.",
                        title: "Alert",
                        icon: Images.alertPopGIF);
                  }
                : () => _showAlertPopup(context),
            text: "Add to Alert",
            textUppercase: true,
            textColor: selectedOne == false && selectedTwo == false
                ? ThemeColors.background
                : ThemeColors.white,
          ),
          const SpacerVertical(height: 10),
        ],
      ),
    );
    // return ThemeAlertDialog(
    //   insetPadding: widget.insetPadding,
    //   children: [
    //     _header(context),
    //     const SpacerVertical(height: 3),
    //     Text(
    //       "Select an alert type",
    //       style: stylePTSansBold(),
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     _typeSelect(
    //       heading: "${widget.symbol} Sentiment Spike",
    //       description:
    //           "Alert if ${widget.symbol} news sentiment changes significantly.",
    //       onTap: () => selectType(index: 0),
    //       isSelected: selectedOne,
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     _typeSelect(
    //       heading: "${widget.symbol} Mentions Spike",
    //       description: "Alert if ${widget.symbol} has a surge in mentions.",
    //       onTap: () => selectType(index: 1),
    //       isSelected: selectedTwo,
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     Text(
    //       "Choose sentiment spike or mentions spike or both to receive email alerts and app notification for the selected stock.",
    //       style: stylePTSansRegular(fontSize: 12),
    //     ),
    //     Container(
    //       margin: EdgeInsets.symmetric(vertical: 10.sp),
    //       padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
    //       decoration: const BoxDecoration(
    //           color: ThemeColors.greyBorder,
    //           border:
    //               Border(left: BorderSide(color: ThemeColors.white, width: 3))),
    //       child: Text(
    //         "Note: Please be aware that you will receive an email only once a day, around 8:00 AM (EST), in the event of any spike.",
    //         style: stylePTSansRegular(fontSize: 12),
    //       ),
    //     ),
    //     Text(
    //       "In future if you don't want to receive any email then delete stocks added into alert section.",
    //       style: stylePTSansRegular(fontSize: 12),
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     ThemeButton(
    //       color: ThemeColors.accent,
    //       onPressed: selectedOne == false && selectedTwo == false
    //           ? null
    //           : () => _showAlertPopup(context),
    //       text: "Continue",
    //       textColor: selectedOne == false && selectedTwo == false
    //           ? ThemeColors.background
    //           : ThemeColors.border,
    //     ),
    //     const SpacerVertical(height: 10),
    //   ],
    // );
  }

  void _showAlertPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SetupPopup(
            text: symbolController.text,
            onCreateAlert: _onCreateAlert,
            topTextField: ThemeInputField(
              controller: controller,
              placeholder: "Enter alert",
              // keyboardType: TextInputType.phone,
              inputFormatters: const [],
            ),
            bottomTextField: Text(
              symbolController.text,
              style: stylePTSansBold(),
            ),
            //  ThemeInputField(

            //   controller: symbolController,
            //   editable: false,
            // ),
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
        });
  }

  void _onCreateAlert() {
    TrendingProvider trendingProvider = context.read<TrendingProvider>();
    StockDetailProviderNew stockDetailProvider =
        context.read<StockDetailProviderNew>();
    TopTrendingProvider topTrendingProvider =
        context.read<TopTrendingProvider>();
    HomeProvider homeProvider = context.read<HomeProvider>();
    MoreStocksProvider moreStocksProvider = context.read<MoreStocksProvider>();
    FeaturedTickerProvider featuredTickerProvider =
        context.read<FeaturedTickerProvider>();

    if (widget.marketDataTopGainers) {
      context.read<TodayTopGainerProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataTopLosers) {
      context.read<TodayTopLoserProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataTodaysBreakOut) {
      context.read<TodayBreakoutStockProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataGapUp) {
      context.read<GapUpProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataGapDown) {
      context.read<GapDownProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataHighPe) {
      context.read<HighPeProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataLowPe) {
      context.read<LowPeProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataHighPeGrowth) {
      context.read<HighPeGrowthProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataLowPeGrowth) {
      context.read<LowPeGrowthProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataFiftyTwoHigh) {
      context.read<FiftyTwoWeeksHighProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataFiftyTwoLow) {
      context.read<FiftyTwoWeeksProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataHighBetaStocks) {
      context.read<HighBetaStocksProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataLowBetaStocks) {
      context.read<LowsBetaStocksProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataNegativeBetaStocks) {
      context.read<NegativeBetaStocksProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataDowStocks) {
      context.read<Dow30Provider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataSP500) {
      context.read<SnP500Provider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataIndices) {
      context.read<IndicesProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataLowPriceStocks) {
      context.read<LowPriceStocksProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataMostActiveStocks) {
      context.read<MostActiveProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataMostVolatile) {
      context.read<MostVolatileStocksProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataUnusualTradingVolume) {
      context.read<UnusualTradingVolumeProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataMostActivePenny) {
      context.read<MostActivePennyStocksProviders>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.marketDataMostPopularPenny) {
      context.read<MostPopularPennyStocksProviders>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataTopTodayPenny) {
      context.read<TopTodayPennyStocksProviders>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataDividends) {
      context.read<DividendsProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataEarning) {
      context.read<EarningsProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.marketDataStocks) {
      context.read<AllStocksProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    if (widget.sectorAndIndustry) {
      context.read<SectorIndustryProvider>().createAlertSend(
            index: widget.index,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.stocksAnalysisPeers) {
      context.read<StockDetailProviderNew>().createAlertSendPeer(
            type: "peer",
            symbol: widget.symbol,
            index: widget.index,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.competitorsDetail) {
      context.read<StockDetailProviderNew>().createAlertSendPeer(
            type: "compititor",
            symbol: widget.symbol,
            index: widget.index,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.sentimentShowTheLast) {
      context.read<RedditTwitterProvider>().createAlertSend(
            type: "ShowTheLast",
            symbol: widget.symbol,
            index: widget.index,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.sentimentRecent) {
      context.read<RedditTwitterProvider>().createAlertSend(
            type: "Recent",
            symbol: widget.symbol,
            index: widget.index,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }
    if (widget.congresionalImagesClick) {
      context.read<CongressionalDetailProvider>().createAlertSend(
            symbol: widget.symbol,
            index: widget.index,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
      return;
    }

    widget.fromTrending
        ? trendingProvider.createAlertSend(
            index: widget.index,
            up: widget.up,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          )
        : widget.fromStockDetail
            ? stockDetailProvider.createAlertSend(
                selectedOne: selectedOne,
                selectedTwo: selectedTwo,
                alertName: controller.text,
              )
            : widget.fromTopStock
                ? topTrendingProvider.createAlertSend(
                    alertName: controller.text,
                    symbol: widget.symbol,
                    index: widget.index,
                  )
                : widget.homeTrending
                    ? homeProvider.createAlertSend(
                        type: "homeTrending",
                        alertName: controller.text,
                        symbol: widget.symbol,
                        index: widget.index,
                      )
                    : widget.homeTopGainers
                        ? homeProvider.createAlertSend(
                            type: "homeTopGainers",
                            alertName: controller.text,
                            symbol: widget.symbol,
                            index: widget.index,
                          )
                        : widget.homeTopLosers
                            ? homeProvider.createAlertSend(
                                type: "homeTopLosers",
                                alertName: controller.text,
                                symbol: widget.symbol,
                                index: widget.index,
                              )
                            : widget.homeGainersAndLosers == StocksType.gainers
                                ? moreStocksProvider.createAlertSend(
                                    type: StocksType.gainers,
                                    alertName: controller.text,
                                    symbol: widget.symbol,
                                    index: widget.index,
                                  )
                                : widget.homeGainersAndLosers ==
                                        StocksType.losers
                                    ? moreStocksProvider.createAlertSend(
                                        type: StocksType.losers,
                                        alertName: controller.text,
                                        symbol: widget.symbol,
                                        index: widget.index,
                                      )
                                    : widget.homeGainersAndLosers ==
                                            StocksType.actives
                                        ? moreStocksProvider.createAlertSend(
                                            type: StocksType.actives,
                                            alertName: controller.text,
                                            symbol: widget.symbol,
                                            index: widget.index,
                                          )
                                        : widget.homeMostBoughtMembers
                                            ? homeProvider.createAlertSend(
                                                type: "homeMostBoughtMembers",
                                                alertName: controller.text,
                                                symbol: widget.symbol,
                                                index: widget.index,
                                              )
                                            : widget.homeFeatureStocks
                                                ? featuredTickerProvider
                                                    .createAlertSend(
                                                    alertName: controller.text,
                                                    symbol: widget.symbol,
                                                    index: widget.index,
                                                  )
                                                : null;
  }

  Widget _typeSelect({
    void Function()? onTap,
    bool isSelected = false,
    required String description,
    required String heading,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
            size: 35,
            color: isSelected ? ThemeColors.accent : ThemeColors.border,
          ),
          const SpacerHorizontal(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: stylePTSansBold(fontSize: 13),
                ),
                Text(
                  description,
                  style: stylePTSansRegular(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.add_alert_outlined,
                size: 20,
                color: ThemeColors.accent,
              ),
              const SpacerHorizontal(width: 5),
              Text(
                "Set New Alert for ${widget.symbol}",
                style: stylePTSansBold(color: ThemeColors.accent, fontSize: 18),
              ),
            ],
          ),
        ),
        // InkWell(
        //   onTap: () => Navigator.pop(context),
        //   child: Icon(Icons.close, size: 20.sp),
        // )
      ],
    );
  }
}
