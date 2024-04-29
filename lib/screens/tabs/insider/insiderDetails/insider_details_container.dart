import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/insider_trading_res.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/screens/tabs/insider/graph/graph.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

import 'insider_details.dart';

//
class InsiderCompanyContainer extends StatelessWidget {
  final String? companySlug;
  const InsiderCompanyContainer({super.key, this.companySlug});

  @override
  Widget build(BuildContext context) {
    InsiderTradingDetailsProvider provider =
        context.watch<InsiderTradingDetailsProvider>();
    return BaseUiContainer(
        isLoading: provider.isLoading,
        hasData: provider.companyData != null,
        error: provider.error,
        errorDispCommon: true,
        onRefresh: () {
          provider.getData(
            showProgress: true,
            companySlug: companySlug ?? "",
          );
          provider.insiderGraphData(
            companySlug: companySlug ?? "",
          );
        },
        child: RefreshControll(
          onRefresh: () async {
            provider.getData(
              showProgress: true,
              companySlug: companySlug ?? "",
            );
            provider.insiderGraphData(
              companySlug: companySlug ?? "",
            );
          },
          canLoadmore: provider.canLoadMoreCompany,
          onLoadMore: () => provider.getData(
            loadMore: true,
            companySlug: companySlug ?? "",
            clear: false,
          ),
          child: ListView.separated(
              padding: EdgeInsets.only(bottom: Dimen.padding.sp),
              itemBuilder: (context, index) {
                InsiderTradingData? data = provider.companyData?.data[index];

                if (index == 0) {
                  return Column(
                    children: [
                      provider.isGraphLoading
                          ? const CircularProgressIndicator(
                              color: ThemeColors.accent,
                            )
                          : const InsiderDetailGraph(),
                      Divider(
                        color: ThemeColors.greyBorder,
                        height: 15.sp,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: AutoSizeText(
                              maxLines: 1,
                              "INSIDER NAME",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          ),
                          const SpacerHorizontal(width: 10),
                          // Expanded(
                          //   flex: 2,
                          //   child: Text(
                          //     "SHARES BOUGHT/SOLD",
                          //     style: stylePTSansRegular(
                          //       fontSize: 12,
                          //       color: ThemeColors.greyText,
                          //     ),
                          //   ),
                          // ),
                          // const SpacerHorizontal(width: 10),
                          Expanded(
                            child: AutoSizeText(
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              "BUY/SELL",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: ThemeColors.greyBorder,
                        height: 15.sp,
                        thickness: 1,
                      ),
                      InsidersDetailsItem(
                        symbol: data?.symbol ?? '',
                        leading: data?.reportingName,
                        trailing: data?.transactionType,
                        index: index,
                        isOpen: provider.indexCompany == index,
                        leadingSubtitle: data?.typeOfOwner,
                        leadingClick: () {
                          Navigator.pushNamed(context, InsiderDetailsType.path,
                              arguments: {
                                "companySlug": data?.companySlug,
                                "reportingSlug": data?.reportingSlug,
                                "companyName": data?.companyName,
                                "reportingName": data?.reportingName,
                              });
                        },
                        onTap: () => provider.change(
                            provider.indexCompany == index ? -1 : index, true),
                        children: [
                          InnerRowItem(
                            lable: "Shares Bought/Sold",
                            value: "${data?.securitiesTransacted}",
                          ),
                          InnerRowItem(
                            lable: "Total Transaction",
                            value: data?.totalTransaction,
                          ),
                          InnerRowItem(
                            lable: "Shares Held After Transaction",
                            value: data?.securitiesOwned,
                          ),
                          InnerRowItem(
                            lable: "Transaction Date",
                            value: data?.transactionDateNew,
                          ),
                          const InnerRowItem(
                            lable: "Details",
                            link: true,
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return InsidersDetailsItem(
                  leadingClick: () {
                    Navigator.pushNamed(context, InsiderDetailsType.path,
                        arguments: {
                          "companySlug": data?.companySlug,
                          "reportingSlug": data?.reportingSlug,
                          "companyName": data?.companyName,
                          "reportingName": data?.reportingName,
                        });
                  },
                  symbol: data?.symbol ?? '',
                  leading: data?.reportingName,
                  trailing: data?.transactionType,
                  index: index,
                  isOpen: provider.indexCompany == index,
                  leadingSubtitle: data?.typeOfOwner,
                  onTap: () => provider.change(
                      provider.indexCompany == index ? -1 : index, true),
                  children: [
                    InnerRowItem(
                      lable: "Shares Bought/Sold",
                      value: "${data?.securitiesTransacted}",
                    ),
                    InnerRowItem(
                      lable: "Total Transaction",
                      value: data?.totalTransaction,
                    ),
                    InnerRowItem(
                      lable: "Shares Held After Transaction",
                      value: data?.securitiesOwned,
                    ),
                    InnerRowItem(
                      lable: "Transaction Date",
                      value: data?.transactionDateNew,
                    ),
                    InnerRowItem(
                      lable: "Details",
                      link: true,
                      value: data?.link,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerVerticel(height: 10);
              },
              itemCount: provider.companyData?.data.length ?? 0),
        ));
  }
}

class InsiderReportingContainer extends StatelessWidget {
  final String? reportingSlug, companySlug;
  const InsiderReportingContainer(
      {super.key, this.reportingSlug, this.companySlug});

  @override
  Widget build(BuildContext context) {
    InsiderTradingDetailsProvider provider =
        context.watch<InsiderTradingDetailsProvider>();
    return BaseUiContainer(
        isLoading: provider.isLoading,
        hasData: provider.reporterData != null,
        error: provider.error,
        errorDispCommon: true,
        onRefresh: () {
          provider.insiderGraphDataInsider(
              companySlug: companySlug ?? "",
              reportingSlug: reportingSlug ?? "");
          provider.getData(
              showProgress: true,
              companySlug: companySlug ?? "",
              reportingSlug: reportingSlug ?? "");
        },
        child: RefreshControll(
          onRefresh: () async {
            provider.insiderGraphDataInsider(
                companySlug: companySlug ?? "",
                reportingSlug: reportingSlug ?? "");
            provider.getData(
                showProgress: true,
                companySlug: companySlug ?? "",
                reportingSlug: reportingSlug ?? "");
          },
          canLoadmore: provider.canLoadMoreReporter,
          onLoadMore: () => provider.getData(
              loadMore: true,
              companySlug: companySlug ?? "",
              clear: false,
              reportingSlug: reportingSlug ?? ""),
          child: ListView.separated(
              padding: EdgeInsets.only(bottom: Dimen.padding.sp),
              itemBuilder: (context, index) {
                InsiderTradingData? data = provider.reporterData?.data[index];

                if (index == 0) {
                  log("$index");
                  return Column(
                    children: [
                      provider.isGraphLoadingInsider
                          ? const CircularProgressIndicator(
                              color: ThemeColors.accent,
                            )
                          : const InsiderDetailGraph(isCompany: false),
                      Divider(
                        color: ThemeColors.greyBorder,
                        height: 15.sp,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            "BOUGHT/SOLD",
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                          const SpacerHorizontal(width: 10),
                          AutoSizeText(
                            maxLines: 1,
                            "TRANSACTIONS",
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                          const SpacerHorizontal(width: 10),
                          AutoSizeText(
                            maxLines: 1,
                            "BUY/SELL",
                            textAlign: TextAlign.end,
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          )
                          // Expanded(
                          //   child: AutoSizeText(
                          //     maxLines: 1,
                          //     "BOUGHT/SOLD",
                          //     style: stylePTSansRegular(
                          //       fontSize: 12,
                          //       color: ThemeColors.greyText,
                          //     ),
                          //   ),
                          // ),
                          // const SpacerHorizontal(width: 10),
                          // Expanded(
                          //   child: AutoSizeText(
                          //     maxLines: 1,
                          //     "TRANSACTIONS",
                          //     style: stylePTSansRegular(
                          //       fontSize: 12,
                          //       color: ThemeColors.greyText,
                          //     ),
                          //   ),
                          // ),
                          // const SpacerHorizontal(width: 10),
                          // Expanded(
                          //   child: AutoSizeText(
                          //     maxLines: 1,
                          //     "BUY/SELL",
                          //     textAlign: TextAlign.end,
                          //     style: stylePTSansRegular(
                          //       fontSize: 12,
                          //       color: ThemeColors.greyText,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      Divider(
                        color: ThemeColors.greyBorder,
                        height: 15.sp,
                        thickness: 1,
                      ),
                      InsidersDetailsItem(
                        isInsider: true,
                        symbol: data?.symbol ?? '',
                        leading: "${data?.securitiesTransacted}",
                        trailing: "${data?.transactionType}",
                        middle: "${data?.totalTransaction}",
                        index: index,
                        isOpen: provider.indexReporting == index,
                        // leadingSubtitle: data?.typeOfOwner,
                        onTap: () => provider.change(
                            provider.indexReporting == index ? -1 : index,
                            false),
                        children: [
                          // InnerRowItem(
                          //   lable: "Shares Bought/Sold",
                          //   value: "${data?.securitiesTransacted}",
                          // ),
                          // InnerRowItem(
                          //   lable: "Total Transaction",
                          //   value: data?.totalTransaction,
                          // ),
                          InnerRowItem(
                            lable: "Shares Held After Transaction",
                            value: data?.securitiesOwned,
                          ),
                          InnerRowItem(
                            lable: "Transaction Date",
                            value: data?.transactionDateNew,
                          ),
                          InnerRowItem(
                            lable: "Details",
                            link: true,
                            value: data?.link,
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return InsidersDetailsItem(
                  isInsider: true,

                  symbol: data?.symbol ?? '',
                  leading: "${data?.securitiesTransacted}",
                  trailing: "${data?.transactionType}",
                  middle: "${data?.totalTransaction}",
                  index: index,
                  isOpen: provider.indexReporting == index,
                  // leadingSubtitle: data?.typeOfOwner,
                  onTap: () => provider.change(
                      provider.indexReporting == index ? -1 : index, false),
                  children: [
                    // InnerRowItem(
                    //   lable: "Shares Bought/Sold",
                    //   value: "${data?.securitiesTransacted}",
                    // ),
                    // InnerRowItem(
                    //   lable: "Total Transaction",
                    //   value: data?.totalTransaction,
                    // ),
                    InnerRowItem(
                      lable: "Shares Held After Transaction",
                      value: data?.securitiesOwned,
                    ),
                    InnerRowItem(
                      lable: "Transaction Date",
                      value: data?.transactionDateNew,
                    ),
                    const InnerRowItem(
                      lable: "Details",
                      link: true,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerVerticel(height: 10);
              },
              itemCount: provider.reporterData?.data.length ?? 0),
        ));
  }
}
