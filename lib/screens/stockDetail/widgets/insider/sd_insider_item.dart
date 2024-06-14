import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_insider_res.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdInsiderItem extends StatelessWidget {
  final InsiderDatum? data;
  final bool isOpen;
  final Function() onTap;
//
  const SdInsiderItem({
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, InsiderDetailsType.path,
                                  arguments: {
                                    "companySlug": data?.companySlug,
                                    "reportingSlug": data?.reportingSlug,
                                  });
                            },
                            child: Text(
                              "${data?.name}",
                              style: stylePTSansBold(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            child: Text(
                              "${data?.companySlug}",
                              style: stylePTSansBold(
                                fontSize: 14,
                                color: ThemeColors.greyText,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SpacerVertical(height: 3),

                      // const SpacerVertical(height: 3),
                      // Text(
                      //   "${data?.company}",
                      //   style: stylePTSansBold(
                      //       fontSize: 14, color: ThemeColors.greyText),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      const SpacerVertical(height: 3),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data?.transactionType ?? "",
                      style: stylePTSansBold(
                          fontSize: 14,
                          color: data?.transactionType == "Purchase"
                              ? ThemeColors.accent
                              : ThemeColors.sos),
                    ),
                    const SpacerVertical(height: 5),
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
                    //     // ignore: prefer_const_constructors
                    //     decoration: BoxDecoration(
                    //       // color: data?.transactionType == "Buy"
                    //       //     ? ThemeColors.accent
                    //       //     : data?.transactionType == "Sell"
                    //       //         ? ThemeColors.sos
                    //       //         : ThemeColors.white,

                    //       color: ThemeColors.white,
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
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: isOpen ? null : 0,
            margin: EdgeInsets.only(
              top: isOpen ? 10.sp : 0,
              bottom: isOpen ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  label: 'Shares Bought/Sold "@" Price',
                  value: "${data!.shares}",
                ),
                InnerRowItem(
                  label: "Total Transaction",
                  value: "${data?.totalTxn}",
                ),
                InnerRowItem(
                  label: "Shares Held After Transaction ",
                  value: "${data!.shareAfterTxn}",
                ),
                InnerRowItem(
                  label: "Transaction Date",
                  value: "${data?.transactionDate}",
                ),
                InnerRowItem(
                  label: "Filing Date",
                  value: "${data?.filingDate}",
                ),
                SpacerVertical(height: 10.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Details", style: stylePTSansRegular(fontSize: 14)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => openUrl(data?.detail),
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
