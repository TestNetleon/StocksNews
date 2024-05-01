import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

import 'insiderDetails/insider_details.dart';

class InsiderContentItem extends StatelessWidget {
  final InsiderTrading? data;
  final bool isOpen;
  final Function() onTap;
  const InsiderContentItem(
      {this.data, super.key, this.isOpen = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  // Text(
                  //   widget.data!.companyName.capitalizeWords(),
                  //   style: stylePTSansRegular(
                  //     color: ThemeColors.greyText,
                  //     fontSize: 12,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, InsiderDetailsType.path,
                          arguments: {
                            "companySlug": data?.companySlug,
                            "companyName": data?.companyName,
                          });
                    },
                    child: Text(
                      "${data?.companyName.capitalizeWords()}",
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SpacerVerticel(height: 5),
                  // Text(
                  //   "${widget.data?.exchangeShortName}:${widget.data?.symbol}",
                  //   style: stylePTSansBold(
                  //     fontSize: 14,
                  //     color: ThemeColors.accent,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, StockDetails.path,
                      //     arguments: data?.symbol);
                      Navigator.pushNamed(context, InsiderDetailsType.path,
                          arguments: {
                            "companySlug": data?.companySlug,
                            "companyName": data?.companyName,
                          });
                    },
                    child: Text(
                      "${data?.exchangeShortName}:${data?.symbol}",
                      // "NYSL:TSLA",
                      style: stylePTSansBold(
                        fontSize: 13,
                        color: ThemeColors.accent,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SpacerVerticel(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, InsiderDetailsType.path,
                          arguments: {
                            "companySlug": data?.companySlug,
                            "reportingSlug": data?.reportingSlug,
                            "companyName": data?.companyName,
                            "reportingName": data?.reportingName,
                          });
                    },
                    child: Text(
                      "${data?.reportingName.capitalizeWords()}",
                      style: stylePTSansBold(
                          fontSize: 14, color: ThemeColors.greyText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SpacerVerticel(height: 5),
                  Text(
                    "${data?.typeOfOwner.capitalizeWords()}",
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
            // Expanded(
            //   flex: 2,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         widget.data!.reportingName.capitalizeWords(),
            //         style: stylePTSansBold(fontSize: 14),
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       const SpacerVerticel(height: 5),
            //       Text(
            //         widget.data!.typeOfOwner.capitalizeWords(),
            //         style: stylePTSansRegular(
            //           color: ThemeColors.greyText,
            //           fontSize: 12,
            //         ),
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ],
            //   ),
            // ),
            // const SpacerHorizontal(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data!.transactionType,
                  style: stylePTSansBold(
                    fontSize: 14,
                    color: data?.transactionType == "Buy"
                        ? ThemeColors.accent
                        : data?.transactionType == "Sell"
                            ? ThemeColors.sos
                            : ThemeColors.white,
                  ),
                ),
                const SpacerVerticel(height: 5),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      // color: data?.transactionType == "Buy"
                      //     ? ThemeColors.accent
                      //     : data?.transactionType == "Sell"
                      //         ? ThemeColors.sos
                      //         : ThemeColors.white,

                      color: ThemeColors.white,
                    ),
                    margin: EdgeInsets.only(left: 8.sp),
                    padding: const EdgeInsets.all(3),
                    child: Icon(
                      isOpen
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: ThemeColors.background,
                      size: 16.sp,
                    ),
                  ),
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
                    lable: "Shares Bought/Sold",
                    value: "${data!.securitiesTransacted}",
                  ),
                  InnerRowItem(
                    lable: "Total Transaction",
                    value: data!.totalTransaction,
                  ),
                  InnerRowItem(
                    lable: "Shares Held After Transaction",
                    value: data!.securitiesOwned,
                  ),
                  InnerRowItem(
                    lable: "Transaction Date",
                    value: data!.transactionDateNew,
                  ),
                  InnerRowItem(
                    lable: "Details",
                    onDetailsClick: () {
                      openUrl(data!.link);
                    },
                  ),
                ],
              )),
        )
      ],
    );
  }
}

class InnerRowItem extends StatelessWidget {
  final String lable;
  final String? value;
  final Function()? onDetailsClick;

  const InnerRowItem({
    required this.lable,
    this.value,
    this.onDetailsClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lable, style: stylePTSansBold(fontSize: 14)),
              Flexible(
                child: onDetailsClick == null
                    ? Text(value ?? '', style: stylePTSansBold(fontSize: 14))
                    : InkWell(
                        onTap: onDetailsClick,
                        child: Text(
                          "See Details",
                          style: stylePTSansBold(
                              fontSize: 14,
                              color: ThemeColors.accent,
                              decoration: TextDecoration.underline),
                        ),
                      ),
              ),
            ],
          ),
        ),
        // Divider(
        //   color: ThemeColors.dividerDark,
        //   height: 1.sp,
        //   thickness: 1.sp,
        // )
        Divider(
          color: ThemeColors.greyBorder,
          height: 1.sp,
        ),
      ],
    );
  }
}
