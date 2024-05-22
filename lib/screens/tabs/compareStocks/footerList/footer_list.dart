import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/linear_bar.dart';

class FooterList extends StatefulWidget {
  const FooterList({super.key});

  @override
  State<FooterList> createState() => _FooterListState();
} //

class _FooterListState extends State<FooterList> {
  @override
  Widget build(BuildContext context) {
    List<CompareStockRes> company =
        context.watch<CompareStocksProvider>().company;
    return LayoutBuilder(
      builder: (context, constraints) {
        // return SizedBox(
        //   height: constraints.maxWidth * 1.5,
        //   child: ListView.separated(
        //       padding: EdgeInsets.symmetric(vertical: 10.sp),
        //       scrollDirection: Axis.horizontal,
        //       physics: const AlwaysScrollableScrollPhysics(),
        //       itemBuilder: (context, index) {
        //         if (index == 0) {
        //           return Row(
        //             children: [
        //               FittedBox(
        //                 alignment: Alignment.center,
        //                 fit: BoxFit.scaleDown,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     _rowHeading(title: "Symbol"),
        //                     _rowHeading(title: "Name"),
        //                     _rowHeading(title: "Price"),
        //                     _rowHeading(title: "Change Percentage"),
        //                     _rowHeading(title: "Change"),
        //                     _rowHeading(title: "Day Low"),
        //                     _rowHeading(title: "Day high"),
        //                     _rowHeading(title: "Year Low"),
        //                     _rowHeading(title: "year High"),
        //                     _rowHeading(title: "Market Cap"),
        //                     _rowHeading(title: "Price Avg. 50"),
        //                     _rowHeading(title: "Price Avg. 200"),
        //                     _rowHeading(title: "Exchange"),
        //                     _rowHeading(title: "Volume"),
        //                     _rowHeading(title: "Average Volume"),
        //                     _rowHeading(title: "Open"),
        //                     _rowHeading(title: "Previous Close"),
        //                     _rowHeading(title: "EPS"),
        //                     _rowHeading(title: "PE"),
        //                     _rowHeading(title: "Earnings Announcement"),
        //                     _rowHeading(title: "Shares Outstanding"),
        //                   ],
        //                 ),
        //               ),
        //               FittedBox(
        //                   alignment: Alignment.center,
        //                   fit: BoxFit.scaleDown,
        //                   child: FooterItem(
        //                     index: index,
        //                     company: company[index],
        //                   )),
        //             ],
        //           );
        //         }

        //         return FittedBox(
        //             alignment: Alignment.center,
        //             fit: BoxFit.scaleDown,
        //             child: FooterItem(
        //               index: index,
        //               company: company[index],
        //             ));
        //       },
        //       separatorBuilder: (context, index) {
        //         return const SpacerHorizontal(width: 0);
        //       },
        //       itemCount: company.length),
        // );

        return context.watch<CompareStocksProvider>().wholeListEmpty
            ? const SizedBox()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                      height: constraints.maxWidth * 0.4,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: ThemeColors.accent))),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // padding: EdgeInsets.only(top: 10.sp),
                        itemCount: company.length + 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0)
                                FittedBox(
                                  alignment: Alignment.center,
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _textItem(
                                          text: "Overall", showBorder: false),
                                      _textItem(
                                          text: "Fundamental",
                                          showBorder: false),
                                      _textItem(
                                          text: "Short-term Technical",
                                          showBorder: false),
                                      _textItem(
                                          text: "Long-term Technical",
                                          showBorder: false),
                                      _textItem(
                                          text: "Analyst Ranking",
                                          showBorder: false),
                                      _textItem(
                                          text: "Valuation", showBorder: false),
                                    ],
                                  ),
                                ),
                              if (index > 0 && index <= company.length)
                                FittedBox(
                                  alignment: Alignment.center,
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _barItem(
                                          value:
                                              company[index - 1].overallPercent,
                                          showBorder: false),
                                      _barItem(
                                          value: company[index - 1]
                                              .fundamentalPercent,
                                          showBorder: false),
                                      _barItem(
                                          value: company[index - 1]
                                              .shortTermPercent,
                                          showBorder: false),
                                      _barItem(
                                          value: company[index - 1]
                                              .longTermPercent,
                                          showBorder: false),
                                      _barItem(
                                          value: company[index - 1]
                                              .analystRankingPercent,
                                          showBorder: false),
                                      _barItem(
                                          value: company[index - 1]
                                              .valuationPercent,
                                          showBorder: false),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxWidth * 1.8,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 10.sp),
                        itemCount: company.length + 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0)
                                FittedBox(
                                  alignment: Alignment.center,
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _textItem(text: "Symbol"),
                                      _textItem(text: "Name"),
                                      _textItem(text: "Price"),
                                      _textItem(text: "Change Percentage"),
                                      _textItem(text: "Change"),
                                      _textItem(text: "Day Low"),
                                      _textItem(text: "Day High"),
                                      _textItem(text: "Day Low"),
                                      _textItem(text: "Day High"),
                                      _textItem(text: "Market Cap"),
                                      _textItem(text: "Price Avg 50"),
                                      _textItem(text: "Price Avg 200"),
                                      _textItem(text: "Exchange"),
                                      _textItem(text: "Volume"),
                                      _textItem(text: "Average Volume"),
                                      _textItem(text: "Open"),
                                      _textItem(text: "Previous Close"),
                                      _textItem(text: "EPS"),
                                      _textItem(text: "PE"),
                                      _textItem(text: "Earnings Announcement"),
                                      _textItem(text: "Shares Outstanding"),
                                    ],
                                  ),
                                ),
                              if (index > 0 && index <= company.length)
                                FittedBox(
                                  alignment: Alignment.center,
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _textItem(
                                          text: company[index - 1].symbol),
                                      _textItem(text: company[index - 1].name),
                                      _textItem(text: company[index - 1].price),
                                      _textItem(
                                          text:
                                              "${company[index - 1].changesPercentage.toCurrency()}%"),
                                      _textItem(
                                        text: company[index - 1]
                                            .changes
                                            .toCurrency(),
                                      ),
                                      _textItem(
                                          text: company[index - 1].dayLow),
                                      _textItem(
                                          text: company[index - 1].dayHigh),
                                      _textItem(
                                          text: company[index - 1].yearLow),
                                      _textItem(
                                          text: company[index - 1].yearHigh),
                                      _textItem(
                                          text: company[index - 1].mktCap),
                                      _textItem(
                                          text: company[index - 1].priceAvg50),
                                      _textItem(
                                          text: company[index - 1].priceAvg200),
                                      _textItem(
                                          text: company[index - 1].exchange),
                                      _textItem(
                                          text: company[index - 1].volume),
                                      _textItem(
                                          text: company[index - 1].avgVolume),
                                      _textItem(text: company[index - 1].open),
                                      _textItem(
                                          text:
                                              company[index - 1].previousClose),
                                      _textItem(
                                          text: "${company[index - 1].eps}"),
                                      _textItem(
                                          text: "${company[index - 1].pe}"),
                                      _textItem(
                                          text: company[index - 1]
                                              .earningsAnnouncement),
                                      _textItem(
                                          text: company[index - 1]
                                              .sharesOutstanding),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _textItem({required String text, bool showBorder = true}) {
    return Container(
      width: 150.sp,
      padding: EdgeInsets.fromLTRB(6.sp, 6.5.sp, 6.sp, 6.sp),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(
                  color: ThemeColors.greyBorder,
                ),
              )
            : null,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: stylePTSansBold(
          color: ThemeColors.white,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _barItem({required num value, bool showBorder = true}) {
    return Container(
      width: 150.sp,
      padding: EdgeInsets.fromLTRB(6.sp, 5.sp, 6.sp, 6.sp),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(
                  color: ThemeColors.greyBorder,
                ),
              )
            : null,
      ),
      child: LinearBarCommon(
        value: value,
      ),
    );
  }

  // Widget _rowHeading({required String title}) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return Container(
  //         width: 150.sp,
  //         padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
  //         decoration: const BoxDecoration(
  //           border: Border(
  //             bottom: BorderSide(
  //               color: ThemeColors.greyBorder,
  //             ),
  //           ),
  //         ),
  //         child: Text(
  //           title,
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //           style: stylePTSansBold(color: ThemeColors.greyText, fontSize: 12),
  //         ),
  //       );
  //     },
  //   );
  // }
}
