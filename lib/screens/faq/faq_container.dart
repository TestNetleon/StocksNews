import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/providers/faq_provider.dart';
import 'package:stocks_news_new/screens/faq/faq_item.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FAQContainer extends StatelessWidget {
  const FAQContainer({super.key});
//
  @override
  Widget build(BuildContext context) {
    List<FaQsRes>? faqs = context.watch<FaqProvide>().data;
    if (faqs == null) {
      return const SizedBox();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            itemCount: faqs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 16.sp),
            itemBuilder: (context, index) {
              return FAQItem(index: index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SpacerVertical(height: 12);
            },
          ),
          if (context.read<FaqProvide>().extra?.disclaimer != null)
            DisclaimerWidget(
                data: context.read<FaqProvide>().extra!.disclaimer!)
        ],
      ),
    );
  }
}
