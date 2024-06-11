import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

//
class InsidersDetailsItem extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? leadingClick;
  final List<Widget> children;
  final String? leading, middle, trailing, leadingSubtitle, price, transacted;
  final String symbol;
  final int index;
  final bool? isOpen;
  final bool isInsider;
  const InsidersDetailsItem({
    required this.index,
    required this.symbol,
    this.onTap,
    this.isOpen,
    super.key,
    this.leading,
    this.middle,
    this.leadingSubtitle,
    this.leadingClick,
    this.trailing,
    required this.children,
    this.isInsider = false,
    this.price,
    this.transacted,
  });

  @override
  Widget build(BuildContext context) {
    //      color: isEven(index) ? null : ThemeColors.background,

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: leading != null,
              child: Expanded(
                flex: middle == null ? 3 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: leadingClick,
                      child: Text(
                        "$leading",
                        // "NYSL:TSLA",
                        style: stylePTSansBold(
                          fontSize: 14,
                          color: ThemeColors.greyText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Visibility(
                        visible: leadingSubtitle != null,
                        child: const SpacerVertical(height: 5)),
                    Visibility(
                      visible: leadingSubtitle != null,
                      child: Text(
                        "$leadingSubtitle",
                        style: stylePTSansRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SpacerHorizontal(width: 10),
            Visibility(
              visible: middle != null,
              child: Expanded(
                flex: 2,
                child: Text(
                  "$middle",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const SpacerHorizontal(width: 10),
            Visibility(
              visible: trailing != null,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("$trailing",
                        // "Buy",
                        style: stylePTSansBold(
                          fontSize: 14,
                          color: trailing == "Buy"
                              ? ThemeColors.accent
                              : trailing == "Sell"
                                  ? ThemeColors.sos
                                  : ThemeColors.white,
                        )),
                    const SpacerVertical(height: 5),
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
                          isOpen == true
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: ThemeColors.background,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SpacerVertical(height: 5),
        Text(
          "$transacted Shares @ $price",
          // "1000 Shares @ 1000",

          style: stylePTSansRegular(
            color: ThemeColors.greyText,
            fontSize: 12,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: isOpen == true ? null : 0,
            // height: open ? null : 0,
            margin: EdgeInsets.only(
              top: isOpen == true ? 10.sp : 0,
              bottom: isOpen == true ? 10.sp : 0,
            ),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class InnerRowItem extends StatelessWidget {
  final String lable;
  final String? value;
  final bool link;
  final TextStyle? style;
  final Color? colorValueIcon;

  final IconData? iconDataValue;

  const InnerRowItem({
    required this.lable,
    this.value,
    this.link = false,
    this.iconDataValue,
    this.style,
    this.colorValueIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value == "") {
      return const SizedBox();
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lable, style: stylePTSansBold(fontSize: 14)),
              const SpacerHorizontal(width: 2),
              Flexible(
                child: !link
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: iconDataValue != null,
                            child: Icon(
                              iconDataValue,
                              size: 16,
                              color: colorValueIcon ?? Colors.white,
                            ),
                          ),
                          Text(value ?? '',
                              style: style ?? stylePTSansBold(fontSize: 14)),
                        ],
                      )
                    : InkWell(
                        onTap: () => openUrl(value),
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
        )
      ],
    );
  }
}
