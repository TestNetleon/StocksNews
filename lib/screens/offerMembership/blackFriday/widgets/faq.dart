import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/membership/store/faq_item.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../modals/faqs_res.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';

class OfferMembershipFaq extends StatelessWidget {
  final int openIndex;
  final dynamic provider;
  final List<FaQsRes>? faq;
  final Color? color;
  const OfferMembershipFaq({
    super.key,
    required this.openIndex,
    this.provider,
    this.faq,
    this.color = ThemeColors.accent,
  });

  // final bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    // BlackFridayProvider provider = context.watch<BlackFridayProvider>();
    // MembershipInfoRes? data = provider.membershipInfoRes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Frequently asked question',
            style: styleSansBold(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
        // const SpacerVertical(height: 10),
        Container(
          // color: Colors.black,
          // color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return FaqItem(
                question: "${faq?[index].question}",
                answer: "${faq?[index].answer}",
                openIndex: provider.faqOpenIndex,
                index: index,
                provider: provider,
                color: color,
              );
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 12);
            },
            itemCount: faq?.length ?? 0,
          ),
        ),
      ],
    );
  }
}
