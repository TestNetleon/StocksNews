import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/models/crypto_detail_res.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/color_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/ticker_app_bar.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_table.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_chart.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_info_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CryptoIndex extends StatefulWidget {
  final String symbol;
  static const path = 'CryptoIndex';
  const CryptoIndex({super.key, required this.symbol});

  @override
  State<CryptoIndex> createState() => _CryptoIndexState();
}

class _CryptoIndexState extends State<CryptoIndex> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    BillionairesManager manager = context.read<BillionairesManager>();
    manager.getCryptoDetail(widget.symbol);
    manager.getCrHistoricalC(symbol: widget.symbol);
  }


  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    BaseTickerRes? tickerDetail = manager.cryptoDetailRes?.cryptoInfo;
    RecentTweetPost? recentTweetPost = manager.cryptoDetailRes?.recentTweetPost;
    SymbolMentionList? bitcoinRes = manager.cryptoDetailRes?.symbolMentionList;
    DataRes? pricePerformance = manager.cryptoDetailRes?.pricePerformance;
    DataRes? marketCap = manager.cryptoDetailRes?.marketCap;
    DataRes? tradingVolume = manager.cryptoDetailRes?.tradingVolume;
    DataRes? supply = manager.cryptoDetailRes?.supply;
    bool hasData = manager.dataHistoricalC != null;
    return BaseScaffold(
        appBar: BaseTickerAppBar(
          data: tickerDetail,
        ),
        body: BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.cryptoDetailRes != null && !manager.isLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child: BaseScroll(
              onRefresh: () async {
                manager.getCryptoDetail(widget.symbol);
              },
              margin: EdgeInsets.zero,
              children: [
                BaseColorContainer(
                  bgColor: ThemeColors.neutral9,
                  radius: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(

                        children: [
                          Text(
                            tickerDetail?.price?.toFormattedPriceForSim() ?? '',
                            style: styleBaseBold(fontSize: 28),
                          ),
                          SpacerHorizontal(width: Pad.pad10),
                          Visibility(
                            visible: tickerDetail?.change != null,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  if (tickerDetail?.changesPercentage != null)
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 4),
                                        child: Image.asset(
                                          (tickerDetail?.changesPercentage ?? 0) >= 0
                                              ? Images.trendingUP
                                              : Images.trendingDOWN,
                                          height: 18,
                                          width: 18,
                                          color: (tickerDetail?.changesPercentage ?? 0) >= 0
                                              ? ThemeColors.accent
                                              : ThemeColors.sos,
                                        ),
                                      ),
                                    ),
                                  TextSpan(
                                    text: tickerDetail?.displayChange,
                                    style: styleBaseSemiBold(
                                      fontSize: 13,
                                      color: (tickerDetail?.changesPercentage ?? 0) >= 0
                                          ? ThemeColors.accent
                                          : ThemeColors.sos,
                                    ),
                                  ),
                                  if (tickerDetail?.changesPercentage != null)
                                    TextSpan(
                                      text: ' (${tickerDetail?.changesPercentage}%)',
                                      style: styleBaseSemiBold(
                                        fontSize: 13,
                                        color: (tickerDetail?.changesPercentage ?? 0) >= 0
                                            ? ThemeColors.accent
                                            : ThemeColors.sos,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SpacerVertical(height: Pad.pad16),
                      HtmlWidget(
                        tickerDetail?.brief ?? '',
                        textStyle: styleBaseRegular(height: 1.6,fontSize: 14),
                      ),
                      SpacerVertical(height: Pad.pad16),
                      Row(
                        children: [
                          IntrinsicWidth(
                            child: BaseButton(
                              fullWidth: false,
                              color: tickerDetail?.isCryptoAdded==0?ThemeColors.white:ThemeColors.splashBG,
                              onPressed: (){
                                if(tickerDetail?.isCryptoAdded==0){
                                  manager.requestAddToWatch(widget.symbol);
                                }
                                else{
                                  manager.requestRemoveToWatch(widget.symbol);
                                }

                              },
                              text: "ADD TO LIST",
                              textStyle:stylePTSansRegular(fontSize: 12,color: tickerDetail?.isCryptoAdded==0?ThemeColors.primaryLight:ThemeColors.white,fontWeight: FontWeight.w600),
                              icon: Images.ic_fav,
                              iconColor:  tickerDetail?.isCryptoAdded==0?ThemeColors.primaryLight:ThemeColors.white,


                            ),
                          ),
                          SpacerHorizontal(width: Pad.pad24),
                          IntrinsicWidth(
                            child: BaseButton(
                              fullWidth: false,
                              color: ThemeColors.white,
                              onPressed: (){
                              },
                              text: "WEBSITE",
                              textStyle:stylePTSansRegular(fontSize: 12,color: ThemeColors.primaryLight,fontWeight: FontWeight.w600),
                              icon: Images.ic_link,

                            ),
                          ),
                        ],
                      ),
                      SpacerVertical(height: Pad.pad16),

                    ],
                  ),

                ),
                SpacerVertical(height: Pad.pad16),
                CryptoChart(
                  hasData: hasData,
                  chart: manager.dataHistoricalC,
                  error: manager.errorHistoricalC,
                  onTap: (p0) {
                    manager.getCrHistoricalC(range: p0,symbol: widget.symbol);
                  },
                ),
                SpacerVertical(height: Pad.pad10),

                Visibility(
                  visible: pricePerformance!=null,
                  child: CryptoInfoItem(
                      dataRes:pricePerformance
                  ),
                ),

                Visibility(
                  visible: marketCap!=null,
                  child: CryptoInfoItem(
                      dataRes:marketCap
                  ),
                ),
                Visibility(
                  visible: tradingVolume!=null,
                  child: CryptoInfoItem(
                      dataRes:tradingVolume
                  ),
                ),

                Visibility(
                  visible: supply!=null,
                  child: CryptoInfoItem(
                      dataRes:supply
                  ),
                ),

                SpacerVertical(height: Pad.pad10),
                Visibility(
                    visible: recentTweetPost?.title != null && recentTweetPost?.title!= '',
                    child: BaseHeading(
                      title: recentTweetPost?.title??"",
                      titleStyle: stylePTSansBold(fontSize: 24,color: ThemeColors.splashBG),
                      margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

                    )
                ),
                SpacerVertical(height: Pad.pad5),
                Visibility(
                  visible: recentTweetPost?.data != null,
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: Pad.pad8),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CryptoTweetPost? item = recentTweetPost?.data?[index];
                      return CryptoItem(
                        item: item,
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SpacerVertical(height: Pad.pad3);
                    },
                    itemCount: recentTweetPost?.data?.length ?? 0,
                  ),
                ),
                SpacerVertical(height: Pad.pad10),
                CryptoTable(
                    symbolMentionRes:bitcoinRes,
                  fromTo: 1,
                )
              ]
          ),
        )
    );
  }
}
