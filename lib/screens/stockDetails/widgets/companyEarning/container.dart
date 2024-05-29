import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_other_detail_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stockTopWidgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stocksDetailSimmer/sd_company_earnings_sc_simmer.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';

import 'item.dart';

class CompanyEarningStockDetail extends StatefulWidget {
  final String symbol;
  final String? inAppMsgId;
  const CompanyEarningStockDetail(
      {super.key, required this.symbol, this.inAppMsgId});

  @override
  State<CompanyEarningStockDetail> createState() =>
      _CompanyEarningStockDetailState();
}

class _CompanyEarningStockDetailState extends State<CompanyEarningStockDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  _getData() {
    StockDetailProvider provider = context.read<StockDetailProvider>();
    if (provider.otherData == null) {
      provider.getStockOtherDetails(
        symbol: widget.symbol,
        inAppMsgId: widget.inAppMsgId,
      );
    }
  }

//
  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    Earning? earning = provider.otherData?.earning;

    // if (provider.otherLoading &&
    //     provider.otherData?.earning?.data?.isEmpty == true) {
    //   return Padding(
    //     padding: EdgeInsets.only(bottom: 20.sp),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const CircularProgressIndicator(
    //           color: ThemeColors.accent,
    //         ),
    //         const SpacerHorizontal(width: 5),
    //         Flexible(
    //           child: Text(
    //             "Fetching company earning data...",
    //             style: stylePTSansRegular(color: ThemeColors.accent),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    // if (!provider.otherLoading &&
    //     provider.otherData?.earning?.data?.isEmpty == true) {
    //   return const SizedBox();
    // }

    return BaseUiContainer(
      placeholder: const StocksDetailCompanyEarningsSimmer(),
      isLoading: provider.otherLoading,
      hasData: !provider.otherLoading && earning != null,
      error: provider.errorOther,
      showPreparingText: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.sp),
        child: RefreshIndicator(
          onRefresh: () async {
            provider.getStockOtherDetails(symbol: widget.symbol);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // ScreenTitle(
                //   // title: earning?.title ?? "",
                //   subTitle: earning?.text,
                // ),
                const CommonHeadingStockDetail(),
                Visibility(
                  visible: earning?.text != '',
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.sp),
                    child: Text(
                      earning?.text ?? "",
                      style: stylePTSansRegular(
                          fontSize: 13, color: ThemeColors.greyText),
                    ),
                  ),
                ),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Divider(
                            color: ThemeColors.greyBorder,
                            height: 15.sp,
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                maxLines: 1,
                                "QUARTER",
                                style: stylePTSansRegular(
                                  fontSize: 12,
                                  color: ThemeColors.greyText,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                          maxLines: 1,
                                          "EPS",
                                          textAlign: TextAlign.center,
                                          style: stylePTSansRegular(
                                            fontSize: 12,
                                            color: ThemeColors.greyText,
                                          )),
                                      AutoSizeText(
                                        maxLines: 1,
                                        "(% Change)",
                                        textAlign: TextAlign.center,
                                        style: stylePTSansRegular(
                                          fontSize: 12,
                                          color: ThemeColors.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        "REVENUE",
                                        style: stylePTSansRegular(
                                          fontSize: 12,
                                          color: ThemeColors.greyText,
                                        ),
                                      ),
                                      AutoSizeText(
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        "(% Change)",
                                        style: stylePTSansRegular(
                                          fontSize: 12,
                                          color: ThemeColors.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: ThemeColors.greyBorder,
                            height: 15.sp,
                            thickness: 1,
                          ),
                          // const SpacerVertical(height: 5),
                          CompanyEarningItem(index: index),
                        ],
                      );
                    }
                    return CompanyEarningItem(index: index);
                  },
                  separatorBuilder: (context, index) {
                    // return const SpacerVertical(height: 10);
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 20.sp,
                    );
                  },
                  itemCount: earning?.data?.length ?? 0,
                ),
                Divider(
                  color: ThemeColors.greyBorder,
                  height: 20.sp,
                ),

                // Container(
                //   height: 300,
                //   color: ThemeColors.greyBorder,
                //   width: double.infinity,
                //   child: BarChart(
                //     BarChartData(
                //       titlesData: FlTitlesData(
                //           leftTitles: AxisTitles(
                //             sideTitles: SideTitles(showTitles: false),
                //           ),
                //           bottomTitles: AxisTitles(
                //             sideTitles: SideTitles(
                //               showTitles: true,
                //               // getTextStyles: (context, value) => const TextStyle(
                //               //     color: Colors.black,
                //               //     fontWeight: FontWeight.bold,
                //               //     fontSize: 14),
                //             ),
                //           )),
                //       borderData: FlBorderData(show: false),
                //       barGroups:
                //           _createBarGroups(data: provider.otherData?.earning?.data),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
