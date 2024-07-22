import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/screens/membership/store/faq_item.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewMembershipFaq extends StatefulWidget {
  const NewMembershipFaq({super.key});

  @override
  State<NewMembershipFaq> createState() => _NewMembershipFaqState();
}

class _NewMembershipFaqState extends State<NewMembershipFaq> {
  // final bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();
    MembershipInfoRes? data = provider.membershipInfoRes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Frequently asked question',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        // const SpacerVertical(height: 10),
        Container(
          color: Colors.black,
          // color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return FaqItem(
                question: "${data?.faq[index].question}",
                answer: "${data?.faq[index].answer}",
                openIndex: provider.faqOpenIndex,
                index: index,
                provider: provider,
              );
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 12);
            },
            itemCount: data?.faq.length ?? 0,
          ),
        ),
      ],
    );
  }
}
