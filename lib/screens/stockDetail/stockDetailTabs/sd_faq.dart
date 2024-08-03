import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdFaqCard extends StatelessWidget {
  final FaQsRes? data;
  final int index;
  final int openIndex;
  final Function(int) onCardTapped;
  const SdFaqCard({
    super.key,
    required this.data,
    required this.index,
    required this.openIndex,
    required this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    bool isOpen = openIndex == index;
    return GestureDetector(
      onTap: () {
        onCardTapped(index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimen.radius.r),
          border: Border.all(color: ThemeColors.greyBorder),
        ),
        padding: EdgeInsets.all(Dimen.itemSpacing.sp),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    data?.question ?? "",
                    style: stylePTSansBold(fontSize: 16),
                  ),
                ),
                const SpacerVertical(height: 5),
                Icon(
                  isOpen ? Icons.remove_rounded : Icons.add_rounded,
                  color: ThemeColors.lightGreen,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              alignment: Alignment.topCenter,
              child: Container(
                height: isOpen ? null : 0,
                padding: EdgeInsets.only(top: Dimen.itemSpacing.sp),
                child: Text(
                  data?.answer ?? "",
                  style: stylePTSansRegular(
                      fontSize: 14, color: ThemeColors.greyText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
