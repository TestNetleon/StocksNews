import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/providers/faq_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class FAQItem extends StatelessWidget {
  final int index;

  const FAQItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    FaqProvide provider = context.watch<FaqProvide>();
    FaQsRes? faq = context.watch<FaqProvide>().data?[index];

    if (faq == null) {
      return const SizedBox();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimen.radius.r),
        border: Border.all(color: ThemeColors.greyBorder),
        color: ThemeColors.background,
      ),
      padding: EdgeInsets.all(Dimen.itemSpacing.sp),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                provider.change(provider.openIndex == index ? -1 : index),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: stylePTSansBold(fontSize: 16),
                  ),
                ),
                const SpacerVerticel(height: 5),
                Icon(
                  provider.openIndex == index
                      ? Icons.remove_rounded
                      : Icons.add_rounded,
                  color: ThemeColors.lightGreen,
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.topCenter,
            child: Container(
              height: provider.openIndex == index ? null : 0,
              padding: EdgeInsets.only(top: Dimen.itemSpacing.sp),
              child: Text(
                faq.answer,
                style: stylePTSansRegular(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
