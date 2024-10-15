import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/widget/title_tag.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../modals/msAnalysis/complete.dart';

class MsFAQs extends StatefulWidget {
  const MsFAQs({super.key});

  @override
  State<MsFAQs> createState() => _MsFAQsState();
}

class _MsFAQsState extends State<MsFAQs> {
  int openIndex = -1;
  onChange(index) {
    openIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsTextRes? text = provider.completeData?.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(
          title: text?.faq?.title,
          subtitle: text?.faq?.subTitle,
        ),
        ListView.separated(
          itemCount: provider.completeData?.faqData?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 16),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimen.radius.r),
                border:
                    Border.all(color: const Color.fromARGB(255, 252, 251, 251)),
                // color: ThemeColors.background,
              ),
              padding: EdgeInsets.all(Dimen.itemSpacing.sp),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      onChange(openIndex == index ? -1 : index);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            provider.completeData?.faqData?[index].question ??
                                "",
                            style: stylePTSansBold(fontSize: 16),
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Icon(
                          openIndex == index
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
                      height: openIndex == index ? null : 0,
                      padding: EdgeInsets.only(top: Dimen.itemSpacing.sp),
                      child: Text(
                        provider.completeData?.faqData?[index].answer ?? "",
                        style: stylePTSansRegular(
                            fontSize: 14, color: ThemeColors.greyText),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SpacerVertical(height: 12);
          },
        ),
      ],
    );
  }
}
