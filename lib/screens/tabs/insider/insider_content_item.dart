import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class InsiderContentItem extends StatefulWidget {
  final InsiderTrading? data;
  const InsiderContentItem({this.data, super.key});

  @override
  State<InsiderContentItem> createState() => _InsiderContentItemState();
}

//
class _InsiderContentItemState extends State<InsiderContentItem> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              open = !open;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.data?.exchangeShortName}:${widget.data?.symbol}",
                      style: stylePTSansBold(
                        fontSize: 14,
                        color: ThemeColors.accent,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVerticel(height: 5),
                    Text(
                      widget.data!.companyName.capitalizeWords(),
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
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data!.reportingName.capitalizeWords(),
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVerticel(height: 5),
                    Text(
                      widget.data!.typeOfOwner.capitalizeWords(),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.data!.transactionType,
                      style: stylePTSansBold(
                        fontSize: 14,
                        color: widget.data?.transactionType == "Buy"
                            ? ThemeColors.accent
                            : widget.data?.transactionType == "Sell"
                                ? ThemeColors.sos
                                : ThemeColors.white,
                      ),
                    ),
                    const SpacerVerticel(height: 5),
                    Container(
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
                        open
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: ThemeColors.background,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
              height: open ? null : 0,
              margin: EdgeInsets.only(
                top: open ? 10.sp : 0,
                bottom: open ? 10.sp : 0,
              ),
              child: Column(
                children: [
                  InnerRowItem(
                    lable: "Shares Bought/Sold",
                    value: "${widget.data!.securitiesTransacted}",
                  ),
                  InnerRowItem(
                    lable: "Total Transaction",
                    value: widget.data!.totalTransaction,
                  ),
                  InnerRowItem(
                    lable: "Shares Held After Transaction",
                    value: widget.data!.securitiesOwned,
                  ),
                  InnerRowItem(
                    lable: "Transaction Date",
                    value: widget.data!.transactionDateNew,
                  ),
                  InnerRowItem(
                    lable: "Details",
                    onDetailsClick: () {
                      openUrl(widget.data!.link);
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
