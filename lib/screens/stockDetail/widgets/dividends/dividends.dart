import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/dividends/dividend_overtime_charts.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/dividends/dividend_payment_barchart.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/dividends/sd_dividends_history.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_faq.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_top.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widgets/disclaimer_widget.dart';

class SdDividends extends StatefulWidget {
  final String? symbol;
  const SdDividends({super.key, this.symbol});

  @override
  State<SdDividends> createState() => _SdDividendsState();
}

class _SdDividendsState extends State<SdDividends> {
  int openIndex = -1;

  void changeOpenIndex(int index) {
    setState(() {
      openIndex = openIndex == index ? -1 : index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.dividends == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getDividendsData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      hasData: !provider.isLoadingDividends && provider.dividends != null,
      isLoading: provider.isLoadingDividends,
      showPreparingText: true,
      error: provider.errorDividends,
      isFull: true,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async => _callApi(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              children: [
                const SdCommonHeading(),
                const Divider(
                  color: ThemeColors.white,
                  thickness: 2,
                  height: 20,
                ),
                Visibility(
                  visible: provider.dividends?.dividendMessage == null,
                  child: Column(
                    children: [
                      CustomGridView(
                        length: provider.dividends?.top?.length ?? 0,
                        paddingVerticle: 8,
                        getChild: (index) {
                          SdTopRes? top = provider.dividends?.top?[index];
                          return SdTopCard(top: top);
                        },
                      ),
                      const SpacerVertical(height: 20),
                      // ListView.builder(
                      //   padding: const EdgeInsets.only(top: 0, bottom: 20),
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemBuilder: (BuildContext context, int index) {
                      //     DividendCharts? data = provider.dividends?.chartInfo?[index];
                      //     return  DividendOvertimeCharts(data: data,);
                      //   },
                      // ),
                      const SpacerVertical(height: 20),
                      DividendPaymentBarchart(),
                      const SpacerVertical(height: 20),
                      Visibility(
                        visible:
                            provider.dividends?.dividendHistory?.isNotEmpty ==
                                    true &&
                                provider.dividends?.dividendHistory != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ScreenTitle(
                              title:
                                  "${widget.symbol} Dividend History by Quarter",
                            ),
                            ListView.separated(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 20),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  DividendHistory? data = provider
                                      .dividends?.dividendHistory?[index];
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (index == 0)
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  maxLines: 1,
                                                  "Announced",
                                                  style: stylePTSansRegular(
                                                    fontSize: 12,
                                                    color: ThemeColors.greyText,
                                                  ),
                                                ),
                                                const SpacerHorizontal(
                                                    width: 10),
                                                AutoSizeText(
                                                  maxLines: 1,
                                                  "Amount",
                                                  style: stylePTSansRegular(
                                                    fontSize: 12,
                                                    color: ThemeColors.greyText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: ThemeColors.greyBorder,
                                              height: 20.sp,
                                              thickness: 1,
                                            )
                                          ],
                                        ),
                                      SdDividendsHistory(
                                        data: data,
                                        isOpen: provider.openIndex == index,
                                        onTap: () {
                                          provider.setOpenIndex(
                                            provider.openIndex == index
                                                ? -1
                                                : index,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    color: ThemeColors.greyBorder,
                                    height: 20.sp,
                                  );
                                },
                                itemCount: provider
                                        .dividends?.dividendHistory?.length ??
                                    0),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: provider.dividends?.faq?.isNotEmpty == true &&
                            provider.dividends?.faq != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ScreenTitle(
                              title:
                                  "${provider.tabRes?.keyStats?.name} Dividend - FAQs",
                            ),
                            ListView.separated(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 20),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  FaQsRes? data =
                                      provider.dividends?.faq?[index];
                                  return SdFaqCard(
                                    data: data,
                                    index: index,
                                    openIndex: openIndex,
                                    onCardTapped: changeOpenIndex,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SpacerVertical(height: 10);
                                },
                                itemCount: provider.dividends?.faq?.length ?? 0)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: provider.dividends?.dividendMessage != null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "${provider.dividends?.dividendMessage}",
                      style: stylePTSansRegular(color: ThemeColors.greyText),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (provider.extra?.disclaimer != null)
                  DisclaimerWidget(data: provider.extra!.disclaimer!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
