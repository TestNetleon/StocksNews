import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PastReturns extends StatelessWidget {
  const PastReturns({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
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
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? const Color.fromARGB(255, 63, 63, 63)
                    : const Color.fromARGB(255, 22, 22, 22),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${pastReturns[index]['title']}",
                    textAlign: TextAlign.center,
                    style: styleSansBold(
                      // color: Colors.black,
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                  ),
                  const SpacerVertical(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    "${pastReturns[index]['amount']}",
                    style: stylePTSansRegular(
                      // color: Colors.black,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical(height: 0);
          },
          itemCount: pastReturns.length,
        ),
      ],
    );
  }
}
