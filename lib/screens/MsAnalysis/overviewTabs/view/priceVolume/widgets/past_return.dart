import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MsPricePastReturns extends StatelessWidget {
  const MsPricePastReturns({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> pastReturns = [
      {
        "title": "1 week",
        "amount": "-5.0%",
      },
      {
        "title": "1 month",
        "amount": "3.7%",
      },
      {"title": "3 months", "amount": "13.9%"},
      {"title": "1 year", "amount": "-8.4%"},
      {"title": "4 years", "amount": "141.4%"},
    ];
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return MsPricePastReturnsItem(
          index: index,
          pastReturns: pastReturns[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SpacerVertical(height: 0);
      },
      itemCount: pastReturns.length,
    );
  }
}

class MsPricePastReturnsItem extends StatelessWidget {
  final Map<String, dynamic> pastReturns;
  final int index;
  const MsPricePastReturnsItem({
    super.key,
    required this.pastReturns,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            index % 2 == 0 ? const Color(0xFF2F2F2F) : const Color(0xFF161616),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Text(
              "${pastReturns['title']}",
              textAlign: TextAlign.center,
              style: styleSansBold(
                color: ThemeColors.greyText,
                fontSize: 12,
              ),
            ),
          ),
          const SpacerVertical(height: 10),
          Text(
            textAlign: TextAlign.center,
            "${pastReturns['amount']}",
            style: stylePTSansRegular(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
