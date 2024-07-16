import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/store_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class FaqItem extends StatelessWidget {
  final int openIndex;
  final int index;
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    required this.openIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    StoreProvider provider = context.watch<StoreProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ThemeColors.divider),
      ),
      padding: EdgeInsets.all(Dimen.itemSpacing.sp),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => provider
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
                    style: stylePTSansBold(fontSize: 16, color: Colors.black),
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
                "${answer} sdij fosijdf iopsjdfiosdjf soifj iosdjf oijs dfiojsdfio jsdfioj sdiofjsdiofjspdoifj ",
                style: stylePTSansRegular(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
