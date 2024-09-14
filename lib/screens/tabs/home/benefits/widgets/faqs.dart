import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/store_info_res.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../membership/store/faq_item.dart';

class AffiliateBenefitsFAQs extends StatefulWidget {
  final List<Benefit>? faqs;
  const AffiliateBenefitsFAQs({super.key, this.faqs});

  @override
  State<AffiliateBenefitsFAQs> createState() => _AffiliateBenefitsFAQsState();
}

class _AffiliateBenefitsFAQsState extends State<AffiliateBenefitsFAQs> {
  int _faqOpenIndex = -1;

  void setOpenIndex(index) {
    _faqOpenIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.faqs == null || widget.faqs?.isEmpty == true) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacerVertical(height: 20),
        Text(
          "Frequently Asked Questions",
          style: stylePTSansBold(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        const SpacerVertical(height: 15),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return FaqItem(
              question: "${widget.faqs?[index].question}",
              answer: "${widget.faqs?[index].answer}",
              openIndex: _faqOpenIndex,
              index: index,
              onTap: () {
                setOpenIndex(_faqOpenIndex == index ? -1 : index);
              },
              textColor: Colors.black,
            );
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical(height: 12);
          },
          itemCount: widget.faqs?.length ?? 0,
        ),
      ],
    );
  }
}
