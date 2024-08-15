import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../widget/title_tag.dart';
import 'item.dart';

class MsOurTake extends StatelessWidget {
  const MsOurTake({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GradientText(
        //   "Our Take",
        //   colors: const [
        //     Color.fromARGB(255, 5, 100, 8),
        //     Color.fromARGB(255, 5, 153, 10),
        //     Color.fromARGB(255, 89, 228, 93),
        //     Color.fromARGB(255, 133, 236, 137),
        //   ],
        //   style: styleSansBold(fontSize: 40),
        // ),
        MsTitle(title: "Our Take"),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return MsOurTakeItem();
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 10);
          },
          itemCount: 4,
        ),
      ],
    );
  }
}
