import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/ownership.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdOwnershipItem extends StatelessWidget {
  final OwnershipList? data;
  final bool isOpen;
  final Function() onTap;

  const SdOwnershipItem({
    this.data,
    super.key,
    this.isOpen = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // flex: 2,
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
                  Text(
                    "${data?.investorName}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 3),
                  // Text(
                  //   "${widget.data?.exchangeShortName}:${widget.data?.symbol}",
                  //   style: stylePTSansBold(
                  //     fontSize: 14,
                  //     color: ThemeColors.accent,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  Text(
                    "${data?.reprtingDate}",
                    style: stylePTSansBold(
                      fontSize: 13,
                      color: ThemeColors.greyText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SpacerVertical(height: 15),
                  // InkWell(
                  //   onTap: () {
                  //     // Navigator.push(context, InsiderDetailsType.path,
                  //     //     arguments: {
                  //     //       "companySlug": data?.companySlug,
                  //     //       "reportingSlug": data?.reportingSlug,
                  //     //       "companyName": data?.companyName,
                  //     //       "reportingName": data?.reportingName,
                  //     //     });
                  //   },
                  //   child: Text(
                  //     "${data?.reportingName}",
                  //     style: stylePTSansBold(
                  //         fontSize: 14, color: ThemeColors.greyText),
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                  // const SpacerVertical(height: 3),
                  // Text(
                  //   "${data?.typeOfOwner.capitalizeWords()}",
                  //   style: stylePTSansRegular(
                  //     color: ThemeColors.greyText,
                  //     fontSize: 12,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data!.sharesNumber,
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    !(data?.changePercent as String).contains('-')
                        ? const Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.arrow_downward_rounded,
                            size: 14,
                            color: Colors.red,
                          ),
                    Text(
                      "${data?.changePercent}",
                      style: stylePTSansRegular(
                        fontSize: 12,
                        color: !(data?.changePercent as String).contains('-')
                            ? ThemeColors.accent
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SpacerHorizontal(width: 10),
            InkWell(
              onTap: onTap,
              child: Container(
                decoration: const BoxDecoration(
                  color: ThemeColors.accent,
                ),
                margin: EdgeInsets.only(left: 0.sp),
                padding: const EdgeInsets.all(3),
                child: Icon(
                  isOpen
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 16,
                ),
              ),
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
                  lable: "Market Value",
                  value: "${data!.marketValue}",
                ),
                InnerRowItem(
                  lable: "Ownership",
                  value: data!.ownership,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class InnerRowItem extends StatelessWidget {
  final dynamic valueColor;
  final String lable;
  final String? value;
  final String? subLabel;
  final String? subValue;
  final Function()? onDetailsClick;

  const InnerRowItem({
    required this.lable,
    this.value,
    this.onDetailsClick,
    this.subLabel,
    this.subValue,
    this.valueColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lable, style: stylePTSansBold(fontSize: 14)),
                  Flexible(
                    child: onDetailsClick == null
                        ? Text("null" == value ? "N/A" : value ?? '',
                            style: stylePTSansBold(
                                fontSize: 14,
                                color: valueColor ?? Colors.white))
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
              if (subLabel != null && subValue != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subLabel ?? "",
                        style: stylePTSansRegular(fontSize: 12)),
                    Flexible(
                      child: Text(
                        subValue ?? "",
                        style: stylePTSansRegular(fontSize: 12),
                      ),
                    ),
                  ],
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
