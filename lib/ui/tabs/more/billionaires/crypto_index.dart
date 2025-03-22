import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_detail_res.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/base/ticker_app_bar.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_chart.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_info_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/mention_list.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/search_tiles.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

class CryptoIndex extends StatefulWidget {
  final String symbol;
  final String? currency;

  static const path = 'CryptoIndex';
  const CryptoIndex({super.key, required this.symbol, this.currency});

  @override
  State<CryptoIndex> createState() => _CryptoIndexState();
}

class _CryptoIndexState extends State<CryptoIndex> {
  final TextEditingController symbolController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    BillionairesManager manager = context.read<BillionairesManager>();
    manager.clearValues();
    manager.getCryptoDetail(widget.symbol, currency: widget.currency);
    manager.getCrHistoricalC(
        symbol: widget.symbol, reset: true, currency: widget.currency);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    CryptoData? cryptoRates = manager.cryptoDetailRes?.cryptoData;
    bool hasData = manager.dataHistoricalC != null;
    return BaseScaffold(
        appBar: BaseTickerAppBar(
          data: tickerDetail,
        ),
        body: BaseLoaderContainer(
          isLoading: manager.isLoadingCDetail,
          hasData: manager.cryptoDetailRes != null && !manager.isLoadingCDetail,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child: BaseScroll(
              onRefresh: () async {
                manager.getCryptoDetail(widget.symbol,
                    currency: widget.currency);
                manager.getCrHistoricalC(
                    symbol: widget.symbol, currency: widget.currency);
              },
              margin: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Pad.pad16, vertical: Pad.pad10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            tickerDetail?.displayPrice ?? '',
                            style: styleBaseBold(fontSize: 28),
                          ),
                          SpacerHorizontal(width: Pad.pad10),
                          Expanded(
                            child: Visibility(
                              visible: tickerDetail?.displayChange != null,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    if (tickerDetail?.changesPercentage != null)
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Image.asset(
                                            (tickerDetail?.changesPercentage ??
                                                        0) >=
                                                    0
                                                ? Images.trendingUP
                                                : Images.trendingDOWN,
                                            height: 18,
                                            width: 18,
                                            color: (tickerDetail
                                                            ?.changesPercentage ??
                                                        0) >=
                                                    0
                                                ? ThemeColors.accent
                                                : ThemeColors.sos,
                                          ),
                                        ),
                                      ),
                                    TextSpan(
                                      text: tickerDetail?.displayChange,
                                      style: styleBaseSemiBold(
                                          fontSize: 13,
                                          color: (tickerDetail
                                                          ?.changesPercentage ??
                                                      0) >=
                                                  0
                                              ? ThemeColors.accent
                                              : ThemeColors.sos,
                                          fontFamily: "Roboto"),
                                    ),
                                    if (tickerDetail?.changesPercentage != null)
                                      TextSpan(
                                        text:
                                            ' (${tickerDetail?.changesPercentage}%)',
                                        style: styleBaseSemiBold(
                                          fontSize: 13,
                                          color: (tickerDetail
                                                          ?.changesPercentage ??
                                                      0) >=
                                                  0
                                              ? ThemeColors.accent
                                              : ThemeColors.sos,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IntrinsicWidth(
                            child: BaseButton(
                              fullWidth: false,
                              color: tickerDetail?.isCryptoAdded == 0
                                  ? ThemeColors.transparentGreen
                                  : ThemeColors.transparentRed,
                              onPressed: () {
                                if (tickerDetail?.isCryptoAdded == 0) {
                                  manager.requestAddToWatch(widget.symbol,
                                      cryptos: tickerDetail);
                                } else {
                                  manager.requestRemoveToWatch(widget.symbol,
                                      cryptos: tickerDetail);
                                }
                              },
                              text: tickerDetail?.isCryptoAdded == 0
                                  ? "FOLLOW"
                                  : "UNFOLLOW",
                              textSize: 14,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ],
                      ),
                      SpacerVertical(height: Pad.pad10),
                      HtmlWidget(
                        tickerDetail?.brief ?? '',
                        textStyle: styleBaseRegular(height: 1.6, fontSize: 14),
                      ),
                      SpacerVertical(height: Pad.pad16),
                    ],
                  ),
                ),
                SpacerVertical(height: Pad.pad10),
                CryptoChart(
                  hasData: hasData,
                  chart: manager.dataHistoricalC,
                  error: manager.errorHistoricalC,
                  onTap: (p0) {
                    manager.getCrHistoricalC(range: p0, symbol: widget.symbol);
                  },
                ),
                SpacerVertical(height: Pad.pad20),
                Visibility(
                  visible:
                      cryptoRates?.title != null && cryptoRates?.title != '',
                  child: BaseHeading(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    title: cryptoRates?.title ?? "",
                    titleStyle: styleBaseBold(),
                  ),
                ),
                SpacerVertical(height: Pad.pad10),
                manager.isSwapped ? currencySection() : symbolSection(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.swap_horizontal_circle_rounded, size: 24),
                      onPressed: () {
                        manager.swapUI();
                      },
                    ),
                    Text(
                      "1 ${manager.selectedSymbol?.symbol ?? ""} = ${manager.selectedItem?.symbol ?? ""} ${((manager.selectedSymbol?.price ?? 0) * (manager.selectedItem?.price ?? 0))} ${manager.selectedItem?.currency ?? ""}",
                      style: styleBaseBold(fontFamily: "Roboto"),
                    )
                  ],
                ),
                manager.isSwapped ? symbolSection() : currencySection(),
                SpacerVertical(height: Pad.pad20),
                BaseButton(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  onPressed: () {
                    manager.getCrHistoricalC(
                        symbol: manager.selectedSymbol?.symbol ?? "",
                        reset: true,
                        currency: manager.selectedItem?.currency ?? "");
                    manager.getCryptoDetail(
                        manager.selectedSymbol?.symbol ?? "",
                        currency: manager.selectedItem?.currency ?? "");
                  },
                  text: "Converter",
                  textSize: 16,
                  fontBold: true,
                  fullWidth: false,
                ),
                SpacerVertical(height: Pad.pad10),
                Visibility(
                  visible: pricePerformance != null,
                  child: CryptoInfoItem(dataRes: pricePerformance),
                ),
                Visibility(
                  visible: marketCap != null,
                  child: CryptoInfoItem(dataRes: marketCap),
                ),
                Visibility(
                  visible: tradingVolume != null,
                  child: CryptoInfoItem(dataRes: tradingVolume),
                ),
                Visibility(
                  visible: supply != null,
                  child: CryptoInfoItem(dataRes: supply),
                ),
                Visibility(
                    visible: recentTweetPost?.title != null &&
                        recentTweetPost?.title != '',
                    child: SpacerVertical(height: 20)),
                Visibility(
                    visible: recentTweetPost?.title != null &&
                        recentTweetPost?.title != '',
                    child: BaseHeading(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: recentTweetPost?.title ?? "",
                      titleStyle: styleBaseBold(),
                    )),
                Visibility(
                    visible: recentTweetPost?.data != null,
                    child: SpacerVertical(height: 10)),
                Visibility(
                  visible: recentTweetPost?.data != null,
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CryptoTweetPost? item = recentTweetPost?.data?[index];
                      return CryptoItem(
                        item: item,
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SpacerVertical(height: 20);
                    },
                    itemCount: recentTweetPost?.data?.length ?? 0,
                  ),
                ),
                Visibility(
                    visible: recentTweetPost?.data != null,
                    child: SpacerVertical(height: Pad.pad10)),
                Visibility(
                    visible: bitcoinRes != null,
                    child: MentionsListIndex(symbolMentionRes: bitcoinRes)),
                SpacerVertical(height: Pad.pad10),
              ]),
        ));
  }

  Widget symbolSection() {
    BillionairesManager manager = context.watch<BillionairesManager>();
    CryptoData? cryptoRates = manager.cryptoDetailRes?.cryptoData;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: ThemeColors.neutral5),
      child: Row(
        children: [
          Expanded(
            child: ThemeInputField(
                cursorColor: ThemeColors.black,
                fillColor: ThemeColors.white,
                borderColor: ThemeColors.white,
                controller: manager.btcController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: styleBaseBold(),
                onChanged: (value) {
                  manager.isActiveChange(1);
                  manager.calculateConversion();
                },
                suffix: InkWell(
                    onTap: () {
                      manager.btcController.text = "0.00";
                      manager.usdController.text = "0.00";
                      setState(() {});
                    },
                    child: Image.asset(Images.x,
                        width: 14, height: 14, color: ThemeColors.black))),
          ),
          SpacerHorizontal(width: Pad.pad5),
          Expanded(
            child: InkWell(
              onTap: () {
                manager.searchSymbol = [];
                showSymbol(context);
              },
              child: AbsorbPointer(
                child: ThemeInputField(
                  placeholder: cryptoRates?.cryptoSymbol
                              ?.contains(manager.selectedSymbol) ==
                          true
                      ? manager.selectedSymbol?.symbol
                      : manager.searchSymbol.contains(manager.selectedSymbol) ==
                              true
                          ? manager.selectedSymbol?.symbol
                          : "",
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    size: 23,
                    color: ThemeColors.black,
                  ),
                  hintStyle: styleBaseRegular(color: ThemeColors.black),
                  editable: false,
                  contentPadding: EdgeInsets.only(left: 10, top: 12.sp),
                  cursorColor: ThemeColors.black,
                  fillColor: ThemeColors.white,
                  borderColor: ThemeColors.white,
                  controller: symbolController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget currencySection() {
    BillionairesManager manager = context.watch<BillionairesManager>();
    CryptoData? cryptoRates = manager.cryptoDetailRes?.cryptoData;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: ThemeColors.neutral5),
      child: Row(
        children: [
          Expanded(
            child: ThemeInputField(
              cursorColor: ThemeColors.black,
              fillColor: ThemeColors.white,
              borderColor: ThemeColors.white,
              controller: manager.usdController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: styleBaseBold(),
              onChanged: (value) {
                manager.isActiveChange(2);
                manager.calculateWithPriceChange();
              },
              suffix: InkWell(
                  onTap: () {
                    manager.btcController.text = "0.00";
                    manager.usdController.text = "0.00";
                    setState(() {});
                  },
                  child: Image.asset(Images.x,
                      width: 14, height: 14, color: ThemeColors.black)),
            ),
          ),
          SpacerHorizontal(width: Pad.pad5),
          Expanded(
            child: InkWell(
              onTap: () {
                manager.searchCurrency = [];
                showCurrency(context);
              },
              child: AbsorbPointer(
                child: ThemeInputField(
                  placeholder:
                      cryptoRates?.rates?.contains(manager.selectedItem) == true
                          ? manager.selectedItem?.currency
                          : manager.searchCurrency
                                      .contains(manager.selectedItem) ==
                                  true
                              ? manager.selectedItem?.currency
                              : "",
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    size: 23,
                    color: ThemeColors.black,
                  ),
                  hintStyle: styleBaseRegular(color: ThemeColors.black),
                  editable: false,
                  contentPadding: EdgeInsets.only(left: 10, top: 12.sp),
                  cursorColor: ThemeColors.black,
                  fillColor: ThemeColors.white,
                  borderColor: ThemeColors.white,
                  controller: searchController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSymbol(BuildContext context) {
    BaseBottomSheet().bottomSheet(
        barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
        child: Builder(builder: (context) {
          BillionairesManager manager = context.watch<BillionairesManager>();
          CryptoData? cryptoRates = manager.cryptoDetailRes?.cryptoData;
          TextEditingController searchController = TextEditingController();
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                BaseHeading(
                  title: "Select Symbol",
                  titleStyle: styleBaseBold(),
                ),
                SpacerVertical(height: 10),
                BaseTextField(
                  placeholder: "Search",
                  controller: searchController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  onChanged: (values) {
                    if (_timer != null) {
                      _timer!.cancel();
                    }
                    _timer = Timer(
                      const Duration(milliseconds: 1000),
                      () {
                        manager.getSearchOfSymbol(values);
                      },
                    );
                  },
                ),
                SpacerVertical(height: Pad.pad10),
                Expanded(
                  child: manager.searchSymbol.isNotEmpty
                      ? ListView.builder(
                          itemCount: manager.searchSymbol.length,
                          itemBuilder: (context, index) {
                            Rate item = manager.searchSymbol[index];
                            return SearchTiles(
                              item: item,
                              onTap: () {
                                setState(() {
                                  manager.selectedSymbol = item;
                                });
                                Navigator.pop(context);
                                if (manager.isActiveField == 1) {
                                  manager.calculateConversion();
                                } else {
                                  manager.calculateWithPriceChange();
                                }
                              },
                              fromTo: 1,
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: cryptoRates?.cryptoSymbol?.length,
                          itemBuilder: (context, index) {
                            Rate? item = cryptoRates?.cryptoSymbol?[index];
                            return SearchTiles(
                              item: item,
                              onTap: () {
                                setState(() {
                                  manager.selectedSymbol = item;
                                });
                                Navigator.pop(context);
                                if (manager.isActiveField == 1) {
                                  manager.calculateConversion();
                                } else {
                                  manager.calculateWithPriceChange();
                                }
                              },
                              fromTo: 1,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }));
  }

  void showCurrency(BuildContext context) {
    BaseBottomSheet().bottomSheet(
        barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
        child: Builder(builder: (context) {
          BillionairesManager manager = context.watch<BillionairesManager>();
          CryptoData? cryptoRates = manager.cryptoDetailRes?.cryptoData;
          TextEditingController searchController = TextEditingController();
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                BaseHeading(
                  title: "Select Currency",
                  titleStyle: styleBaseBold(),
                ),
                SpacerVertical(height: 10),
                BaseTextField(
                  placeholder: "Search",
                  controller: searchController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  onChanged: (values) {
                    if (_timer != null) {
                      _timer!.cancel();
                    }
                    _timer = Timer(
                      const Duration(milliseconds: 1000),
                      () {
                        manager.getSearchOfCurrency(values);
                      },
                    );
                  },
                ),
                SpacerVertical(height: Pad.pad10),
                Expanded(
                  child: manager.searchCurrency.isNotEmpty
                      ? ListView.builder(
                          itemCount: manager.searchCurrency.length,
                          itemBuilder: (context, index) {
                            Rate item = manager.searchCurrency[index];
                            return SearchTiles(
                              item: item,
                              onTap: () {
                                setState(() {
                                  manager.selectedItem = item;
                                });
                                Navigator.pop(context);
                                if (manager.isActiveField == 1) {
                                  manager.calculateConversion();
                                } else {
                                  manager.calculateWithPriceChange();
                                }
                              },
                              fromTo: 2,
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: cryptoRates?.rates?.length,
                          itemBuilder: (context, index) {
                            Rate? item = cryptoRates?.rates?[index];
                            return SearchTiles(
                              item: item,
                              onTap: () {
                                setState(() {
                                  manager.selectedItem = item;
                                });
                                Navigator.pop(context);
                                if (manager.isActiveField == 1) {
                                  manager.calculateConversion();
                                } else {
                                  manager.calculateWithPriceChange();
                                }
                              },
                              fromTo: 2,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }));
  }
}
