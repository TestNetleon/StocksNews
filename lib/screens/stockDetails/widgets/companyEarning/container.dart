import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_other_detail_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'item.dart';

class CompanyEarningStockDetail extends StatelessWidget {
  const CompanyEarningStockDetail({super.key});
//
  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    Earning? earning = provider.otherData?.earning;
    if (provider.otherLoading &&
        provider.otherData?.earning?.data?.isEmpty == true) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: ThemeColors.accent,
            ),
            const SpacerHorizontal(width: 5),
            Flexible(
              child: Text(
                "Fetching company earning data...",
                style: stylePTSansRegular(color: ThemeColors.accent),
              ),
            ),
          ],
        ),
      );
    }

    if (!provider.otherLoading &&
        provider.otherData?.earning?.data?.isEmpty == true) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Column(
        children: [
          // ScreenTitle(
          //   // title: earning?.title ?? "",
          //   subTitle: earning?.text,
          // ),
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
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                                maxLines: 1,
                                "EPS (Earnings Per Share)",
                                style: stylePTSansRegular(
                                  fontSize: 12,
                                  color: ThemeColors.greyText,
                                )),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AutoSizeText(
                              maxLines: 1,
                              "REVENUE",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
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
        ],
      ),
    );
  }
}
