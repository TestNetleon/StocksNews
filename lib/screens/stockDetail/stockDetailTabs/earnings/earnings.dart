import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/earnings/earning_history_item.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/earnings/eps_estimates_item.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/sd_faq.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/sd_top.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdEarnings extends StatefulWidget {
  final String? symbol;
  const SdEarnings({super.key, this.symbol});

  @override
  State<SdEarnings> createState() => _SdEarningsState();
}

class _SdEarningsState extends State<SdEarnings> {
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
      if (provider.earnings == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getEarningsData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingEarning && provider.earnings != null,
      isLoading: provider.isLoadingEarning,
      showPreparingText: true,
      error: provider.errorEarning,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          _callApi();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SdCommonHeading(),
                const Divider(
                  color: ThemeColors.white,
                  thickness: 2,
                  height: 20,
                ),
                CustomGridView(
                  length: provider.earnings?.top?.length ?? 0,
                  paddingVertical: 8,
                  getChild: (index) {
                    SdTopRes? top = provider.earnings?.top?[index];
                    return SdTopCard(
                      top: top,
                      textRed: "${top?.value ?? "N/A"}".contains('-'),
                      gridRed: "${top?.value ?? "N/A"}".contains('-'),
                    );
                  },
                ),
                const SpacerVertical(height: 20),
                // ScreenTitle(
                //   title:
                //       "${provider.tabRes?.keyStats?.name} Analyst EPS Estimates",
                // ),
                // const SpacerVertical(height: 10),
                // const EarningsAnalystEstimateLineChart(),
                // const SpacerVertical(height: 20),
                Visibility(
                  visible:
                      provider.earnings?.epsEstimates?.isNotEmpty == true &&
                          provider.earnings?.epsEstimates != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(
                        title:
                            "${provider.tabRes?.keyStats?.name} Analyst EPS Estimates",
                      ),
                      ListView.separated(
                        padding: const EdgeInsets.only(top: 0, bottom: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          EpsEstimate? data =
                              provider.earnings?.epsEstimates?[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (index == 0)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          maxLines: 1,
                                          "Quarter",
                                          style: stylePTSansRegular(
                                            fontSize: 12,
                                            color: ThemeColors.greyText,
                                          ),
                                        ),
                                        const SpacerHorizontal(width: 10),
                                        AutoSizeText(
                                          maxLines: 1,
                                          "Number of Estimates",
                                          style: stylePTSansRegular(
                                            fontSize: 12,
                                            color: ThemeColors.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: ThemeColors.greyBorder,
                                      height: 20,
                                      thickness: 1,
                                    )
                                  ],
                                ),
                              EpsEstimatesItem(
                                data: data,
                                isOpen: provider.openIndex == index,
                                onTap: () {
                                  provider.setOpenIndex(
                                    provider.openIndex == index ? -1 : index,
                                  );
                                  provider.setOpenIndexEarningHistory(
                                    -1,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: ThemeColors.greyBorder,
                            height: 20,
                          );
                        },
                        itemCount: provider.earnings?.epsEstimates?.length ?? 0,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      provider.earnings?.earningHistory?.isNotEmpty == true &&
                          provider.earnings?.earningHistory != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(
                        title:
                            "${provider.tabRes?.keyStats?.name} Earnings History by Quarter",
                      ),
                      ListView.separated(
                          padding: const EdgeInsets.only(top: 0, bottom: 20),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            EarningHistory? data =
                                provider.earnings?.earningHistory?[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (index == 0)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            maxLines: 1,
                                            "Quarter",
                                            style: stylePTSansRegular(
                                              fontSize: 12,
                                              color: ThemeColors.greyText,
                                            ),
                                          ),
                                          const SpacerHorizontal(width: 10),
                                          AutoSizeText(
                                            maxLines: 1,
                                            "Reported EPS",
                                            style: stylePTSansRegular(
                                              fontSize: 12,
                                              color: ThemeColors.greyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: ThemeColors.greyBorder,
                                        height: 20,
                                        thickness: 1,
                                      )
                                    ],
                                  ),
                                EarningHistoryItem(
                                  data: data,
                                  isOpen:
                                      provider.openIndexEarningHistory == index,
                                  onTap: () {
                                    provider.setOpenIndexEarningHistory(
                                      provider.openIndexEarningHistory == index
                                          ? -1
                                          : index,
                                    );
                                    provider.setOpenIndex(
                                      -1,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: ThemeColors.greyBorder,
                              height: 20,
                            );
                          },
                          itemCount:
                              provider.earnings?.earningHistory?.length ?? 0),
                    ],
                  ),
                ),
                Visibility(
                  visible: provider.earnings?.faq?.isNotEmpty == true &&
                      provider.earnings?.faq != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(
                        title:
                            "${provider.tabRes?.keyStats?.name} Earnings - FAQs",
                      ),
                      ListView.separated(
                        padding: const EdgeInsets.only(top: 0, bottom: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          FaQsRes? data = provider.earnings?.faq?[index];
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
                        itemCount: provider.earnings?.faq?.length ?? 0,
                      ),
                    ],
                  ),
                ),
                if (provider.extra?.disclaimer != null)
                  DisclaimerWidget(
                    data: provider.extra!.disclaimer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
