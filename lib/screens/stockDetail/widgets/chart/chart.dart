import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/chart.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/chart/sd_chart_history_item.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_top.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../widgets/disclaimer_widget.dart';
import '../overview/chart.dart';

class SdCharts extends StatefulWidget {
  final String? symbol;
  const SdCharts({super.key, this.symbol});

  @override
  State<SdCharts> createState() => _SdChartsState();
}

class _SdChartsState extends State<SdCharts> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.chartRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context.read<StockDetailProviderNew>().getChartData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      hasData: !provider.isLoadingChart && provider.chartRes != null,
      isLoading: provider.isLoadingChart,
      showPreparingText: true,
      error: provider.errorChart,
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
                CustomGridView(
                  length: provider.chartRes?.top?.length ?? 0,
                  paddingVerticle: 8,
                  getChild: (index) {
                    SdTopRes? top = provider.chartRes?.top?[index];
                    return SdTopCard(
                      top: top,
                      textRed: "${top?.value ?? "N/A"}".contains('-'),
                      gridRed: "${top?.value ?? "N/A"}".contains('-'),
                    );
                  },
                ),
                // const SpacerVertical(height: 20),
                SdOverviewChart(
                  symbol: widget.symbol ?? "",
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
                ),
                Visibility(
                  visible:
                      provider.chartRes?.priceHistory?.isNotEmpty == true &&
                          provider.chartRes?.priceHistory != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(
                        title: "${widget.symbol} Share Price History",
                      ),
                      ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            PriceHistory? data =
                                provider.chartRes?.priceHistory?[index];

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
                                            "Date",
                                            style: stylePTSansRegular(
                                              fontSize: 12,
                                              color: ThemeColors.greyText,
                                            ),
                                          ),
                                          const SpacerHorizontal(width: 10),
                                          AutoSizeText(
                                            maxLines: 1,
                                            "Opening Price",
                                            style: stylePTSansRegular(
                                              fontSize: 12,
                                              color: ThemeColors.greyText,
                                            ),
                                          ),
                                          const SpacerHorizontal(width: 10),
                                          AutoSizeText(
                                            maxLines: 1,
                                            "Closing Price",
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
                                SdChartHistory(
                                  data: data,
                                  isOpen: provider.openIndex == index,
                                  onTap: () {
                                    provider.setOpenIndex(
                                      provider.openIndex == index ? -1 : index,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: ThemeColors.greyBorder,
                              height: 20.sp,
                            );
                          },
                          itemCount:
                              provider.chartRes?.priceHistory?.length ?? 0),
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
