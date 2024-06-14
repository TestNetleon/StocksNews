import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/analyst_forecast.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/ownership/ownership_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdStocksRating extends StatelessWidget {
  final AnalystForecast? data;
  final bool isOpen;
  final Function() onTap;
//
  const SdStocksRating({
    required this.data,
    required this.isOpen,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data?.analystName}",
                        style: stylePTSansBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${data?.brokerage}",
                        style: stylePTSansRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data?.priceTarget ?? "",
                      style: stylePTSansBold(
                        fontSize: 14,
                      ),
                    ),
                    const SpacerVertical(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        data?.upDown > 0
                            ? Icon(
                                Icons.arrow_upward,
                                size: 14,
                                color: data?.upDown > 0
                                    ? Colors.green
                                    : Colors.red,
                              )
                            : Icon(
                                Icons.arrow_downward_rounded,
                                size: 14,
                                color: data?.upDown > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                        Text(
                          "${data?.upDown ?? ""}%",
                          style: stylePTSansBold(
                            fontSize: 14,
                            color: data?.upDown > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                        InkWell(
                          onTap: onTap,
                          // onTap: () {
                          //   provider.setOpenIndex(
                          //     provider.openIndex == index ? -1 : index,
                          //   );
                          // },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: ThemeColors.accent,
                            ),
                            margin: EdgeInsets.only(left: 8.sp),
                            padding: const EdgeInsets.all(3),
                            child: Icon(
                              // provider.openIndex == index
                              isOpen
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 16,
                            ),
                          ),
                        )
                        // GestureDetector(
                        //   onTap: () {
                        //     provider.setOpenIndex(
                        //       provider.openIndex == index ? -1 : index,
                        //     );
                        //   },
                        //   child: Container(
                        //     decoration: const BoxDecoration(
                        //       color: ThemeColors.accent,
                        //     ),
                        //     margin: EdgeInsets.only(left: 8.sp),
                        //     padding: const EdgeInsets.all(3),
                        //     child: Icon(
                        //       provider.openIndex == index
                        //           ? Icons.arrow_upward_rounded
                        //           : Icons.arrow_downward_rounded,
                        //       color: ThemeColors.background,
                        //       size: 16.sp,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            // height: provider.openIndex == index ? null : 0,
            height: isOpen ? null : 0,
            margin: EdgeInsets.only(
              // top: provider.openIndex == index ? 10.sp : 0,
              top: isOpen ? 10.sp : 0,
              // bottom: provider.openIndex == index ? 10.sp : 0,
              bottom: isOpen ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "Date",
                  value: "${data?.date}",
                ),
                InnerRowItem(
                  lable: "Price when Posted",
                  value: "${data?.priceWhenPosted}",
                ),
                SpacerVertical(height: 10.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Details", style: stylePTSansRegular(fontSize: 14)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => openUrl(data?.newsUrl),
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ThemeColors.accent,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Text(
                            "View Detail",
                            style: styleGeorgiaRegular(),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
