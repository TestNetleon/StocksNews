import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class FaqItem extends StatelessWidget {
  final int openIndex;
  final int index;
  final String question;
  final String answer;
  final dynamic provider;
  final Color textColor;
  final Function()? onTap;

  const FaqItem({
    super.key,
    this.onTap,
    required this.question,
    required this.answer,
    required this.openIndex,
    required this.index,
    this.provider,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // StoreProvider provider = context.watch<StoreProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ThemeColors.greyBorder),
        // border: Border.all(color: ThemeColors.divider),
      ),
      padding: EdgeInsets.all(Dimen.itemSpacing),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap ??
                () => provider
                    .setOpenIndex(provider.faqOpenIndex == index ? -1 : index),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  openIndex == index ? Icons.remove_rounded : Icons.add_rounded,
                  color: ThemeColors.darkGreen,
                ),
                const SpacerHorizontal(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: stylePTSansBold(
                      fontSize: 16,
                      color: openIndex == index
                          ? ThemeColors.themeGreen
                          : textColor,
                      // color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.topCenter,
            child: Container(
              height: openIndex == index ? null : 0,
              padding: EdgeInsets.only(top: Dimen.itemSpacing.sp),
              child: Text(
                answer,
                style: stylePTSansRegular(
                  fontSize: 14,
                  color: textColor,
                  // color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
